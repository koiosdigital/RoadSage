// BackgroundActivity.swift
//  ESCiOS
//
// Copyright 2025 - Koios Digital, LLC
//

import CoreLocation
import os

class BackgroundActivity: NSObject, CLLocationManagerDelegate {
    var activitySession: CLBackgroundActivitySession? = nil
    var serviceSession: CLLocationManager? = nil
    var bluetoothManager: BluetoothManager!
    
    let logger = Logger(subsystem: "BackgroundActivity", category: "BackgroundActivity")
    
    init(bluetoothManager: BluetoothManager) {
        self.bluetoothManager = bluetoothManager
    }
    
    func start() {
        activitySession = CLBackgroundActivitySession()
        serviceSession = CLLocationManager()
        serviceSession?.delegate = self
        
        //request authorization
        if(serviceSession?.authorizationStatus != .authorizedAlways) {
            serviceSession?.requestAlwaysAuthorization()
        } else {
            startLocation()
        }
        
    }
    
    func startLocation() {
        serviceSession?.startUpdatingLocation()
    }
    
    func end() {
        if(activitySession != nil) {
            activitySession!.invalidate()
            logger.info("Activity session invalidated")
            activitySession = nil
        }
        serviceSession?.stopUpdatingLocation()
        serviceSession = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if(manager.authorizationStatus == .authorizedAlways) {
            startLocation()
        } else {
            end()
            bluetoothManager.disconnect()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        logger.info("Location updated")
        
        //dump
        for(index, location) in locations.enumerated() {
            logger.info("Location \(index): \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
}
