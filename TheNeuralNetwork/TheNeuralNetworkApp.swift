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
    
    @StateObject var launchScreenState = LaunchScreenStateManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainView()
                
                if launchScreenState.state != .finished {
                    LaunchScreenView()
                }
            }.environmentObject(NewsModel(newsService: newsService, gptService: gptService, loadNews: launchScreenState.state == .finished))
             .environmentObject(launchScreenState)
        }
    }
}
