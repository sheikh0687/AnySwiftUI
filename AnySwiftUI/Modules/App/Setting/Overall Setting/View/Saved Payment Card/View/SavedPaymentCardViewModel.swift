//
//  SavedPaymentCardViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 05/06/26.
//

import Observation

@Observable
@MainActor
class SavedPaymentCardViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?

    var navToAddCard: Bool = false
    let customeriD = AppState.shared.customeriD
    
    var arrayOfCard: [Res_SavedData] = []
    
    func fetchSavedCards() async throws -> Api_SavedCard {
                
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["customer_id"] = customeriD
        
        let response = try await Service.shared.request (
            url: Router.retrieve_all_card_stripe.url(),
            params: paramDict,
            responseType: Api_SavedCard.self
        )
        
        return response
    }
}
