//
//  ViewController.swift
//  HackerNewsReader
//
//  Created by C McGhee on 3/2/17.
//  Copyright © 2017 Carey McGhee. All rights reserved.
//

import UIKit
import EmptyKit

 func valueForAPIKey(API_KEY:String) -> String {
    
    let filePath = Bundle.main.path(forResource: "Key", ofType: "plist")
    let plist = NSDictionary(contentsOfFile: filePath!)
    let value:String = plist?.object(forKey: API_KEY) as! String
    
    return value
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var articles: [Article]? = []
    
    private let refreshControl = UIRefreshControl()
    
    private let refreshControlTintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArticles()
        setupView()
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
      //MARK: - Cell Padding
       tableView.frame = UIEdgeInsetsInsetRect(tableView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
        
    // MARK: - Expandable View
    //self.expandableTableView.expandableDelegate = self
        
    // EmptyKit
    tableView.ept.dataSource = self as EmptyDataSource
    tableView.ept.delegate = self as EmptyDelegate
        
   
    }
    
   //MARK: - Hiding Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK : UIRefreshControl
    private func setupView() {
        setupTableView()
        setupMessageLabel()
        setupActivityIndicatorView()
        
    }
    
    private func updateView() {
        let hasNews = (articles?.count)! > 0
        tableView.isHidden = !hasNews
        messageLabel.isHidden = hasNews
        
        if hasNews {
            tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.isHidden = true
        
        // Helpers
        let attributes = [ NSForegroundColorAttributeName : refreshControlTintColor ] as [String: Any]
        
        // Configure Refresh Control
        refreshControl.tintColor = refreshControlTintColor
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Hacker News Data ...", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(ViewController.refreshHackerNewsData(sender:)), for: .valueChanged)
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    private func setupMessageLabel() {
        messageLabel.isHidden = true
        messageLabel.text = "No news at this time"
    }
    
    private func setupActivityIndicatorView() {
        activityIndicatorView.startAnimating()
    }
    
    // MARK: - Actions
    func refreshHackerNewsData(sender: UIRefreshControl) {
        fetchArticles()
    }
    
    private let hackerNewsAPIKey = valueForAPIKey(API_KEY: "API_KEY")
    
    func fetchArticles() {
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=hacker-news&sortBy=latest&apiKey=5c73eabb59b7494580fecfd7c17a0abb")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest)  { (data, response, error) in
            
        if error != nil {
                print(error!)
                return
            }
        
            self.articles = [Article] ()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                if let articlesFromJson = json["articles"] as? [[String:AnyObject]] {
                    for articleFromJson in articlesFromJson {
                    let article = Article ()
                        if let title = articleFromJson ["title"] as? String, let author = articleFromJson["author"] as? String, let desc = articleFromJson["description"] as? String, let url = articleFromJson["url"] as? String {
                    
                    article.author = author
                    article.title = title
                    article.desc = desc
                    article.url = url
                        }
                        
                        self.articles?.append(article)
                 }
            }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            
        
            } catch let error {
                print(error)
            }
            
            self.updateView()
            self.refreshControl.endRefreshing()
            self.activityIndicatorView.stopAnimating()
            
}

    task.resume()
        
    }
    

   func numberOfSections(in tableView: UITableView) -> Int {
    
   return 1

   }
    
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! WebView
        
        webVC.url = self.articles?[indexPath.item].url
        
        self.present(webVC, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.Title.text = self.articles?[indexPath.item].title
        cell.Author.text = self.articles?[indexPath.item].author
        cell.Desc.text = self.articles?[indexPath.item].desc
        cell.Url.text = self.articles?[indexPath.item].url
        
        
        return cell
    }
}

    

// MARK - Extension: EmptySet Extension

extension UIViewController: EmptyDataSource {
    
    public func imageForEmpty(in view: UIView) -> UIImage? {
        return UIImage(named: "hackernews")
    }
    
    public func titleForEmpty(in view: UIView) -> NSAttributedString? {
        let title = "No News"
        let font = UIFont.systemFont(ofSize: 14)
        let attributes: [String : Any] = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: font]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    public func buttonTitleForEmpty(forState state: UIControlState, in view: UIView) -> NSAttributedString? {
        let title = "Empty Button"
        let font = UIFont.systemFont(ofSize: 17)
        let attributes: [String : Any] = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: font]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    public func buttonBackgroundColorForEmpty(in view: UIView) -> UIColor {
        return UIColor.clear
    }
    
}

extension UIViewController: EmptyDelegate {
    
    public func emptyButton(_ button: UIButton, tappedIn view: UIView) {
        print( #function, #line, type(of: self))
    }
    
    public func emptyView(_ emptyView: UIView, tappedIn view: UIView) {
        print( #function, #line, type(of: self))
    }
}

