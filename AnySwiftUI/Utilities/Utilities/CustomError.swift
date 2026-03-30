//
//  CustomError.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/03/26.
//

import Foundation

enum CustomError: LocalizedError, Equatable, Identifiable {
    
    case customError(message: String)
    case networkError
    case validationError(message: String)
    case authenticationFailed

    var id: String {
        localizedDescription
    }
    
    var errorDescription: String? {
        switch self {
        case .customError(let message), .validationError(let message):
            return message
        case .networkError:
            return "Network error. Please check your connection."
        case .authenticationFailed:
            return "Authentication failed. Please check your credentials."
        }
    }
}
