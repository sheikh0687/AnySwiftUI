//
//  JobDetail.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 04/05/26.
//

import Foundation

// MARK: - Generic Selection Item Model
 
struct SelectionItem: Identifiable {
    let id: String
    let name: String
    var isSelected: Bool = false
}
 
// MARK: - Picker Mode Enum (replaces headline string)
 
enum PickerMode {
    case outlet
    case jobType
    case schedule
    case numberOfWorkers
    case breakType
    case mealProvision
    case days(existing: [String])   // existing = pre-selected days (for update flow)
}
