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
    
    class func getDayName(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: Date? = dateFormatter.date(from: dateString)
        let dateFormatterAMPM = DateFormatter()
        dateFormatterAMPM.dateFormat = "EEEE"
        let dateAMPM: String = dateFormatterAMPM.string(from: date!)
        return dateAMPM
    }
    
    class func convertToMinutes(from text: String) -> Int {
        var total = 0
        if text.contains("hour") {
            if let hour = Int(text.components(separatedBy: " ").first ?? "0") {
                total += hour * 60
            }
        }
        if text.contains("mins") {
            if let mins = Int(text.components(separatedBy: " ").last?.replacingOccurrences(of: "mins", with: "") ?? "0") {
                total += mins
            }
        }
        return total
    }
    
    class func getCurrentDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }
}
