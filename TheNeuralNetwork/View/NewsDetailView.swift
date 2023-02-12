//
//  NewsDetailView.swift
//  TheNeuralNetwork
//
//  Created by David Lin on 2023-02-11.
//

import SwiftUI

struct NewsDetailView: View {
    let url: String
    
    var body: some View {
        VStack {
            WebView(request: URLRequest(url: URL(string: url)!))
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: URL(string: url)!)
            }
        }.toolbar(.hidden, for: .tabBar)
    }
}
