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
    
    @State var category: String = ""
    
    func onCategoryChange(category: String) {
        self.newsModel.loadHeadlines(category: category)
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                // Picker for country selection
                Picker("Select Country", selection: $newsModel.selection) {
                    ForEach(NewsModel.Country.allCases, id: \.self) { value in
                        Text(value.description).tag(value)
                                }
                            }
                .pickerStyle(.menu)
            
                List {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 5) {
                            // Display all the categories in a horizontal stack
                            NewsCategoryView(imageName: "sports", categoryName: "Sports", categoryValue: "sports", onTap: onCategoryChange)
                            
                        }
                    }.listRowBackground(
                        Rectangle()
                            .background(.clear)
                            .foregroundColor(.clear)
                    ).listRowInsets(
                        EdgeInsets(
                            top: 3,
                            leading: 5,
                            bottom: 3,
                            trailing: 5
                        )
                    )
                    
                    ForEach(self.newsModel.articles) { article in
                        // Add articles
                        ZStack {
                            NavigationLink("", value: article.url ?? "")
                                .opacity(0.0)
                            
                            NewsRow(article: article)
                        }.fixedSize(horizontal: false, vertical: true)
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 5)
                                    .background(.clear)
                                    .foregroundColor(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                                    .padding(
                                        EdgeInsets(
                                            top: 3,
                                            leading: 5,
                                            bottom: 3,
                                            trailing: 5
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
                    newsModel.loadHeadlines()
                }
            }
        }
    }
}
