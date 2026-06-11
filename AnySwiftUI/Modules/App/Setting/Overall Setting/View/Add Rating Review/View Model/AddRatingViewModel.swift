//
//  AddRatingViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 10/06/26.
//

import Observation

@MainActor
@Observable
class AddRatingViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    
    var ratingTo: String = ""
    var requestiD: String = ""
    var feedback: String = ""
    var selectedRating: Int = 0
    
    func addRating() async throws -> Api_AddRating {
        var paramDict: [String : Any] = [:]
        paramDict["from_id"] = AppState.shared.useriD
        paramDict["to_id"] = ratingTo
        paramDict["request_id"] = requestiD
        paramDict["rating"] = "5"
        paramDict["feedback"] = feedback
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.add_user_rating_review.url(),
            params: paramDict,
            responseType: Api_AddRating.self
        )
        
        return response
    }
    
    func submitReview(onSuccess: @escaping () -> Void) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await addRating()
            if response.status == "1" {
                onSuccess()
            } else {
                customError = .customError(message: response.message ?? "")
            }
        } catch {
            customError = .customError(message: error.localizedDescription)
        }
    }
}

