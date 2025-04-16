// Device.swift
// ESCiOS
//
// Copyright 2025 - Koios Digital, LLC
//

import CoreBluetooth
import os

class Device: NSObject {
    let peripheral: CBPeripheral!
    
    let serviceUUID: CBUUID!
    let readCharacteristicUUID: CBUUID!
    let writeCharacteristicUUID: CBUUID!
    
    let logger = Logger(subsystem: "Devices", category: "Device")
    
    var readCharacteristic: CBCharacteristic?
    var writeCharacteristic: CBCharacteristic?
    
    init(peripheral: CBPeripheral, serviceUUID: CBUUID, readCharacteristicUUID: CBUUID, writeCharacteristicUUID: CBUUID) {
        self.peripheral = peripheral
        self.serviceUUID = serviceUUID
        self.readCharacteristicUUID = readCharacteristicUUID
        self.writeCharacteristicUUID = writeCharacteristicUUID
        
        super.init()
        
        self.peripheral.delegate = self
        
        var foundService: CBService? = nil
        for service in peripheral.services ?? [] {
            if service.uuid == self.serviceUUID {
                foundService = service
                break
            }
        }
        
        if foundService == nil {
            peripheral.discoverServices([self.serviceUUID])
        } else {
            peripheral.discoverCharacteristics([self.readCharacteristicUUID, self.writeCharacteristicUUID], for: foundService!)
        }
    }
    
    //MARK: Functions to implement in subclass
    func initializeCommunications() {
        logger.warning("Function initializeCommunications unimplemented")
    }
    
    func beep(type: BeepType) {
        logger.warning("Function beep unimplemented")
    }
    
    func validatePacket(data: [UInt8]) -> Bool {
        logger.warning("Function validatePacket unimplemented")
        return false
    }
    
    func handlePacket(data: [UInt8]) {
        logger.warning("Function handlePacket unimplemented")
    }
}

enum AlertType: UInt8 {
    case POLICE = 0
    case MOVING_POLICE = 1
    case SPEED_CAMERA = 2
    case MOBILE_CAMERA = 3
    case ACCIDENT = 4
    case WORK_ZONE = 5
    case ROAD_HAZARD = 6
    case DETOUR = 7
    case TRAFFIC_JAM = 8
}
