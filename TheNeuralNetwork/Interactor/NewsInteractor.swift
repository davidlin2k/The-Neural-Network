//
//  NewsInteractor.swift
//  The Neural Network
//
//  Created by David Lin on 2023-02-08.
//

import Foundation

protocol NewsInteractor {
    func loadHeadlines(country: String, completion: @escaping (Result<String, Error>) -> Void)
}

// MARK: - Implemetation

struct RealNewsInteractor: NewsInteractor {
    
    let repository: NewsRepository
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func loadHeadlines(country: String, completion: @escaping (Result<String, Error>) -> Void) {
        repository.loadHeadlines(country: country, completion: completion)
    }
}
