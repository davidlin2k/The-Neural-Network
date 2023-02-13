//
//  ContentView.swift
//  The Neural Network
//
//  Created by David Lin on 2023-02-07.
//

import SwiftUI
import Combine
import AVFoundation

struct ContentView: View {
    @State var searchText = ""
    @State var showAlert = false
    
    @EnvironmentObject private var newsModel: NewsModel
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    private func loadHeadlines() {
        self.searchText = ""
        self.newsModel.loadHeadlines()
    }
    
    private func readSummarizedNews() {
        let utterance = AVSpeechUtterance(string: self.newsModel.summarizedNews)
        utterance.pitchMultiplier = 1.0
        utterance.rate = 0.5
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        speechSynthesizer.speak(utterance)
    }
    
    var body: some View {
        VStack {
            Image(systemName: "speaker.wave.2.fill")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .onTapGesture {
                    readSummarizedNews()
                }
            
            Picker("Select Country", selection: $newsModel.selection) {
                ForEach(NewsModel.Country.allCases, id: \.self) { value in
                    Text(value.description).tag(value)
                            }
                        }
            .pickerStyle(.menu)
            
            Text("Hello, world!")
            
            ScrollView {
                Text(newsModel.summarizedNews)
                    .padding(.horizontal)
                    .textSelection(.enabled)
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
            .environmentObject(NewsModel(newsService: NewsAPIService(), gptService: RealGPT3Service(), loadNews: true))
    }
}
