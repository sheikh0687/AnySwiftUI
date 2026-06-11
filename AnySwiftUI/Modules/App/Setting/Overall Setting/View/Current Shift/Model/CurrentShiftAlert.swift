//
//  CurrentShiftAlert.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 27/05/26.
//

import Foundation

enum CurrentShiftAlert: Identifiable {
    case confirmDelete(Res_CurrentShift)
    case confirmUpdate(Res_CurrentShift)
    case error(String)
 
    var id: String {
        switch self {
        case .confirmDelete(let j): return "delete-\(j.id ?? "")"
        case .confirmUpdate(let j): return "update-\(j.id ?? "")"
        case .error(let m):         return "error-\(m)"
        }
    }
}
