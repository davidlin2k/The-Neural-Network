//
//  NewsCategoryView.swift
//  TheNeuralNetwork
//
//  Created by David Lin on 2023-02-12.
//

import SwiftUI

struct NewsCategoryView: View {
    var imageName: String
    var categoryName: String
    var categoryValue: String
    var onTap: (String) -> Void
    
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(named: imageName)!)
                .resizable()
                .frame(width: 100, height: 100)
                .aspectRatio(contentMode: .fit)
            
            Text(categoryName)
        }.onTapGesture() {
            onTap(categoryValue)
        }
    }
}
