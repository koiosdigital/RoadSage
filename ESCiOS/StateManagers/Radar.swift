// Radar.swift
//  ESCiOS
//
// Copyright 2025 - Koios Digital, LLC
//

import CoreBluetooth
import os

extension Data {
    var bytes: [UInt8] {
        var byteArray = [UInt8](repeating: 0, count: self.count)
        self.copyBytes(to: &byteArray, count: self.count)
        return byteArray
    }
}

class Radar: NSObject, CBPeripheralDelegate {
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
    
    private func handlePacket(data: [UInt8]) {
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
            var data = Data([0xF5, 0x02, 0x9B, 0x01])
            peripheral.writeValue(data, for: writeCharacteristic!, type: .withResponse)
        }
        
        if(commandByte == 0xA7) {
            logger.info("Detector unlocked")
            var data = Data([0xF5, 0x02, 0x9B, 0x01])
            peripheral.writeValue(data, for: writeCharacteristic!, type: .withResponse)
        }
    }
    
    //MARK: CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([writeUUID, readUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            logger.info("char \(characteristic.uuid.uuidString)")
            if characteristic.uuid == writeUUID {
                self.writeCharacteristic = characteristic
            } else if characteristic.uuid == readUUID {
                self.readCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        
        sendStatusRequest()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        if(error != nil) {
            logger.error("error \(String(describing: error))")
            return
        }
        
        if(characteristic.uuid == readUUID && characteristic.value != nil) {
            let data = characteristic.value!
            let array = data.bytes
            
            logger.info("Data payload: \(array), count: \(data.count), len: \(array[1])")
            
            //validate
            if(array[0] != 0xF5 || data.count - 2 != array[1]) {
                return
            }
            
            handlePacket(data: array)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        if(error != nil) {
            logger.error("error \(String(describing: error))")
            return
        }
        
        logger.info("wrote to \(characteristic.uuid.uuidString)")
    }
}
