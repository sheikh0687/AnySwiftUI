//
//  AssignJobViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 06/05/26.
//

import Observation

@Observable
class AssignJobViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    var previousWorkers: [Res_PreviousWorkers] = []
    var selectedWorkerIDs: Set<String> = []
    
    var jobiD: String = "1"
    var showSuccessSheet: Bool = false
    
    init(jobiD: String) {
        self.jobiD = jobiD
    }
    
    var commaSeparatedWorkerIDs: String {
        return selectedWorkerIDs.joined(separator: ",")
    }
    
    func toggleSelection(workerID: String) {
        if selectedWorkerIDs.contains(workerID) {
            selectedWorkerIDs.remove(workerID)
        } else {
            selectedWorkerIDs.insert(workerID)
        }
    }
    
    @MainActor
    func assignWorkers() async throws -> Api_AddJob {
        paramJobPostDict["previous_worker_id"] = commaSeparatedWorkerIDs
        
        print(paramJobPostDict)
        
        let response = try await Service.shared.request (
            url: Router.set_shift.url(), // Assuming set_shift or a similar endpoint
            params: paramJobPostDict,
            responseType: Api_AddJob.self
        )
        
        return response
    }
    
    @MainActor
    func fetchPreviousWorkers() async throws -> Api_PreviousWorkers {
        var paramDict: [String : Any] = [:]
        paramDict["client_id"] = AppState.shared.useriD
        paramDict["job_type_id"] = jobiD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_worker_list_by_jobtype.url(),
            params: paramDict,
            responseType: Api_PreviousWorkers.self
        )
        
        return response
    }
}
