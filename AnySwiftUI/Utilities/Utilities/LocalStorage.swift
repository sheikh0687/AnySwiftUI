//
//  LocalStorage.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/03/26.
//

import SwiftUI
internal import Combine

enum AppStorageKey: String {
    case isLoggedIn
    case useriD
    case cardiD
    case userEmail
    case userFirstName
    case userLastName
    case userType
    case userMobile
    case ios_RegisterediD
    case countryiD
}

final class AppState: ObservableObject {
    
    static let shared = AppState()
    
    @AppStorage(AppStorageKey.isLoggedIn.rawValue) var isLoggedIn: Bool = false
    @AppStorage(AppStorageKey.useriD.rawValue) var useriD: String = ""
    @AppStorage(AppStorageKey.cardiD.rawValue) var cardiD: String = ""
    @AppStorage(AppStorageKey.userEmail.rawValue) var emailiD: String = ""
    @AppStorage(AppStorageKey.ios_RegisterediD.rawValue) var ios_RegisterediD: String = ""
    @AppStorage(AppStorageKey.userFirstName.rawValue) var userFirstName: String = ""
    @AppStorage(AppStorageKey.userLastName.rawValue) var userLastName: String = ""
    @AppStorage(AppStorageKey.userType.rawValue) var userType: String = ""
    @AppStorage(AppStorageKey.userMobile.rawValue) var userMobile: String = ""
    @AppStorage(AppStorageKey.countryiD.rawValue) var countryiD: String = ""
    
}
