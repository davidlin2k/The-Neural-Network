//
//  LaunchScreenView.swift
//  TheNeuralNetwork
//
//  Created by David Lin on 2023-02-11.
//

import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager
    @EnvironmentObject private var newsModel: NewsModel

    @State private var firstAnimation = false
    @State private var secondAnimation = false // Mark 2
    @State private var startFadeoutAnimation = false // Mark 2
    
    @ViewBuilder
    private var image: some View {  // Mark 3
        Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .scaleEffect(secondAnimation ? 0 : 1) // Mark 4
            .offset(y: secondAnimation ? 400 : 0) // Mark 4
    }
    
    @ViewBuilder
    private var backgroundColor: some View {  // Mark 3
        Color(uiColor: UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)).ignoresSafeArea()
    }
    
    private let animationTimer = Timer // Mark 5
        .publish(every: 0.3, on: .current, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            backgroundColor  // Mark 3
            image  // Mark 3
        }.onReceive(animationTimer) { timerValue in
            updateAnimation()  // Mark 5
        }.opacity(startFadeoutAnimation ? 0 : 1)
    }
    
    private func updateAnimation() { // Mark 5
        switch launchScreenState.state {
        case .firstStep:
            withAnimation(.easeInOut(duration: 1)) {
                firstAnimation.toggle()
            }
        case .secondStep:
            if secondAnimation == false {
                withAnimation(.linear) {
                    self.secondAnimation = true
                    startFadeoutAnimation = true
                }
            }
        case .finished:
            break
        }
    }
    
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(LaunchScreenStateManager())
    }
}
