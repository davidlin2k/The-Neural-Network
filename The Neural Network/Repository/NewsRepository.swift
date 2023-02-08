//
//  NewsRepository.swift
//  The Neural Network
//
//  Created by David Lin on 2023-02-07.
//

import Combine
import Foundation

protocol NewsWebRepository {
    func loadNews(completion: @escaping (Result<String, Error>) -> Void)
}

struct RealNewsWebRepository: NewsWebRepository {
    func loadNews(completion: @escaping (Result<String, Error>) -> Void) {
        var apiKey = ""
        
        if let path = Bundle.main.path(forResource: "Property List", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
           apiKey = dict["API_KEY"] as? String ?? ""
        }
        
        let headers = [
          "accept": "application/json",
          "Cohere-Version": "2022-12-06",
          "content-type": "application/json",
          "authorization": "Bearer \(apiKey)"
        ]
        let parameters = [
          "model": "xlarge",
          "truncate": "END",
          "prompt": "Is Wordle getting tougher to solve? Players seem to be convinced that the game has gotten harder in recent weeks ever since The New York Times bought it from developer Josh Wardle in late January. The Times has come forward and shared that this likely isn't the case. That said, the NYT did mess with the back end code a bit, removing some offensive and sexual language, as well as some obscure words There is a viral thread claiming that a confirmation bias was at play. One Twitter user went so far as to claim the game has gone to \"the dusty section of the dictionary\" to find its latest words.",
          "max_tokens": 40,
          "temperature": 0.8,
          "k": 0,
          "p": 0.75
        ] as [String : Any]
        

        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

            let request = NSMutableURLRequest(url: NSURL(string: "https://api.cohere.ai/generate")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
              if (error != nil) {
                print(error as Any)
              } else {
                  guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                          print("Invalid response")
                          return
                      }
                  
                  do {
                      let json = try JSONSerialization.jsonObject(with: data, options: [])
                      let result = json as? [String: Any]
                      let generatedText = result?["prompt"] as? String ?? ""
                      completion(.success(generatedText))
                  } catch {
                      completion(.failure(error))
                  }
              }
            })

            dataTask.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
