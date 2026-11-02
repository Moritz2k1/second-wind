//
//  CoreBluetoothService.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 02.11.26.
//

import CoreBluetooth
import Combine

class CoreBluetoothService: NSObject, ObservableObject, HeartRateService {
    
    // Constants - UUIDs
    private let HEART_RATE_SERVICE = CBUUID(string: "180D")
    private let BT_CHARACTERISTIC = CBUUID(string: "2A37")
    
    // Variables
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    
    /*
     Observables in the UI
     (private(set) = other parts of app can read but not modify the value)
     */
    @Published private(set) var heartRate: Int = 0
    @Published private(set) var rrIntervals: [Double] = []
    
    @Published private(set) var statusText: String = "Ready"
    @Published private(set) var isConnected: Bool = false
    @Published private(set) var isScanning: Bool = false
    
    // Publisher Conformance -> Must be used because of protocol ($ accesses publisher)
    var heartRatePublisher: AnyPublisher<Int, Never> {
        $heartRate.eraseToAnyPublisher()
    }
    
    var rrIntervalsPublisher: AnyPublisher<[Double], Never> {
        $rrIntervals.eraseToAnyPublisher()
    }
    
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        $isConnected.eraseToAnyPublisher()
    }
    
    func startScanning() {
        guard centralManager.state == .poweredOn
                else {
            statusText = "Bluetooth not powered on"
            return
        }
        
        isScanning = true
        statusText = "Searching for device..."
        
        // Only look for devices with HR services
        centralManager.scanForPeripherals(withServices: [HEART_RATE_SERVICE])
    }
    
    func stopScanning() {
        centralManager.stopScan()
        isScanning = false
    }
}
