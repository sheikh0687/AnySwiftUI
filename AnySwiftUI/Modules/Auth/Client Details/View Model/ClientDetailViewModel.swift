//
//  ClientDetailViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 16/03/26.
//

import Observation
import UIKit
import CountryPicker

@Observable
class ClientDetailViewModel {
    
    var isLoading = false
    var customError: CustomError?
    
    var selectedBusinessProfile: UIImage? = nil
    
    var businessName: String = ""
    var registerNumber: String = ""
    var businessAddress: String = ""
    var businessLat: Double = 0.0
    var businessLon: Double = 0.0
    
    var mobileNumber: String = ""
    
    var showCountryPicker = false
    var countryObj: Country?
    
    var showAddressPicker: Bool = false
    var showCameraPicker: Bool = false
    var navContinue: Bool = false
    
    @MainActor
    func updateClientDetails() async throws -> Api_LoginResponse {
        var paramDict: [String : String] = [:]
        paramDict["user_id"]  =   AppState.shared.useriD
        paramDict["email"]     =   AppState.shared.emailiD
        paramDict["first_name"]  =   AppState.shared.userFirstName
        paramDict["last_name"]  =   AppState.shared.userLastName
        paramDict["business_name"]  =   businessName
        paramDict["une_register_number"]  =   registerNumber
        paramDict["business_address"]  =   businessAddress
        paramDict["lat"]   =        String(businessLat)
        paramDict["lon"]  =        String(businessLon)
        paramDict["type"]     =   AppState.shared.userType
        paramDict["mobile"]     =   AppState.shared.userMobile
        paramDict["ios_register_id"]  =   AppState.shared.ios_RegisterediD
        paramDict["register_id"]  =  emptyString
        paramDict["about_us"]  =   emptyString
        
        print(paramDict)
        
        var paramImgDict: [String : UIImage] = [:]
        paramImgDict["business_logo"] = selectedBusinessProfile
        
        print(paramImgDict)
        
        let response = try await Service.shared.uploadSingleMedia (
            url: Router.update_profile_client.url(),
            params: paramDict,
            images: paramImgDict,
            responseType: Api_LoginResponse.self
        )
        
        return response
    }
    
    func saveCredentials(res: Res_LoginResponse) {
        AppState.shared.clientiD = res.id ?? ""
        AppState.shared.businessName = res.business_name ?? ""
        AppState.shared.businessLogo = res.business_logo ?? ""
        AppState.shared.outletName = res.business_name ?? ""
        AppState.shared.outletImage = res.business_logo ?? ""
    }
    
    func validateLoginFields() -> Bool {
        if businessName.isEmpty {
            customError = .customError(message: "Please Enter Busines Name")
            return false
        } else if registerNumber.isEmpty {
            customError = .customError(message: "Please Enter Register Number")
            return false
        } else if businessAddress.isEmpty {
            customError = .customError(message: "Please Enter Business Address")
            return false
        } else if selectedBusinessProfile == nil {
            customError = .customError(message: "Please Select Business Logo")
            return false
        }
        return true
    }
    
}

