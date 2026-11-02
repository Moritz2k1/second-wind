//
//  HeartRateService.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 02.11.26.
//

import Combine

// Defines blueprint for HeartRateService
protocol HeartRateService: AnyObject {
    
    // Attributes
    var heartRate: Int { get }
    var rrIntervals: [Double] { get }

    var isConnected: Bool { get }
    var statusText: String { get }
    var isScanning: Bool { get }
    
    // Publishers allow other parts of the app to observe changes
    var heartRatePublisher: AnyPublisher<Int, Never> { get }
    var rrIntervalsPublisher: AnyPublisher<[Double], Never> { get }
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
    
    func startScanning()
    func stopScanning()
}
