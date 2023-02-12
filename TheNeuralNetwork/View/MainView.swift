//
//  NewsView.swift
//  TheNeuralNetwork
//
//  Created by David Lin on 2023-02-10.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager
    @EnvironmentObject private var newsModel: NewsModel
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Reporter", systemImage: "globe.americas.fill")
                }

            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
        }.task {
            try? await Task.sleep(for: Duration.seconds(1))
            self.launchScreenState.dismiss()
        }
    }
}
