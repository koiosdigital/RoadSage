// EscortCrypto.swift
// EscortBLE
//
// Copyright 2025 - Koios Digital, LLC
//
//

import Foundation
import os

func escortXTEA(rounds: Int, v: [UInt32]) -> [UInt32] {
    let key: [UInt32] = [0xB67423AB, 0x7B7F599E, 0x831E63EB, 0x535C1285]
    
    var v0 = v[0]
    var v1 = v[1]
    var sum: UInt32 = 0
    let delta: UInt32 = 0xf160a3d8

    for _ in 1...rounds {
        v0 &+= (((v1 << 4) ^ (v1 >> 5)) &+ v1) ^ (sum &+ key[Int(sum & 3)])
        sum &+= delta
        v1 &+= (((v0 << 4) ^ (v0 >> 5)) &+ v0) ^ (sum &+ key[Int((sum >> 11) & 3)])
    }

    return [v0, v1]
}

func escortPack(escReq: [UInt8]) -> [UInt32] {
    let v0 = UInt32(escReq[0] & 0x7F)
        | (UInt32(escReq[1] & 0x7F) << 7)
        | (UInt32(escReq[2] & 0x7F) << 14)
        | (UInt32(escReq[3] & 0x7F) << 21)
        | (UInt32(escReq[4] & 0x0F) << 28)
    
    let v1 = UInt32((escReq[4] & 0x70) >> 4)
        | (UInt32(escReq[5] & 0x7F) << 3)
        | (UInt32(escReq[6] & 0x7F) << 10)
        | (UInt32(escReq[7] & 0x7F) << 17)
        | (UInt32(escReq[8] & 0x7F) << 24)
        | (UInt32(escReq[9] & 0x01) << 31)
    
    return [v0, v1]
}

func escortUnpack(vv: [UInt32]) -> [UInt8] {
    let v0 = vv[0]
    let v1 = vv[1]
    
    var out = [UInt8](repeating: 0, count: 10)
    
    out[0] = UInt8(v0 & 0x7F)
    out[1] = UInt8((v0 >> 7) & 0x7F)
    out[2] = UInt8((v0 >> 14) & 0x7F)
    out[3] = UInt8((v0 >> 21) & 0x7F)
    
    let b4High = (v1 & 0x07) << 4
    let b4Low = (v0 >> 28) & 0x0F
    out[4] = UInt8(b4High | b4Low)
    
    out[5] = UInt8((v1 >> 3) & 0x7F)
    out[6] = UInt8((v1 >> 10) & 0x7F)
    out[7] = UInt8((v1 >> 17) & 0x7F)
    out[8] = UInt8((v1 >> 24) & 0x7F)
    out[9] = UInt8((v1 >> 31) & 0x01)
    
    return out
}

func perform_crypto(unlock_payload: [UInt8]) -> [UInt8] {
    let packed = escortPack(escReq: unlock_payload);
    let crypt = escortXTEA(rounds: 35, v: packed);
    return escortUnpack(vv: crypt)
}
