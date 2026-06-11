//
//  AddUpdateOutletViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 04/06/26.
//

import Observation
import UIKit

@Observable
class AddUpdateOutletViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    
    var outletiD: String = ""
    var outletName: String = ""
    var outletAddress: String = ""
    var outletLogoUrl: String = ""
    
    var outletLat: Double = 0.0
    var outletLon: Double = 0.0
    
    var outletLogoImg: UIImage?
    
    var showAddressPicker: Bool = false
    var showCameraPicker: Bool = false
    
    var responseComplete: Bool = false
    var showSuccessMsg: Bool = false
    var isFor: String = ""
    
    init(outletiD: String, outletName: String, outletAddress: String, outletLat: Double, outletLon: Double, outletLogoUrl: String, isFor: String) {
        self.outletiD = outletiD
        self.outletName = outletName
        self.outletAddress = outletAddress
        self.outletLat = outletLat
        self.outletLon = outletLon
        self.outletLogoUrl = outletLogoUrl
        self.isFor = isFor
    }
    
    @MainActor
    func addOrUpdateOutlet() async throws -> Api_AddOutlet {
        var paramDict: [String : String] = [:]
        
        if isFor == "Update" {
            paramDict["user_id"] = outletiD
        } else {
            paramDict["client_id"] = AppState.shared.useriD
        }
        
        paramDict["business_name"] = outletName
        paramDict["business_address"] = outletAddress
        paramDict["lat"] = String(outletLat)
        paramDict["lon"] = String(outletLon)
        
        print(paramDict)
        
        var imgParamDict: [String : UIImage] = [:]
        imgParamDict["business_logo"] = outletLogoImg
         
        print(imgParamDict)
        
        let response = try await Service.shared.uploadSingleMedia (
            url: isFor == "Update"
            ? Router.update_outlet.url()
            : Router.add_Outlet.url(),
            params: paramDict,
            images: imgParamDict,
            responseType: Api_AddOutlet.self
        )
        
        return response
    }
    
    func validFeilds() -> Bool {
        if outletName.isEmpty {
            customError = .customError(message: "Please enter the outlet name")
            return false
        } else if outletAddress.isEmpty {
            customError = .customError(message: "Please enter the outlet address")
            return false
        }
        
        if isFor == "Add" {
            if outletLogoImg == nil {
                customError = .customError(message: "Please select the outlet logo")
                return false
            }
        }
        return true
    }
}
