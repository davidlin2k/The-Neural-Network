//
//  ContentView.swift
//  The Neural Network
//
//  Created by David Lin on 2023-02-07.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var showAlert = false
    @State private var newsText = "Your customized news will be displayed here"
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
            Text(newsText)
                .padding(.horizontal)
            
            Spacer()
            HStack {
                TextField("Discover the latest news stories", text: $searchText)
            
                Button(action: searchNews) {
                    Text("Search")
                }
            }
            .padding(.horizontal)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Please enter a message"), dismissButton: .default(Text("OK")))
        }
    }
    
    func searchNews() {
        if (!searchText.isEmpty) {
            let newsRepo: NewsRepository = NewsAPINewsRepository()
            
            let newsInteractor: NewsInteractor = RealNewsInteractor(repository: newsRepo)
            
            newsInteractor.loadHeadlines(country: "us") { result in
                switch result {
                    
                case .success(let generatedText):
                    let NLPRepo: NLPRepository = RealGPTWebRepository()

                    let NLPInteractor: SummarizeInteractor = RealSummarizeInteractor(repository: NLPRepo)

                    NLPInteractor.summarize(prompt: generatedText) { result in
                        switch result {

                        case .success(let generatedText):
                            newsText = generatedText

                        case .failure(_):
                            newsText = "Failed"
                        }
                    }
                case .failure(_):
                    newsText = "Failed"
                }
            }
            
            
            searchText = ""
        } else {
            showAlert = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}