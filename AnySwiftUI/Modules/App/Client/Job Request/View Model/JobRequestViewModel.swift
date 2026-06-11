//
//  JobRequestViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 10/06/26.
//

import Observation

@MainActor
@Observable
class JobRequestViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?

    var selectedSegment = 0
    var pendingCount = 0
    var acceptCount = 0
    
    var arrayOfWorkerReq: [Res_WorkerRequest] = []
    
    var currentStatus: String {
        selectedSegment == 0 ? "Pending" : "Accept"
    }
    
    var approvalItem: Res_WorkerRequest? = nil      // triggers ApprovalSheet
    var showSaveCard: Bool = false                   // triggers SaveCardView
    var showSuccessPopup: Bool = false               // triggers SuccessSheet
    var pendingCardItem: Res_WorkerRequest? = nil    // holds item while saving card
    
    var cardId: String = ""
    var customerId: String = ""
    
    // Approver list
    var approvers: [Res_OutletAdminList] = []
    var selectedApprover: Res_OutletAdminList? = nil
    var isApproverLoading: Bool = false
    
    func loadRequests() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await fetchWorkerRequestDetail(strStatus: currentStatus)
            arrayOfWorkerReq = response.result ?? []
            pendingCount = response.pending_shift_count ?? 0
        } catch {
            customError = .customError(message: error.localizedDescription)
        }
    }
    
    func rejectBooking(cartID: String) async {
        isLoading = true
        defer { isLoading = false }
        
        var params: [String: Any] = [:]
        params["cart_id"]       = cartID
        params["status"]        = "Reject"
        params["approver_id"]   = ""
        params["approver_name"] = ""
        params["approver_type"] = ""
        
        do {
            let response = try await Service.shared.request (
                url: Router.change_set_shift_status.url(),
                params: params,
                responseType: Api_ChangeJobRequestStatus.self
            )
            if response.status == "1" {
                customError = .customError(message: "You have rejected this shifts\n\nThe service provider selected has been notified of your rejection")
                await loadRequests()
            }
        } catch {
            customError = .customError(message: error.localizedDescription)
        }
    }
    
    func fetchWorkerRequestDetail(strStatus: String) async throws -> Api_WorkerRequest {
        var paramDict: [String : Any] = [:]
        paramDict["client_id"] = AppState.shared.clientiD
        paramDict["status"] = strStatus
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_set_shift_book_by_date.url(),
            params: paramDict,
            responseType: Api_WorkerRequest.self
        )
        return response
    }
    
    func fetchApprovers() async {
        isApproverLoading = true
        defer { isApproverLoading = false }
        
        var params: [String: Any] = [:]
        params["client_id"] = AppState.shared.useriD
        params["status"]    = "Accept"
        
        do {
            let response = try await Service.shared.request (
                url: Router.get_OutletAdmin_AuthrisedApprover.url(),
                params: params,
                responseType: Api_OutletAdminList.self
            )
            if response.status == "1" {
                approvers = response.result ?? []
                selectedApprover = approvers.first
            } else {
                approvers = []
                selectedApprover = nil
            }
        } catch {
            customError = .customError(message: error.localizedDescription)
        }
    }
    
    // MARK: - Handle Approve Button Tap
    
    func handleApproveTap(item: Res_WorkerRequest) {
        let paymentType = item.client_details?.request_payment_type ?? ""
        
        if paymentType == "Monthly" {
            // Monthly — go straight to approver selection sheet
            approvalItem = item
        } else {
            if cardId.isEmpty {
                // No card saved — go to SaveCard first
                pendingCardItem = item
                showSaveCard = true
            } else {
                // Has card — go to approver selection sheet
                approvalItem = item
            }
        }
    }
    
    // Called after SaveCardView returns cardId + customerId
    func onCardSaved(cardId: String, customerId: String) {
        self.cardId     = cardId
        self.customerId = customerId
        if let item = pendingCardItem {
            approvalItem    = item
            pendingCardItem = nil
        }
    }
    
    // MARK: - Accept Shift API
    func acceptShift() async {
        guard let item = approvalItem else { return }
        isLoading = true
        defer { isLoading = false }
        
        var params: [String: Any] = [:]
        params["cart_id"]   = item.id ?? ""
        params["status"]    = "Accept"
        params["client_id"] = AppState.shared.useriD
        params["card_id"]   = cardId
        params["customer_id"] = customerId
        
        if let approver = selectedApprover {
            params["approver_id"]   = approver.id ?? ""
            params["approver_name"] = "\(approver.first_name ?? "") \(approver.last_name ?? "")"
            params["approver_type"] = approver.type ?? ""
        } else {
            params["approver_id"]   = ""
            params["approver_name"] = ""
            params["approver_type"] = ""
        }
        
        print(params)
        
        do {
            let response = try await Service.shared.request (
                url: Router.change_set_shift_status.url(),
                params: params,
                responseType: Api_ChangeJobRequestStatus.self
            )
            
            if response.status == "1" {
                approvalItem    = nil
                showSuccessPopup = true
                await loadRequests()
            } else {
                customError = .customError(message: response.message ?? "")
            }
            
        } catch {
            customError = .customError(message: error.localizedDescription)
        }
    }
}

