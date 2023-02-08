//
//  NewsInteractor.swift
//  The Neural Network
//
//  Created by David Lin on 2023-02-07.
//

import Foundation
import SwiftUI

protocol NewsInteractor {
    func loadNews(completion: @escaping (Result<String, Error>) -> Void)
}

// MARK: - Implemetation

struct RealNewsInteractor: NewsInteractor {
    
    let newsRepository: NewsWebRepository
    
    init(newsRepository: NewsWebRepository) {
        self.newsRepository = newsRepository
    }
    
    func loadNews(completion: @escaping (Result<String, Error>) -> Void) {
        newsRepository.loadNews() { result in
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
