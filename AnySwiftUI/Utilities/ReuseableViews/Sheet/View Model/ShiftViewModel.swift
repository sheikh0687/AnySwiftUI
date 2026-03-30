//
//  ShiftViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 30/03/26.
//

internal import Combine

class ShiftViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var customError: CustomError?
    
    @Published var jobTypes: [Res_JobType] = []
    @Published var dismissJobType: Bool = false
    
    var cloJobType: ((String, String) -> Void)?

    init(cloJobType: ((String, String) -> Void)? = nil) {
        self.cloJobType = cloJobType
    }
    
    @MainActor
    func fetchJobTypes() async throws -> Api_JobType {
        
        let paramDict: [String : Any] = [:]
        
        let response = try await Service.shared.request (
            url: Router.get_job_type.url(),
            params: paramDict,
            responseType: Api_JobType.self
        )
        
        return response
    }
}
