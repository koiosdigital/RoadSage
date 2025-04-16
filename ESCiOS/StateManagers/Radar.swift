// Radar.swift
//  ESCiOS
//
// Copyright 2025 - Koios Digital, LLC
//

import CoreBluetooth
import os

enum BeepType: UInt8 {
    case short
    case long
    case long2
}

class Radar: NSObject {
    let peripheral: CBPeripheral!
    var readCharacteristic: CBCharacteristic?
    var writeCharacteristic: CBCharacteristic?
    
    let serviceUUID = CBUUID(string: "B5E22DE9-31EE-42AB-BE6A-9BE0837AA344")
    let readUUID = CBUUID(string: "B5E22DEB-31EE-42AB-BE6A-9BE0837AA344")
    let writeUUID = CBUUID(string: "B5E22DEA-31EE-42AB-BE6A-9BE0837AA344")
    
    let logger = Logger(subsystem: "BLE", category: "Radar")
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        
        super.init()
        
        self.peripheral.delegate = self
        
        var foundService: CBService? = nil
        for service in peripheral.services ?? [] {
            if service.uuid == serviceUUID {
                foundService = service
                break
            }
        }
        
        if foundService == nil {
            peripheral.discoverServices([serviceUUID])
        } else {
            peripheral.discoverCharacteristics([readUUID, writeUUID], for: foundService!)
        }
    }
    
    //MARK: Radar Functions
    
    func sendStatusRequest() {
        guard let writeCharacteristic = self.writeCharacteristic else {
            return
        }
        logger.info("Sending status request")
        
        let data: Data = Data([0xF5, 0x01, 0x94])
        peripheral.writeValue(data, for: writeCharacteristic, type: .withResponse)
    }
    
    func beep(type: BeepType) {
        let data = Data([0xF5, 0x02, 0x9B, type.rawValue])
        peripheral.writeValue(data, for: writeCharacteristic!, type: .withResponse)
    }
    
    //MARK: Packet Handling
    
    func handlePacket(data: [UInt8]) {
        let commandByte = data[2]
        let length = data[1]
        
        let lenEnd = length + 2

        let payload = Array(data[3..<Int(lenEnd)])
        
        if(commandByte == 0xA1) {
            logger.info("Unlocking detector")
            let crypto = EscortCrypto()
            let crypto_response = crypto.perform_crypto(unlock_payload: payload)
            var data = Data([0xF5, 0x0B, 0xA4, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
            for i in 0..<10 {
                data[i+3] = UInt8(crypto_response[i])
            }
            logger.info("\(data.bytes)")
            peripheral.writeValue(data, for: writeCharacteristic!, type: .withResponse)
        }
        
        if(commandByte == 0xA3) {
            logger.info("Detector unlocked")
            let data = Data([0xF5, 0x02, 0x9B, 0x01])
            peripheral.writeValue(data, for: writeCharacteristic!, type: .withResponse)
        }
        
        if(commandByte == 0xA7) {
            logger.info("Detector unlocked")
            
        }
    }
}
