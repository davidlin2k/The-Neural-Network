//
//  NewsRepository.swift
//  The Neural Network
//
//  Created by David Lin on 2023-02-07.
//

import Combine
import Foundation

struct Response: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage
    
    struct Choice: Decodable {
        let text: String
        let index: Int
        let finish_reason: String
    }
    
    struct Usage: Decodable {
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_tokens: Int
    }
}

protocol NLPRepository {
    func summarize(prompt: String, completion: @escaping (Result<String, Error>) -> Void)
}

struct RealGPTWebRepository: NLPRepository {
    func summarize(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        var apiKey = ""
        
        if let path = Bundle.main.path(forResource: "Property List", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
           apiKey = dict["GPT3_API_KEY"] as? String ?? ""
        }
        
        let headers = [
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer \(apiKey)"
        ]
        let parameters = [
          "model": "text-davinci-003",
          "prompt": prompt,
          "max_tokens": 256,
          "top_p": 1,
          "frequency_penalty": 0,
          "presence_penalty": 0
        ] as [String : Any]
        

        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

            let request = NSMutableURLRequest(url: NSURL(string: "https://api.openai.com/v1/completions")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 20.0)
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
                      let decoder = JSONDecoder()
                      let response = try decoder.decode(Response.self, from: data)
                      

                      let generatedText = response.choices[0].text

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
