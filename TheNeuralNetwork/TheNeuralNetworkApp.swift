//
//  TheNeuralNetworkApp.swift
//  The Neural Network
//
//  Created by David Lin on 2023-02-07.
//

import SwiftUI

@main
struct TheNeuralNetworkApp: App {
    private var newsService = NewsAPIService()
    private var gptService = RealGPT3Service()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(NewsModel(newsService: newsService, gptService: gptService))
        }
    }
}
