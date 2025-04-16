// EscortConstants.swift
// ESCiOS
//
// Copyright 2025 - Koios Digital, LLC
//

import CoreBluetooth

let escortBLEServiceUUID = CBUUID(string: "B5E22DE9-31EE-42AB-BE6A-9BE0837AA344")
let escortBLErxCharacteristicUUID = CBUUID(string: "B5E22DEB-31EE-42AB-BE6A-9BE0837AA344")
let escortBLEtxCharacteristicUUID = CBUUID(string: "B5E22DEA-31EE-42AB-BE6A-9BE0837AA344")

// rx
let escort_RESP_START: UInt8 = 0xF5
let escort_RESP_LOCK_RESPONSE_ERROR: UInt8 = 0x01
let escort_RESP_MUTE_BUTTON_PRESS: UInt8 = 0x80        // d=1
let escort_RESP_GPS_EQUIPPED_RESPONSE: UInt8 = 0x81    // d=1
let escort_RESP_ALERT_RESPONSE: UInt8 = 0x82           // d=0 (no alerts) or d=4*n (n chained alerts)
let escort_RESP_BRIGHTNESS_RESPONSE: UInt8 = 0x83      // d=2
let escort_RESP_LOCK_RESPONSE: UInt8 = 0x84            // d=1
let escort_RESP_DISPLAY_LENGTH_RESPONSE: UInt8 = 0x85  // d=1
let escort_RESP_UNLOCK_RESPONSE: UInt8 = 0x86          // d=1
let escort_RESP_MARKED_LOCATION: UInt8 = 0x87          // d=13
let escort_RESP_ERROR_RESPONSE: UInt8 = 0x88
let escort_RESP_MODEL_NUMBER_RESPONSE: UInt8 = 0x89
let escort_RESP_SETTINGS_RESPONSE: UInt8 = 0x8A  // d>=2 F5038A 0105  or   F5278A 0105 0204 0400 0608 1B04 0703 0803 0900 0A00 0D04 0E00 0F00 1000 1300
                                          // 1400 1500 1601 1700 1A01 (setting no + cur value)
