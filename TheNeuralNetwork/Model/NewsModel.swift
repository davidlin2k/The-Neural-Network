//
//  NewsModel.swift
//  TheNeuralNetwork
//
//  Created by David Lin on 2023-02-10.
//

import Foundation
import Combine

@MainActor
class NewsModel: ObservableObject {
    @Published var summarizedNews: String
    
    private var subscriptions = Set<AnyCancellable>()
    
    let newsService: NewsService
    let gptService: GPTService
    
    init(newsService: NewsService, gptService: GPTService) {
        self.newsService = newsService
        self.gptService = gptService
        self.summarizedNews = ""
    }
    
    func loadHeadlines(country: String) {
        self.summarizedNews = "loading..."
        
        newsService.fetchHeadlines(country: country)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { articles in
                let newsDescriptions = articles.map({ article in
                    return article.description ?? " "
                }).joined(separator: " ")
                
                self.summarizeText(prompt: "The each different news I will provide to you are seperated by empty lines, summarize all the following news shortly for me in order. Report it as a reporter and report as a whole in full sentences and smooth flow. \(newsDescriptions)")
            })
            .store(in: &subscriptions)
    }
    
    func summarizeText(prompt: String) {
        gptService.summarize(prompt: prompt)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { generatedText in
                self.summarizedNews = generatedText.trimmingCharacters(in: .whitespacesAndNewlines)
            })
            .store(in: &subscriptions)
    }
}
