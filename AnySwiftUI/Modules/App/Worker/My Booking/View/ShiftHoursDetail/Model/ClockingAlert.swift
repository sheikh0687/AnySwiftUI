//
//  ClockingAlert.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 14/04/26.
//

import Foundation

// MARK: - Alert Model
struct LocationAlert: Identifiable {
    let id      = UUID()
    let title:   String
    let message: String
}

struct ClockInError: Identifiable {
    let id      = UUID()
    let message: String
    let address: String
}

struct BreakPopup: Identifiable {
    let id         = UUID()
    let head:      String
    let desc:      String
    let desc2:     String        // empty for row 2 & dynamic
    let cartID:    String
    let clientID:  String
    let from:      String        // "0", "1", "2", or "Dynamic"
    let breakType: String
    let breakTime: String        // only set for dynamic
}