let escort_RESP_SETTINGS_INFORMATION_RESPONSE: UInt8 = 0x8B  // d>=2 F5038B nnF4 (unsupported setting) F5068B 16 00010203 (values for setting 16)
let escort_RESP_BAND_ENABLES_RESPONSE: UInt8 = 0x8C          // d=5
let escort_RESP_BAND_ENABLES_DEFAULTS_RESPONSE: UInt8 = 0x8D
let escort_RESP_FLASH_USAGE_RESPONSE: UInt8 = 0x8E
let escort_RESP_BAND_ENABLES_SUPPORTED_RESPONSE: UInt8 = 0x8F  // d=5
let escort_RESP_FLASH_ERASE_RESPONSE: UInt8 = 0x90             // d=1 (0x00 = flash erased OK, otherwise error)
let escort_RESP_SHIFTER_STATUS_RESPONSE: UInt8 = 0x91
let escort_RESP_VERSION_RESPONSE: UInt8 = 0x92            // d>=7
let escort_RESP_SETTINGS_DEFAULTS_RESPONSE: UInt8 = 0x93  // F50393 0100 (00 is default for setting 01)
let escort_RESP_FIRMWARE_UPDATE_STATUS: UInt8 = 0x94      // d=2
let escort_RESP_MODEL_INFO_RESPONSE: UInt8 = 0x95         // d>=1 f50a95 00 4d6178203336300 (00=escort, 01=Beltronics, 02=Cincinnati Microwave) + Name
let escort_RESP_AUTOLOCK_EVENT: UInt8 = 0x96              // d=0 F50196
let escort_RESP_MARKER_ENABLES_RESPONSE: UInt8 = 0x97     // d=2
let escort_RESP_BUTTON_PRESS_REPORT: UInt8 = 0x98
let escort_RESP_STATUS_RESPONSE: UInt8 = 0x99  // d>=1 f50299 0B | 0BA9 | 03A9 | 0BA92F52000008 | 0BA9073C090200 | 0BA9073C292300
let escort_RESP_MARKER_ENABLES_DEFAULTS_RESPONSE: UInt8 = 0x9A
let escort_RESP_MARKER_ENABLES_SUPPORTED_RESPONSE: UInt8 = 0x9B  // d=2
let escort_RESP_REPORT_BUTTON_PRESS: UInt8 = 0x9C                // d=1
let escort_RESP_MODEL_NUMBER_REQUEST: UInt8 = 0x9D
let escort_RESP_MUTE_RESPONSE: UInt8 = 0x9E
let escort_RESP_POWER_DETECTOR_ON_OFF_RESPONSE: UInt8 = 0x9F
let escort_RESP_UPDATE_APPROVAL_REQUEST: UInt8 = 0xA0              // d=3
let escort_RESP_BLUETOOTH_PROTOCOL_UNLOCK_REQUEST: UInt8 = 0xA1    // d=10
let escort_RESP_BLUETOOTH_PROTOCOL_UNLOCK_RESPONSE: UInt8 = 0xA2   // d=10
let escort_RESP_BLUETOOTH_PROTOCOL_UNLOCK_STATUS: UInt8 = 0xA3     // d=1
let escort_RESP_BLUETOOTH_CONNECTION_DELAY_RESPONSE: UInt8 = 0xA4  // d=2
let escort_RESP_BLUETOOTH_SERIAL_NUMBER_RESPONSE: UInt8 = 0xA5     // d=8
let escort_RESP_SPEED_INFORMATION_REQUEST: UInt8 = 0xA6            // d=1 (data: 01=speed limit, 02=current speed)
let escort_RESP_OVERSPEED_WARNING_REQUEST: UInt8 = 0xA7            // d=1
let escort_RESP_DISPLAY_CAPABILITIES_RESPONSE: UInt8 = 0xA8  // d=1 (bits set: 0=beep supported, 1=display msg supported, 2=display location supported
let escort_RESP_ALERT_RESPONSE_FRONT_REAR: UInt8 = 0xA9      // d=0 (no alets) or d=5*n (n chained alerts)
let escort_RESP_BAND_DIRECTION_RESPONSE: UInt8 = 0xAA
let escort_RESP_SHIFTER_TBD: UInt8 = 0xB6          // d=1
let escort_RESP_UNSUPPORTED_REQUEST: UInt8 = 0xF0  // d=1
let escort_RESP_UNSUPPORTED_SETTING: UInt8 = 0xF4  // response to SETTINGS_INFORMATION_RESPONSE
let escort_RESP_UNKNOWN_SETTING: UInt8 = 0xF3      // response to SETTINGS_CHANGE request for invalid setting code
let escort_RESP_INVALID_RESPONSE_ERROR: UInt8 = 0xFF

// tx
let escort_REQ_START: UInt8 = 0xF5                 // d == data length:
let escort_REQ_LOCK_REQUEST: UInt8 = 0x80          // d=0 current alert lockout
let escort_REQ_UNLOCK_REQUEST: UInt8 = 0x81        // d=0 current alert unlock
let escort_REQ_SETTINGS_INFORMATION: UInt8 = 0x82  // d=1
let escort_REQ_SETTING_CHANGE: UInt8 = 0x83        // d=2 (num,new_val)
let escort_REQ_SETTINGS_REQUEST: UInt8 = 0x84      // d=1 (0x00 ?)
let escort_REQ_BAND_ENABLES_SET: UInt8 = 0x85      // d=5
let escort_REQ_BAND_ENABLES_REQUEST: UInt8 = 0x86  // d=0
let escort_REQ_FLASH_UTILIZATION: UInt8 = 0x87
let escort_REQ_FLASH_ERASE: UInt8 = 0x88      // d=0
let escort_REQ_VERSION_REQUEST: UInt8 = 0x89  // d=0
let escort_REQ_SHIFT_STATUS_REQUEST: UInt8 = 0x8A
let escort_REQ_SHIFTER_CONTROL: UInt8 = 0x8B
let escort_REQ_BAND_ENABLES_SUPPORTED: UInt8 = 0x8C    // d=0
let escort_REQ_BAND_ENABLES_DEFAULT: UInt8 = 0x8D      // d=0
let escort_REQ_BRIGHTNESS: UInt8 = 0x8E                // (guessed - d = 0 or d = 1)
let escort_REQ_SETTINGS_DEFAULTS: UInt8 = 0x8F         // d=1 REQ_(setting number)
let escort_REQ_MARKED_LOCATION: UInt8 = 0x90           // d=13
let escort_REQ_MODEL_INFO_REQUEST: UInt8 = 0x91        // d=0
let escort_REQ_MARKER_ENABLES_REQUEST: UInt8 = 0x92    // d=0
let escort_REQ_MARKER_ENABLES_SET: UInt8 = 0x93        // d=2
let escort_REQ_STATUS_REQUEST: UInt8 = 0x94            // d=0
let escort_REQ_MARKER_ENABLES_SUPPORTED: UInt8 = 0x95  // d=0
let escort_REQ_MARKER_ENABLES_DEFAULTS: UInt8 = 0x96   // d=0
let escort_REQ_GPS_EQUIPPED_REQUEST: UInt8 = 0x97      // d=0
let escort_REQ_LOCKOUT_LIST: UInt8 = 0x98              // d=5 (127, 127, 127, 127, 11) == when auto lockout enabled
                                                // only valid if GPS-equipped DOES NOTHING ON 360  // or (0, 0, 0, 0, 0) == clear all lockout DB
