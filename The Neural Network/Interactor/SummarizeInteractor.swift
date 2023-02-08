//
//  SummarizeInteractor.swift
//  The Neural Network
//
//  Created by David Lin on 2023-02-07.
//

import Foundation
import SwiftUI

protocol SummarizeInteractor {
    func summarize(prompt: String, completion: @escaping (Result<String, Error>) -> Void)
}

// MARK: - Implemetation

struct RealSummarizeInteractor: SummarizeInteractor {
    
    let repository: NLPRepository
    
    init(repository: NLPRepository) {
        self.repository = repository
    }
    
    func summarize(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        repository.summarize(prompt: "Summarizes the following passage for me in a really short paragraph. \(prompt)") { result in
            switch result {
            case .success(let generatedText):
                completion(.success(generatedText))
                print(generatedText)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
