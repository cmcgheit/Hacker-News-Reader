//
//  ArticleCell.swift
//  HackerNewsReader
//
//  Created by C McGhee on 3/2/17.
//  Copyright © 2017 Carey McGhee. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Author: UILabel!
    @IBOutlet weak var Desc: UILabel!
    @IBOutlet weak var Url: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

}
