//
//  SetCustomDateRateViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/06/26.
//

import Observation

@MainActor
@Observable
class SetCustomDateRateViewModel {

    var rate: Int = 12
    var selectedDate: Date? = nil
    var showDatePicker: Bool = false
    var isLoading: Bool = false
    var alertMessage: String = ""
    var showAlert: Bool = false
    var shouldDismiss: Bool = false

    let currencySymbol = AppState.shared.currencySymbol
    private let minimumRate = 12

    var formattedDate: String {
        guard let date = selectedDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    var displayDate: String {
        guard let date = selectedDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func increment() {
        rate += 1
    }

    func decrement() {
        if rate > minimumRate {
            rate -= 1
        } else {
            alertMessage = "Minimum hourly rate can't be below \(currencySymbol)\(minimumRate)/hr"
            showAlert = true
        }
    }

    func setRate() {
        guard selectedDate != nil else {
            alertMessage = "Please select the date"
            showAlert = true
            return
        }
        Task { await addCustomDateRate() }
    }

    // MARK: - API
    private func addCustomDateRate() async {
        isLoading = true
        do {
            var params: [String: Any] = [:]
            params["user_id"]  = AppState.shared.useriD
            params["day_name"] = ""
            params["date"]     = formattedDate
            params["rate"]     = rate

            let response = try await Service.shared.request (
                url: Router.add_client_date_rate.url(),
                params: params,
                responseType: Api_Basic.self
            )
            if response.status == "1" {
                shouldDismiss = true
            } else {
                alertMessage = response.message ?? "Something went wrong."
                showAlert = true
            }
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
        isLoading = false
    }
}
