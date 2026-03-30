//
//  ClientDetailViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 16/03/26.
//

internal import Combine
import UIKit
import CountryPicker

class ClientDetailViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var customError: CustomError?

    @Published var selectedBusinessProfile: UIImage? = nil
    
    @Published var businessName: String = ""
    @Published var registerNumber: String = ""
    @Published var businessAddress: String = ""
    @Published var businessLat: Double = 0.0
    @Published var businessLon: Double = 0.0
    
    @Published var mobileNumber: String = ""
    
    @Published var showCountryPicker = false
    @Published var countryObj: Country?
    
    @Published var navContinue: Bool = false
    
    @MainActor
    func updateClientDetails() async throws -> Api_LoginResponse {
        isLoading = true
        customError = nil
        
        var paramDict: [String : String] = [:]
        paramDict["user_id"]  =   AppState.shared.useriD
        paramDict["email"]     =   AppState.shared.useriD
        paramDict["first_name"]  =   AppState.shared.useriD
        paramDict["last_name"]  =   AppState.shared.useriD
        paramDict["business_name"]  =   businessName
        paramDict["une_register_number"]  =   registerNumber
        paramDict["business_address"]  =   businessAddress
        paramDict["lat"]   =        String(businessLat)
        paramDict["lon"]  =        String(businessLon)
        paramDict["type"]     =   AppState.shared.userType
        paramDict["mobile"]     =   mobileNumber
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
}

