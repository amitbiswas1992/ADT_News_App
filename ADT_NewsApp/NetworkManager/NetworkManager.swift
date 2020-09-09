//
//  NetworkManager.swift
//  ADT_NewsApp
//
//  Created by Amit Biswas on 9/9/20.
//  Copyright © 2020 Amit Biswas. All rights reserved.
//

import Foundation

typealias NewsListResult = Result<[News], ADTError>

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init(){}
    
    func getNewsList( apiKey: String, completed: @escaping (_ newsList: Result< [News], ADTError> ) -> Void) {
        
        let urlString = String.init(format: "https://newsapi.org/v2/top-headlines?country=us&apiKey=%@", apiKey)
        
        let endpoint = urlString
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                
                completed(.failure(.invalidResponse))
                
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    completed(.failure(.invalidData))
                    return
                }
                
                if let array = json["articles"] as? [Any] {
                    let data = try JSONSerialization.data(withJSONObject: array, options: [])
                    let newsList = try decoder.decode([News].self, from: data)
                    completed(.success(newsList))
                }
                
            }
            catch {
                print("Error found \(error)")
            }
        }
        
        
        task.resume()
    }
}

