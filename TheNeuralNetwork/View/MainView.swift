//
//  NewsView.swift
//  TheNeuralNetwork
//
//  Created by David Lin on 2023-02-10.
//

import SwiftUI

struct MainView: View {
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
        }
    }
}
