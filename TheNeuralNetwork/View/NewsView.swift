//
//  NewsView.swift
//  TheNeuralNetwork
//
//  Created by David Lin on 2023-02-10.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject private var newsModel: NewsModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State var linkIsActive: Bool = false
    
    @State private var path: [String] = []
    
    var body: some View {
        VStack {
            NavigationStack {
                Picker("Select Country", selection: $newsModel.selection) {
                    ForEach(NewsModel.Country.allCases, id: \.self) { value in
                        Text(value.description).tag(value)
                                }
                            }
                .pickerStyle(.menu)
            
                List(self.newsModel.articles) { article in
                    ZStack {
                        NavigationLink("", value: article.url ?? "")
                        
                        NewsRow(article: article)
                            .fixedSize(horizontal: false, vertical: true)
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 5)
                                    .background(.clear)
                                    .foregroundColor(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                                    .padding(
                                        EdgeInsets(
                                            top: 3,
                                            leading: 5,
                                            bottom: 5,
                                            trailing: 3
                                        )
                                    )
                            )
                            .padding(
                                EdgeInsets(
                                top: 5,
                                leading: 0,
                                bottom: 5,
                                trailing: 0
                            ))
                    }
                }.navigationDestination(for: String.self) { url in
                    NewsDetailView(url: url)
                }.refreshable {
                    newsModel.loadHeadlines(country: newsModel.selection.rawValue)
                }
            }
        }
    }
}