let escort_REQ_DISPLAY_LENGTH: UInt8 = 0x99   // d=0
let escort_REQ_DISPLAY_MESSAGE: UInt8 = 0x9A  // d=XX (see below) or d=2(0x00,0x00 = clear screen)
                                       //  F5 9A XX [message bytes]
let escort_REQ_PLAY_TONE: UInt8 = 0x9B  // d=0,1,2
// 9C -- TBD BOOLEAN, data = 1(0,1)
let escort_REQ_MODEL_NUMBER_RESPONSE: UInt8 = 0x9D  // d=1(0x0=acknowledge) or d=4 (0x01,'0',modelnum1,modelnum2)
let escort_REQ_MUTE: UInt8 = 0x9E                   // d=1 (01/00 mute/unmute)
let escort_REQ_POWER_DETECTOR_ON_OFF: UInt8 = 0x9F
let escort_REQ_MODEL_NUMBER_REQUEST: UInt8 = 0xA0      // d=0
let escort_REQ_UPDATE_APPROVAL_RESPONSE: UInt8 = 0xA1  // d=1 [1=accept, 0=acknowledge, 2=deny]
let escort_REQ_LIVE_ALERT: UInt8 = 0xA2
let escort_REQ_BLUETOOTH_PROTOCOL_UNLOCK_REQUEST: UInt8 = 0xA3   // d=10
let escort_REQ_BLUETOOTH_PROTOCOL_UNLOCK_RESPONSE: UInt8 = 0xA4  // d=10
let escort_REQ_BLUETOOTH_PROTOCOL_UNLOCK_STATUS: UInt8 = 0xA5    // d=1
let escort_REQ_BLUETOOTH_CONNECTION_DELAY_REQUEST: UInt8 = 0xA6  // d=0
let escort_REQ_BLUETOOTH_CONNECTION_DELAY_SET: UInt8 = 0xA7      // d=2 (delay is 2-REQ_word, LSB first)
let escort_REQ_BLUETOOTH_SERIAL_NUMBER_REQUEST: UInt8 = 0xA8     // d=0
let escort_REQ_SPEED_LIMIT_UPDATE: UInt8 = 0xA9                  // d=2
let escort_REQ_ACTUAL_SPEED_UPDATE: UInt8 = 0xAA                 // d=2
let escort_REQ_OVERSPEED_LIMIT_DATA: UInt8 = 0xAB                // d=1 (64 + [0,1,5,7,10,15]) 0 == off, 1 = spd limit, 5-15 = 5-15 over
let escort_REQ_DISPLAY_CAPABILITIES: UInt8 = 0xAC                // d=0
let escort_REQ_DISPLAY_LOCATION: UInt8 = 0xAD                    // d=5
let escort_REQ_DISPLAY_CLEAR_LOCATION: UInt8 = 0xAE              // d=0
let escort_REQ_COMM_INIT: UInt8 = 0xC0                           // d=1 C002XX xx = 16=(bt full o


//MARK: Enums
enum BeepType: UInt8 {
    case short
    case long
    case long2
}
