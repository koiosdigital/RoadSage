// EscortRadarDelegate.swift
// ESCiOS
//
// Copyright 2025 - Koios Digital, LLC
//

import CoreBluetooth
import os

extension Device: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            if service.uuid == self.serviceUUID {
                peripheral.discoverCharacteristics([self.writeCharacteristicUUID, self.readCharacteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.uuid == self.writeCharacteristicUUID {
                self.writeCharacteristic = characteristic
            } else if characteristic.uuid == self.readCharacteristicUUID {
                self.readCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        
        initializeCommunications()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        if(error != nil) {
            return
        }
        
        if(characteristic.uuid == self.readCharacteristicUUID && characteristic.value != nil) {
            let data = characteristic.value!

            if(!validatePacket(data: data.bytes)) {
                logger.warning("Packet invalid: \(data.bytes)")
                return
            }
            
            handlePacket(data: data.bytes)
        }
    }
}
