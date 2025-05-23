//
//  BluetoothManager-CMDelegate.swift
//  TesKey Watch App
//
//  Created by aiden on November 14, 2023.
//

import CoreBluetooth

extension BluetoothManager: CBCentralManagerDelegate {
    //MARK: CentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(central.state == .poweredOn) {
            attemptConnection()
        } else if(central.state == .unauthorized) {
            state = .bt_unauthorized
        } else {
            state = .bt_unavailable
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        discoveredPeripherals = []
        connectedPeripheral = peripheral
        state = .connected
        
        //save UUID to savedPeripherals
        let UUIDStr = peripheral.identifier.uuidString
        let savedPeripherals = UserDefaults.standard.array(forKey: "savedPeripherals") as? [String] ?? []
        if !savedPeripherals.contains(UUIDStr) {
            UserDefaults.standard.set(savedPeripherals + [UUIDStr], forKey: "savedPeripherals")
        }
        
        connectedDevice = EscortRadar(peripheral: peripheral, serviceUUID: escortBLEServiceUUID, readCharacteristicUUID: escortBLErxCharacteristicUUID, writeCharacteristicUUID: escortBLEtxCharacteristicUUID)
        
        //start background activity
        backgroundActivity.start()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        discoveredPeripherals.append(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        state = .connect_failed
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, timestamp: CFAbsoluteTime, isReconnecting: Bool, error: Error?) {
        guard (peripheral.name != nil) else {
            return
        }
        
        state = .disconnected
        self.cbCM.connect(peripheral, options: ["CBConnectPeripheralEnableAutoReconnect":true])
        
        connectedDevice = nil
        
        //end background activity
        backgroundActivity.end()
    }
}
