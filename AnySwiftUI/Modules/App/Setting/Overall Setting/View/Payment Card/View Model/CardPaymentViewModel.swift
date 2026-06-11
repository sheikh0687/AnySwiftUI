//
//  CardPaymentViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 06/06/26.
//

import Observation
import StripePayments

@Observable
@MainActor
class CardPaymentViewModel {
    
    var cardHolderName: String = ""
    var cardParams: STPPaymentMethodCardParams? = nil
    var isCardValid: Bool = false
    var isLoading: Bool = false
    var alertMessage: String = ""
    var showAlert: Bool = false
    var customerId: String = ""
    
    // MARK: - Get Customer ID
//    func getCustomerId() async {
//        guard customerId.isEmpty else {
//            print("Customer id already created!!")
//            return
//        }
//        
//        isLoading = true
//        var params: [String: AnyObject] = [:]
//        params["user_id"] = UserDefaults.standard.value(forKey: USERID) as AnyObject
//        
//        do {
//            let json = try await CommunicationManager.callPostServiceAsync(
//                apiUrl: Router.create_Customer.url(),
//                parameters: params,
//                parentViewController: nil
//            )
//            if json["status"].stringValue == "1" {
//                customerId = json["result"]["customer_id"].stringValue
//                print("Customer ID saved:", customerId)
//            } else {
//                alertMessage = json["result"].stringValue
//                showAlert = true
//            }
//        } catch {
//            alertMessage = error.localizedDescription
//            showAlert = true
//        }
//        
//        isLoading = false
//    }

    func getCustomeriD() async throws -> Api_LoginResponse {
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        
        let response = try await Service.shared.request (
            url: Router.create_Customer.url(),
            params: paramDict,
            responseType: Api_LoginResponse.self
        )
        
        return response
    }
    
    // MARK: - Save Card
    func saveCard() {
        guard !cardHolderName.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please enter the name on card."
            showAlert = true
            return
        }
        guard isCardValid, let cardParams else {
            alertMessage = "Please enter valid card details."
            showAlert = true
            return
        }
        
        isLoading = true
        
        let billingDetails = STPPaymentMethodBillingDetails()
        billingDetails.name = cardHolderName
        
        let paymentMethodParams = STPPaymentMethodParams(
            card: cardParams,
            billingDetails: billingDetails,
            metadata: nil
        )
        
        STPAPIClient.shared.createPaymentMethod(with: paymentMethodParams) { [weak self] paymentMethod, error in
            guard let self else { return }
            self.isLoading = false
            
            if let error {
                self.alertMessage = error.localizedDescription
                self.showAlert = true
                return
            }
            guard let paymentMethod else { return }
            print("Payment Method ID:", paymentMethod.stripeId)
            // TODO: Pass paymentMethod.stripeId to your backend to attach to customer
        }
    }

}
