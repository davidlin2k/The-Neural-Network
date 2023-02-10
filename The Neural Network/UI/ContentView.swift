//
//  ContentView.swift
//  The Neural Network
//
//  Created by David Lin on 2023-02-07.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var contentViewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
            ScrollView {
                Text(contentViewModel.newsText)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            HStack {
                TextField("Discover the latest news stories", text: $contentViewModel.searchText)
                    
            
                Button(action: contentViewModel.searchNews) {
                    Text("Search")
                }
            }
            .padding([.leading, .bottom, .trailing])
        }
        .alert(isPresented: $contentViewModel.showAlert) {
            Alert(title: Text("Error"), message: Text("Please enter a message"), dismissButton: .default(Text("OK")))
        }
    }
}

extension ContentView {
    @MainActor class ContentViewModel: ObservableObject {
        private var disposables = Set<AnyCancellable>()
        
        @Published var searchText = ""
        @Published var showAlert = false
        @Published var newsText = "Your customized news will be displayed here"
        
        func searchNews() {
            if (!searchText.isEmpty) {
                let newsRepo: NewsRepository = NewsAPINewsRepository()
                
                let newsInteractor: NewsInteractor = RealNewsInteractor(repository: newsRepo)
                
                newsInteractor.loadHeadlines(country: "us") { result in
                    switch result {
                        
                    case .success(let news):
                        let NLPRepo: NLPRepository = RealGPTWebRepository()

                        let NLPInteractor: SummarizeInteractor = RealSummarizeInteractor(repository: NLPRepo)

                        NLPInteractor.summarize(prompt: news) { result in
                            switch result {

                            case .success(let generatedText):
                                self.newsText = generatedText.trimmingCharacters(in: .whitespacesAndNewlines)

                            case .failure(_):
                                self.newsText = "Failed"
                            }
                        }
                    case .failure(_):
                        self.newsText = "Failed"
                    }
                }
                
                self.searchText = ""
            } else {
                showAlert = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
