//
//  NewsView.swift
//  TheNeuralNetwork
//
//  Created by David Lin on 2023-02-10.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject private var newsModel: NewsModel
    
    var body: some View {
        List(self.newsModel.articles) { article in
            NewsRow(article: article)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
