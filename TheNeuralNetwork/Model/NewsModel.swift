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
    @Published var loadingSummarizedNews: Bool
    @Published var articles: [Article]
    
    private var subscription: AnyCancellable?
    
    let newsService: NewsService
    let gptService: GPTService
    
    init(newsService: NewsService, gptService: GPTService) {
        self.newsService = newsService
        self.gptService = gptService
        self.summarizedNews = ""
        self.loadingSummarizedNews = false
        self.articles = []
    }
    
    func loadHeadlines(country: String) {
        self.loadingSummarizedNews = true
        
        subscription = newsService.fetchHeadlines(country: country)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                self.subscription?.cancel()
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.loadingSummarizedNews = false
                    self.summarizedNews = error.localizedDescription
                }
            }, receiveValue: { articles in
                self.articles = articles
                self.summarizeNews()
            })
    }
    
    func summarizeNews() {
        let newsDescriptions = articles.map({ article in
            return article.description ?? " "
        }).joined(separator: " ")
        
        let prompt =  "The each different news I will provide to you are seperated by empty lines, summarize all the following news shortly for me in order. Report it as a reporter and report as a whole in full sentences and smooth flow. \(newsDescriptions)"
        
        subscription = gptService.summarize(prompt: prompt)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                self.subscription?.cancel()
                self.loadingSummarizedNews = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.summarizedNews = error.localizedDescription
                }
            }, receiveValue: { generatedText in
                self.summarizedNews = generatedText.trimmingCharacters(in: .whitespacesAndNewlines)
            })
    }
}
