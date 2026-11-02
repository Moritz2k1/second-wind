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
         
         Check if heart rate is stored as 8-bit or 16-bit
         */
        let is16Bit = (flags & 0x01) != 0
        
        // Variable for extracted hr - value depends on whether sensor uses 8 or 16 bits
        let hrVal: Int
        
        if is16Bit {
            
            /*
             hr is stored in two bytes
             data[1] = lower 8 bits
             data[2] = higher 8 bits
             
             Shift higher byte 8 positions to the left and
             combine both bytes using bitwise OR (|)
             */
            hrVal = Int(data[1]) | (Int(data[2]) << 8)
        }
        else {
            // If sensor uses 8-bit format, hr is stored entirely in second byte
            hrVal = Int(data[1])
        }
        
        // Update current hr -> published to subscribers
        heartRate = hrVal
        
        // Bit 4 determines whether RR-interval data is included
        let hasRRIntervals = (flags & 0x10) != 0
        
        // If no RR-Intervals are available, return (nothing to extract)
        if !hasRRIntervals { return }
        
        /*
         Determine starting position of RR-Interval data
         First byte contains flags
         hr occupies either:
            - 1 byte (8-bit format)
            - 2 byte (16-bit format)
         -> RR-Intervals start at index 2 or 3
         */
        let rrOffset: Int
        
        if is16Bit {
            rrOffset = 3
        }
        else {
            rrOffset = 2
        }
        
        /*
         Store extracted RR-Intervals
         Each interval represents time between two heartbeats
         */
        var intervals: [Double] = []
        
        // Start reading Bluetooth packet at RR-interval offset
        var index = rrOffset
        
        /*
         Each RR-Interval consists of exactly 2 bytes
         Check that at least 2 bytes remain before reading them
         -> prevents accessing index outside data array
         */
        while index + 1 < data.count {
            
            /*
             Combine two consecutive bytes into one 16-bit value
             data[index] = lower 8 bits
             data[index + 1] = higher 8 bits
             
             Shift higher byte 8 positions to the left and
             combine both bytes using bitwise OR
             */
            let rawVal = Int(data[index]) | (Int(data[index + 1]) << 8)
            
            /*
             Bluetooth stores RR-Intervals in units of 1/1024 seconds
             Divide by 1024 to convert into seconds
             Multiply by 1000 to convert seconds into milliseconds
             */
            let intervalMS = Double(rawVal) / 1024.0 * 1000.0
            
            // Add converted interval to array
            intervals.append(intervalMS)
            
            // Move forward by 2 bytes to read next RR-Interval
            index += 2
        }
        
        // Update RR-Interval property
        rrIntervals = intervals
        
        // map { Int($0) } converts the Double values into integers
        print("HR: \(hrVal) bpm | RR: \(intervals.map { Int($0) }) ms")
    }
}

extension CoreBluetoothService: CBCentralManagerDelegate {
    
    /// Called when Bluetooth status changes
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            statusText = "Bluetooth ready"
        case .poweredOff:
            statusText = "Bluetooth powered off"
        case .unauthorized:
            statusText = "Bluetooth not authorized"
        default:
            statusText = "Bluetooth not available"
        }
    }
    
    /// Called when device has been found
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral) {
        
        // Guard constant for peripheral name
        guard let peripheralName = peripheral.name else { return }
        
        // Check if device name matches one of supported devices
        let isSupportedDevice = Configuration.supportedDevices.contains {
            device in peripheralName.contains(device)
        }
        
        // Ignore devices that are not supported
        guard isSupportedDevice else { return }
        
        self.peripheral = peripheral
        statusText = "Device found: \(peripheralName)"
        stopScanning()
        
        // Direct connection
        centralManager.connect(peripheral)
    }
    
    /// Connection successful
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        statusText = "Connected"
        isConnected = true
        peripheral.delegate = self
        
        // Search for HR Services
        peripheral.discoverServices([HEART_RATE_SERVICE])
    }
    
    /// Disconnect (reset values)
    func centralManager(_ central: CBCentralManager) {
        
        statusText = "Disconnected"
        isConnected = false
        heartRate = 0
        rrIntervals = []
    }
}

extension CoreBluetoothService: CBPeripheralDelegate {
    
    /// Discover heart rate service
    func peripheral(_ peripheral: CBPeripheral) {
        
        // All services
        guard let services = peripheral.services else { return }
        
        // Iterate over services
        for service in services {
            if service.uuid == HEART_RATE_SERVICE {
                peripheral.discoverCharacteristics([BT_CHARACTERISTIC], for: service)
            }
        }
    }
    
    /// Discover characteristics and activate notifications
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService) {
        
        // All characteristics
        guard let characteristics = service.characteristics else { return }
        
        // Iterate over characteristics
        for characteristic in characteristics {
            if characteristic.uuid == BT_CHARACTERISTIC {
                // Activate notifications
                peripheral.setNotifyValue(true, for: characteristic)
                statusText = "Heart Rate Stream active"
            }
        }
    }
    
    /// Received new data
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic) {
        
        // Check if this is heart rate characteristic
        if characteristic.uuid != BT_CHARACTERISTIC { return }
        
        // Get received data
        guard let newData = characteristic.value else { return }
        
        // Process heart rate data
        parseHRData(data: newData)
    }
}
