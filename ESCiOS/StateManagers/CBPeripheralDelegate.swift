// Radar.swift
//  ESCiOS
//
// Copyright 2025 - Koios Digital, LLC
//

import CoreBluetooth
import os

extension Radar: CBPeripheralDelegate {
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
