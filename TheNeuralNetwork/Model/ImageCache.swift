//
//  ImageCache.swift
//  TheNeuralNetwork
//
//  Created by David Lin on 2023-02-11.
//

import Foundation

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
