//
//  Utility.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/03/26.
//

import Foundation

class Utility {
    
    class func checkNetworkConnectivityWithDisplayAlert(isShowAlert: Bool) -> Bool {
        let isNetworkAvailable = InternetUtilClass.sharedInstance.hasConnectivity()
        return isNetworkAvailable
    }
    
    class func isValidEmail(_ testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidMobileNumber(_ mobileNo: String) -> Bool {
        let digitsOnly = mobileNo.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return digitsOnly.count <= 10 &&
               digitsOnly.first != "0" &&
               digitsOnly.allSatisfy { $0.isNumber }
    }
}
