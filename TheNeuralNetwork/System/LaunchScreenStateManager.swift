//
//  LaunchScreenStateManager.swift
//  TheNeuralNetwork
//
//  Created by David Lin on 2023-02-11.
//

import Foundation

final class LaunchScreenStateManager: ObservableObject {
    
    @MainActor @Published private(set) var state: LaunchScreenStep = .firstStep
    
    @MainActor func dismiss() {
        Task {
            self.state = .secondStep

            try? await Task.sleep(for: Duration.seconds(1))

            self.state = .finished
        }
    }
}
