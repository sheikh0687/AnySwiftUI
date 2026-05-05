//
//  WorkerCount.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 04/05/26.
//

import Foundation

struct WorkerShift: Identifiable {
    let id = UUID()
    var startTime: Date = Date()
    var endTime: Date = Date()
}

enum ScheduleType: String, CaseIterable {
    case weekly = "Weekly"
    case specificDate = "Specific Date"
    case urgent = "Urgent"
}
