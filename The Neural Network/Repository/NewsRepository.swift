//
//  NewsRepository.swift
//  The Neural Network
//
//  Created by David Lin on 2023-02-08.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
}

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Decodable {
    let id: String?
    let name: String?
}

protocol NewsRepository {
    func loadHeadlines(country: String, completion: @escaping (Result<String, Error>) -> Void)
}

struct NewsAPINewsRepository: NewsRepository {
    func loadHeadlines(country: String, completion: @escaping (Result<String, Error>) -> Void) {
        var apiKey = ""
        
        if let path = Bundle.main.path(forResource: "Property List", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
           apiKey = dict["NEWS_API_KEY"] as? String ?? ""
        }
        
        // Create URL
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)&pageSize=10")
        guard let requestUrl = url else { fatalError() }
        
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data {
                do {
                    
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(NewsResponse.self, from: data)
                    
                    var generatedText = ""
                    
                    for article in response.articles {
                        generatedText.append(article.description ?? " " + "\n\n")
                    }
                    
                    completion(.success(generatedText))
                } catch {
                    completion(.failure(error))
                }
            }
            
        }
        task.resume()
    }
}
