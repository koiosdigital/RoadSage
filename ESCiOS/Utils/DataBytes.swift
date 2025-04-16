// DataBytes.swift
//  ESCiOS
//
// Copyright 2025 - Koios Digital, LLC
//

import Foundation

extension Data {
    var bytes: [UInt8] {
        var byteArray = [UInt8](repeating: 0, count: self.count)
        self.copyBytes(to: &byteArray, count: self.count)
        return byteArray
    }
}
