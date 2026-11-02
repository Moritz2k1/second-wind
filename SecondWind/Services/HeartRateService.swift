//
//  HeartRateService.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 02.11.26.
//

// Defines blueprint for HeartRateService
protocol HeartRateService: AnyObject {
    
    // Attributes
    var heartRate: Int { get }
    var rrIntervals: [Double] { get }

    var isConnected: Bool { get }
    var statusText: String { get }
    var isScanning: Bool { get }
}
