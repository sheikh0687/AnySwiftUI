//
//  EditProfileViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 27/05/26.
//

import Observation
import UIKit
import CountryPicker

@Observable
class EditProfileViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    var showSuccessAlert: Bool = false
    var successMessage: String = ""
    
    var firstName: String = ""
    var lastName: String = ""
    var mobileNumber: String = ""
    var mobileCode: String = ""
    var email: String = ""
    var payNowNumber: String = ""
    var bankName: String = ""
    var bankNumber: String = ""
    var payNowTitle: String = ""
    var payNowPlaceholder: String = ""
    
    var profileImageURL: String = ""
    var jobDocumentURL: String = ""
    var nrcDocumentURL: String = ""
    var businessLogoURL: String = ""
    
    var showCountryPicker = false
    var countryObj: Country?
    
    var showProfilePicker: Bool = false
    var showNRCPicker: Bool = false
    var showDOCPicker: Bool = false
    var showLogoPicker: Bool = false
    var showAddressPicker: Bool = false
    
    var selectedProfileImage: UIImage? = nil
    var selectedNRICImage: UIImage? = nil
    var selectedDOCImage: UIImage? = nil
    var businessLogo: UIImage? = nil
    
    var selectedJobName: String = ""
    var selectedJobiD: String = ""
    var isDocRequired: String = ""
    var doccName: String = ""
    
    var workerDocName: String = ""
    var clientDocName: String = ""
    var businessName: String = ""
    var businessRegNo: String = ""
    var businessAddress: String = ""
    var businessLat: Double = 0.0
    var businessLon: Double = 0.0
    
    var arrayJobTypes: [Res_JobType] = []
    var arrayCountries: [Res_CountryList] = []
    
    let userType = AppState.shared.userType
    
    func fetchJobTypes() async throws -> Api_JobType {
        let paramDict: [String: Any] = [:]
        
        print("fetchJobTypes params: \(paramDict)")
        
        let response = try await Service.shared.request (
            url: Router.get_job_type.url(),
            params: paramDict,
            responseType: Api_JobType.self
        )
        
        return response
    }
    
    func fetchCountryList() async throws -> Api_CountryList {
        let response = try await Service.shared.request (
            url: Router.get_country_list.url(),
            params: [:],
            responseType: Api_CountryList.self
        )
        return response
    }
    
    func fetchProfileDetails() async throws -> Api_LoginResponse {
        var paramDict: [String: Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        
        print("fetchJobTypes params: \(paramDict)")
        
        let response = try await Service.shared.request (
            url: Router.get_profile.url(),
            params: paramDict,
            responseType: Api_LoginResponse.self
        )
        
        return response
    }
    
    func fetchCountryDocDetails() async throws -> Api_CountryDocDetail {
        
        var paramDict: [String : Any] = [:]
        paramDict["country_id"] = AppState.shared.countryiD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_country_details.url(),
            params: paramDict,
            responseType: Api_CountryDocDetail.self
        )
        
        return response
    }
    
    func updateUserProfile() async throws -> Api_LoginResponse {
        
        var paramDict: [String : String] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["email"] = email
        paramDict["first_name"] = firstName
        paramDict["last_name"] = lastName
        paramDict["lat"] = userType == "Client" ? String(businessLat) : ""
        paramDict["lon"] = userType == "Client" ? String(businessLon) : ""
        paramDict["type"] = userType
        paramDict["mobile"] = mobileNumber
        paramDict["mobile_witth_country_code"] = "\(mobileCode)\(mobileNumber)"
        paramDict["mobile_with_code"] = "\(mobileCode)\(mobileNumber)"
        paramDict["ios_register_id"] = AppState.shared.ios_RegisterediD
        
        if userType == "Client" {
            paramDict["business_name"] = businessName
            paramDict["une_register_number"] = businessRegNo
            paramDict["business_address"] = businessAddress
        } else {
            paramDict["pay_now_number"] = payNowNumber
            paramDict["local_bank_number"] = bankNumber
            paramDict["bank_name"] = bankName
            paramDict["job_type_id"] = selectedJobiD
            paramDict["job_type_name"] = selectedJobName
        }
        
        paramDict["register_id"] = ""
        paramDict["about_us"] = ""
        paramDict["address"] = ""
        
        print(paramDict)
        
        var imgParamDict: [String : UIImage] = [:]
        imgParamDict["image"] = selectedProfileImage
        
        if userType == "Client" {
            imgParamDict["business_logo"] = businessLogo
        } else {
            imgParamDict["nrc_document"] = selectedNRICImage
            imgParamDict["job_document"] = selectedDOCImage
        }
        
        print(imgParamDict)
        
        let response = try await Service.shared.uploadSingleMedia (
            url: userType == "Client"
            ? Router.update_profile_client.url()
            : Router.update_profile_worker.url(),
            params: paramDict,
            images: imgParamDict,
            responseType: Api_LoginResponse.self
        )
        
        return response
    }
    
    func validateProfileFields() -> Bool {
        if firstName.isEmpty {
            customError = .customError(message: "Please enter a first name.")
            return false
        } else if lastName.isEmpty {
            customError = .customError(message: "Please enter a last name.")
            return false
        } else if !Utility.isValidEmail(email) {
            customError = .customError(message: "Please enter your valid email address.")
            return false
        } else if !Utility.isValidMobileNumber(mobileNumber) {
            customError = .customError(message: "Please enter your valid mobile number.")
            return false
        }
        
        if userType == "Client" {
            if businessName.isEmpty {
                customError = .customError(message: "Please enter a business name.")
                return false
            } else if businessRegNo.isEmpty {
                customError = .customError(message: "Please enter a business registration number.")
                return false
            } else if businessAddress.isEmpty {
                customError = .customError(message: "Please enter a business address.")
                return false
            }
        }
        return true
    }
}
