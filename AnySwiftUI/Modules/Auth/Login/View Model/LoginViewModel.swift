//
//  LoginViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 10/02/26.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var userType: String = ""
    
    @Published var isLogin: Bool = false
    @Published var email: String = ""
    
    init(userType: String) {
        self.userType = userType
    }
}
