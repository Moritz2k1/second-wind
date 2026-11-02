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
    
    /// Starts scanning for bluetooth devices
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
    
    /// Stops scanning for bluetooth devices
    func stopScanning() {
        centralManager.stopScan()
        isScanning = false
    }
    
    /// Calculate RR-Intervals
    private func parseHRData(data: Data) -> Void {
        
        /*
         First byte contains flags that describe the format and contents
         of incoming Bluetooth heart rate data
         */
        let flags = data[0]
        
        /*
         Bit 0 determines how hr is stored
         0 = 8-bit value
         1 = 16-bit value
         Bitwise AND (&) checks whether bit is 0 set
         */
        
        // Check if heart rate is stored as 8-bit or 16-bit
        let is16Bit = (flags & 0x01) != 0
        
        let hrVal: Int
        
        if is16Bit {
            
            // Combine two bytes into one integer
            hrVal = Int(data[1]) | (Int(data[2]) << 8)
        }
        else {
            hrVal = Int(data[1])
        }
        
        heartRate = hrVal
        
        // Check if RR-intervals are included
        let hasRRIntervals = (flags & 0x10) != 0
        
        if !hasRRIntervals { return }
        
        // Determine where RR-Intervals start
        let rrOffset: Int
        
        if is16Bit {
            rrOffset = 3
        }
        else {
            rrOffset = 2
        }
        
        var intervals: [Double] = []
        var index = rrOffset
        
        // Read RR-Intervals (2 bytes per interval)
        while index + 1 < data.count {
            
            let rawVal = Int(data[index]) | (Int(data[index + 1]) << 8)
            
            // Convert from 1/1024 seconds to milliseconds
            let intervalMS = Double(rawVal) / 1024.0 * 1000.0
            
            intervals.append(intervalMS)
            
            index += 2
        }
        
        rrIntervals = intervals
        
        print("HR: \(hrVal) bpm | RR: \(intervals.map { Int($0) }) ms")
    }
}
