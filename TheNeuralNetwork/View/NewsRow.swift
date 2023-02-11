//
//  NewsRow.swift
//  TheNeuralNetwork
//
//  Created by David Lin on 2023-02-10.
//

import SwiftUI

struct NewsRow: View {
    var article: Article

    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: URL(string: article.urlToImage ?? ""), urlCache: .imageCache) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                         .scaledToFill()
                         .cornerRadius(5)
                case .failure:
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }

            Text(article.title?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                .bold()
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
