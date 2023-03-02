//
//  NewsRepository.swift
//  The Neural Network
//
//  Created by David Lin on 2023-02-07.
//

import Combine
import Foundation

struct GPTResponse: Decodable {
    let id: String
    let object: String
    let created: Int
    let choices: [Choice]
    let usage: Usage
    
    struct Choice: Decodable {
        let index: Int
        let message: Message
        let finish_reason: String
    }

    struct Message: Decodable {
        let role: String
        let content: String
    }

    struct Usage: Decodable {
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_tokens: Int
    }
}


protocol GPTService {
    func summarize(prompt: String) -> AnyPublisher<String, Error>
}

struct RealGPT3Service: GPTService {
    func summarize(prompt: String) -> AnyPublisher<String, Error> {
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
          "model": "gpt-3.5-turbo",
          "messages": [
            ["role": "system", "content": "You are a news reporter that summarizes news into concise paragraphs. Do not do introduce yourself."],
            ["role": "user", "content": prompt]
          ],
        ] as [String : Any]
        

        return Deferred {
            Future<String, Error> { promise in
                do {
                    let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    
                    let request = NSMutableURLRequest(url: NSURL(string: "https://api.openai.com/v1/chat/completions")! as URL,
                                                      cachePolicy: .useProtocolCachePolicy,
                                                      timeoutInterval: 30.0)
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
                                let response = try decoder.decode(GPTResponse.self, from: data)
                                
                                let generatedText = response.choices[0].message.content
                                
                                promise(.success(generatedText))
                            } catch {
                                promise(.failure(error))
                            }
                        }
                    })
                    
                    dataTask.resume()
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
