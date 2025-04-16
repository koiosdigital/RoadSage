// EscortRadar.swift
// ESCiOS
//
// Copyright 2025 - Koios Digital, LLC
//

import CoreBluetooth
import os

class EscortRadar: Device {
    
    override func initializeCommunications() {
        sendStatusRequest()
    }
    
    //MARK: Radar Functions
    func sendStatusRequest() {
        let statusRequestPacket = createPacket(commandByte: escort_REQ_STATUS_REQUEST, payload: [])
        peripheral.writeValue(statusRequestPacket, for: writeCharacteristic!, type: .withResponse)
    }
    
    func sendSpeedLimitUpdate(speedLimit: Int) {
        let firstByte = UInt8(((Int(pow(2.0, 7))) - 1) & speedLimit)
        let secondByte = UInt8(speedLimit >> 7)
        let speedLimitPacket = createPacket(commandByte: escort_REQ_SPEED_LIMIT_UPDATE, payload: [firstByte, secondByte])
        peripheral.writeValue(speedLimitPacket, for: writeCharacteristic!, type: .withResponse)
    }
    
    func displayLocation(type: AlertType, distance: Int, heading: Int) {
        let i = (heading / 2) & 0xFF
        
        let database = 1
        let age = 100
        
        // Calculate each byte component with explicit intermediate steps
        let b0 = (type.rawValue & 0x7F)
        
        let typeHighBit = (type.rawValue & 0x80) >> 7
        let distanceLowPart = (distance << 1) & 0x7F
        let b1 = typeHighBit | UInt8(distanceLowPart)
        
        let b2 = (distance >> 6) & 0x7F
        
        let distanceHighPart = (distance >> 13) & 0x7F
        let iPart1 = (i << 3) & 0x7F
        let b3 = distanceHighPart | iPart1
        
        let agePart = (age & 0x03) << 5
        let iPart2 = (i >> 4) & 0x0F
        let dbPart = (database & 0x01) << 4
        let b4 = (agePart | iPart2 | dbPart) & 0x7F
        
        let displayLocationPacket = createPacket(commandByte: escort_REQ_DISPLAY_LOCATION, payload: [b0, b1, UInt8(b2), UInt8(b3), UInt8(b4)])
        peripheral.writeValue(displayLocationPacket, for: writeCharacteristic!, type: .withResponse)
    }

    override func beep(type: BeepType) {
        let beepPacket = createPacket(commandByte: escort_REQ_PLAY_TONE, payload: [type.rawValue])
        peripheral.writeValue(beepPacket, for: writeCharacteristic!, type: .withResponse)
    }
    
    //MARK: Packet Handling
    override func validatePacket(data: [UInt8]) -> Bool {
        if(data[0] != 0xF5 || data.count - 2 != data[1]) {
            return false
        }
        
        return true
    }
    
    override func handlePacket(data: [UInt8]) {
        let commandByte = data[2]
        let length = data[1]
        let payload = Array(data[3..<Int(length + 2)])
        
        switch(commandByte) {
        case escort_RESP_BLUETOOTH_PROTOCOL_UNLOCK_REQUEST:
            let crypto_response = perform_crypto(unlock_payload: payload)
            let responsePacket = createPacket(commandByte: escort_REQ_BLUETOOTH_PROTOCOL_UNLOCK_RESPONSE, payload: crypto_response)
            peripheral.writeValue(responsePacket, for: writeCharacteristic!, type: .withResponse)
            break;
        default:
            logger.warning("Unhandled command byte: \(commandByte)")
            displayLocation(type: .ACCIDENT, distance: 720, heading: 45)
            break;
        }
    }
    
    //MARK: Helper functions
    func createPacket(commandByte: UInt8, payload: [UInt8]) -> Data {
        var data = Data([0xF5, 0x00, 0x00])
        data[1] = UInt8(payload.count + 1)
        data[2] = commandByte
        data.append(contentsOf: payload)
        return data
    }
}
