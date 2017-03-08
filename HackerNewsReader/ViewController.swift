//
//  ViewController.swift
//  HackerNewsReader
//
//  Created by C McGhee on 3/2/17.
//  Copyright © 2017 Carey McGhee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var articles: [Article]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    tableView.tableFooterView = UIView()
        
    fetchArticles()
    }
    
    func fetchArticles() {
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=hacker-news&sortBy=latest&apiKey=5c73eabb59b7494580fecfd7c17a0abb")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest)  { (data, response, error) in
            
        if error != nil {
                print(error)
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
            
}

    task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
         cell.Title.text = self.articles?[indexPath.item].title
         cell.Author.text = self.articles?[indexPath.item].author
         cell.Desc.text = self.articles?[indexPath.item].desc
        cell.Url.text = self.articles?[indexPath.item].url
        
        
        return cell
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
    
}

