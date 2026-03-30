//
//  WorkerTransactionViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 27/03/26.
//

internal import Combine

class WorkerTransactionViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var customError: CustomError?
    @Published var totalEarning = 0
    @Published var totalJob = 0
    
    @Published var workerTransaction: [Res_WorkerTransactionHistory] = []
    
    @MainActor
    func fetchWorkerTransactionHistory() async throws -> Api_WorkerTransactionHistory {
        
        var paramDict: [String : Any] = [:]
        paramDict["worker_id"] = AppState.shared.useriD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_shift_complete_by_worker.url(),
            params: paramDict,
            responseType: Api_WorkerTransactionHistory.self
        )
        
        return response
    }
}
