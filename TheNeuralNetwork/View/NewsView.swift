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
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 5)
                        .background(.clear)
                        .foregroundColor(.white)
                        .padding(
                            EdgeInsets(
                                top: 3,
                                leading: 5,
                                bottom: 3,
                                trailing: 5
                            )
                        )
                )
        }
    }
}
