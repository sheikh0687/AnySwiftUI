//
//  BookingHourViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 13/04/26.
//

import Foundation
internal import Combine

class BookingHourViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var customError: CustomError?
    
    @Published var cartiD: String = ""
    @Published var shiftDetail: Api_BookingHours?
    @Published var arrayOfBreakTime: [String] = []
    
    init(cartiD: String) {
        self.isLoading = isLoading
        self.customError = customError
        self.cartiD = cartiD
    }
    
    @MainActor
    func fecthShiftDetail() async throws -> Api_BookingHours {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["cart_id"] = cartiD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_set_shift_cart_details.url(),
            params: paramDict,
            responseType: Api_BookingHours.self
        )
        
        return response
    }
    
    @MainActor
    func addClockOutIn(strType: String) async throws -> Api_ClockOutIn {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["cart_id"] = cartiD
        paramDict["shift_id"] = shiftDetail?.result?.id ?? ""
        paramDict["clock_time"] = ""
        paramDict["type"] = strType
        paramDict["date"] = SGDate.today()
        paramDict["lat"] = ""
        paramDict["lon"] = ""
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.add_clock_in_time.url(),
            params: paramDict,
            responseType: Api_ClockOutIn.self
        )
        
        return response
    }
}
