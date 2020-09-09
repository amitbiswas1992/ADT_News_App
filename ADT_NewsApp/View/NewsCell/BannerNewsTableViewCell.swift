//
//  BannerNewsTableViewCell.swift
//  ADT_NewsApp
//
//  Created by Amit Biswas on 9/8/20.
//  Copyright © 2020 Amit Biswas. All rights reserved.
//

import UIKit

class BannerNewsTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var topCoverageLabel: UILabel! {
        didSet {
            topCoverageLabel.text = "Top coverage"
        }
    }
    
    @IBOutlet weak var newsImageOuterView: UIView! {
        didSet {
            newsImageOuterView.layer.cornerRadius = 8
            newsImageOuterView.clipsToBounds = true
        }
    }
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsSource: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    
    
    
    //MARK: Public Methods
    
    func setData(newsArticle: News) {
        if let imageUrl = newsArticle.urlToImage, let url = URL(string: imageUrl) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.newsImage.image = UIImage(data: data)
                }
            }
        }
        
        self.newsTitle.text = newsArticle.title
        self.newsSource.text = newsArticle.source.name
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
