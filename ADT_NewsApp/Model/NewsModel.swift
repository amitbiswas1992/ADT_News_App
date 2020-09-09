//
//  NewsModel.swift
//  ADT_NewsApp
//
//  Created by Amit Biswas on 9/9/20.
//  Copyright © 2020 Amit Biswas. All rights reserved.
//

import Foundation

struct News: Codable {
    
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    var source: NewsSource
    
}

struct NewsSource : Codable {
    var id: String?
    var name: String?
    
}
