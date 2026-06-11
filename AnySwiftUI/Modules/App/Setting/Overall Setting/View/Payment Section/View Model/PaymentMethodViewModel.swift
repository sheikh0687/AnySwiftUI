//
//  PaymentMethodViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 05/06/26.
//

import Observation

@Observable
@MainActor
class PaymentMethodViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    
    var isCardPayment: Bool = false
    var isMonthlyPayment: Bool = false
    var paymentType: String = AppState.shared.paymentType
    
    var gotResponse: Bool = false
    var informUser: Bool = false
    
    func updatePaymentMethod() async throws -> Api_LoginResponse {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["request_payment_type"] = paymentType
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.update_request_payment_type.url(),
            params: paramDict,
            responseType: Api_LoginResponse.self
        )
        
        return response
    }
}
