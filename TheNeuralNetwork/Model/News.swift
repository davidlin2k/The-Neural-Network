//
//  News.swift
//  TheNeuralNetwork
//
//  Created by David Lin on 2023-02-10.
//

import Foundation

struct News: Identifiable {
    var id = UUID()
    
    let source: Source
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
}
