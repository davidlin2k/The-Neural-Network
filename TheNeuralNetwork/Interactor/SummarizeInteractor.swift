//
//  SummarizeInteractor.swift
//  The Neural Network
//
//  Created by David Lin on 2023-02-07.
//

import Foundation

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
        repository.summarize(prompt: "The each different news I will provide to you are seperated by empty lines, summarize all the following news shortly for me in order. Report it as a reporter and report as a whole in full sentences and smooth flow. \(prompt)", completion: completion)
    }
}
