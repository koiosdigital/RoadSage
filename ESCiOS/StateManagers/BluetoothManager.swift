//
//  BluetoothManager.swift
//  TesKey Watch App
//
//  Created by aiden on November 14, 2023.
//

import SwiftUI
import CoreBluetooth
import os

enum BluetoothManagerState {
    //CentralManager initialization states
    case powered_off
    case bt_unauthorized
    case bt_unavailable
    
    //App cases
    case not_setup
    case discovering
    case disconnected
    case connecting
    case connect_failed
    case connected
}

class BluetoothManager: NSObject, ObservableObject {
    
    var cbCM: CBCentralManager!
    var userDefaults = UserDefaults.standard
    var backgroundActivity: BackgroundActivity!
    
    let serviceUUID = CBUUID(string: "B5E22DE9-31EE-42AB-BE6A-9BE0837AA344")
    
    @Published var discoveredPeripherals: [CBPeripheral] = [];
    @Published var state: BluetoothManagerState = .powered_off;
    var connectedPeripheral: CBPeripheral? = nil;
    var connectedRadar: Radar? = nil;
    
    override init() {
        super.init()
        cbCM = CBCentralManager(delegate: self, queue: nil)
        cbCM.delegate = self
        backgroundActivity = BackgroundActivity(bluetoothManager: self)
    }
    
    func startDiscovery() {
        cbCM.scanForPeripherals(withServices: [serviceUUID])
        state = .discovering
    }
    
    func stopDiscovery(_ peripheral: CBPeripheral) {
        cbCM.stopScan()
        cbCM.connect(peripheral)
        state = .connecting
    }
    
    func attemptConnection() {
        //Check if we have a saved device.
        let savedPeripherals = userDefaults.value(forKey: "savedPeripherals") as? [String];
        if(savedPeripherals?.isEmpty ?? true) {
            state = .not_setup
        } else {
            let thisPeripheral = cbCM.retrievePeripherals(withIdentifiers: [UUID(uuidString: savedPeripherals!.first!)!])
            guard let peripheral = thisPeripheral.first else {
                state = .not_setup
                userDefaults.setValue([], forKey: "savedPeripherals")
                return
            }
            connectedPeripheral = peripheral
            cbCM.connect(connectedPeripheral!)
            state = .connecting
        }
    }
    
    func unpair() {
        userDefaults.setValue([], forKey: "savedPeripherals")
        state = .not_setup
    }
    
    func disconnect() {
        cbCM.cancelPeripheralConnection(connectedPeripheral!)
    }
}
