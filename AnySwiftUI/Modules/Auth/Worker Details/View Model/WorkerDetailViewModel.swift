//
//  WorkerDetailViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 16/03/26.
//

internal import Combine
import UIKit

class WorkerDetailViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var customError: CustomError?

    @Published var selectedProfileImage: UIImage? = nil
    @Published var showCameraActionSheet: Bool = false
    @Published var isWorkerCreated: Bool = false
    
    @MainActor
    func updateWorkerProfile() async throws -> Api_LoginResponse {
        
        isLoading = true
        customError = nil
        
        defer { isLoading = false }
        
        var paramDict: [String : String] = [:]
        paramDict["user_id"]  =   AppState.shared.useriD
        paramDict["email"]     =   AppState.shared.emailiD
        paramDict["first_name"]  =   AppState.shared.userFirstName
        paramDict["last_name"]  =   AppState.shared.userLastName
        paramDict["mobile"]     =   AppState.shared.userMobile
        paramDict["pay_now_number"]  =   emptyString
        paramDict["local_bank_number"]  =   emptyString
        paramDict["bank_name"]  =   emptyString
        paramDict["lat"]   =        ""
        paramDict["lon"]  =        ""
        paramDict["register_id"]  =   ""
        paramDict["type"]     =   AppState.shared.userType
        paramDict["about_us"]  =   "1"
        paramDict["address"]  =   "1"
        
        paramDict["ios_register_id"]  =   AppState.shared.ios_RegisterediD
        paramDict["job_type_id"]     =   emptyString
        paramDict["job_type_name"]     =   emptyString

        print(paramDict)
        
        var paramImgDict: [String : UIImage] = [:]
        paramImgDict["image"] = selectedProfileImage
        
        print(paramImgDict)
        
        let response = try await Service.shared.uploadSingleMedia (
            url: Router.update_profile_worker.url(),
            params: paramDict,
            images: paramImgDict,
            responseType: Api_LoginResponse.self
        )
        
        return response
    }
    
    func validateFields() -> Bool {
        if selectedProfileImage == nil {
            self.customError = .customError(message: "Please select the profile image!")
            return false
        }
        
        return true
    }
}
