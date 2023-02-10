//
//  ContentView.swift
//  The Neural Network
//
//  Created by David Lin on 2023-02-07.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var searchText = ""
    @State var showAlert = false
    
    @EnvironmentObject private var newsModel: NewsModel
    
    private func loadHeadlines() {
        self.searchText = ""
        self.newsModel.loadHeadlines(country: "us")
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
            ScrollView {
                Text(newsModel.summarizedNews)
                    .padding(.horizontal)
            }.overlay {
                if newsModel.loadingSummarizedNews {
                    ProgressView()
                }
            }
            
            Spacer()
            
            HStack {
                TextField("Discover the latest news stories", text: $searchText)
                    
                Button(action: loadHeadlines) {
                    Text("Search")
                }
            }
            .padding([.leading, .bottom, .trailing])
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Please enter a message"), dismissButton: .default(Text("OK")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
