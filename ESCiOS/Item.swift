// Item.swift
//  ESCiOS
//
// Copyright 2025 - Koios Digital, LLC
//


import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
