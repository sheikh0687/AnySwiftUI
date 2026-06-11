//
//  SetRateViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 06/06/26.
//

import Observation

@Observable
@MainActor
class SetRateViewModel {
    
    // MARK: - Published State
    var jobTypes: [Res_JobType] = []
    var selectedJobType: Res_JobType? = nil

    var weeklyRates: [WeeklyRateItem] = []
    var specificDateRates: [SpecificDateRate] = []

    var minRate: Int = 0
    var urgentRate: Int = 0

    var isLoading: Bool = false
    var alertMessage: String = ""
    var showAlert: Bool = false
    var shouldDismiss: Bool = false

    var isComingFrom: String = ""
    var preselectedJobId: String = ""
    var preselectedJobName: String = ""

    let currencySymbol = AppState.shared.currencySymbol

    // MARK: - Rate Stepper Helpers

    func incrementMinRate() { minRate += 1 }
    func decrementMinRate() { if minRate > 1 { minRate -= 1 } }

    func incrementUrgentRate() { urgentRate += 1 }
    func decrementUrgentRate() { if urgentRate > 1 { urgentRate -= 1 } }

    func incrementWeeklyRate(at index: Int) {
        weeklyRates[index].rate += 1
    }

    func decrementWeeklyRate(at index: Int) {
        if weeklyRates[index].rate > 1 {
            weeklyRates[index].rate -= 1
        }
    }
    
    func incrementSpecificRate(at index: Int) {
        specificDateRates[index].rate += 1
    }

    func decrementSpecificRate(at index: Int) {
        if specificDateRates[index].rate > 1 {
            specificDateRates[index].rate -= 1
        }
    }

    // MARK: - API: Get Job Categories
    func fetchJobCategories() async {
        isLoading = true
        do {
            let response = try await Service.shared.request(
                url: Router.get_job_type.url(),
                params: [:],
                responseType: Api_JobType.self
            )
            if response.status == "1", let items = response.result {
                jobTypes = items  // ✅ directly assign, no mapping needed

                if isComingFrom == "PublishJob", !preselectedJobId.isEmpty {
                    selectedJobType = jobTypes.first { $0.id == preselectedJobId }
                        ?? jobTypes.first
                } else {
                    selectedJobType = jobTypes.first
                }

                if let selected = selectedJobType {
                    await fetchWeeklyRate(jobTypeId: selected.id ?? "")
                }
            } else {
                alertMessage = response.message ?? "Failed to load job types."
                showAlert = true
            }
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
        isLoading = false
    }

    // MARK: - API: Get Weekly Rate
    func fetchWeeklyRate(jobTypeId: String) async {
        isLoading = true
        do {
            var params: [String: Any] = [:]
            params["user_id"] = AppState.shared.useriD
            params["job_type_id"] = jobTypeId

            print(params)
            
            let response = try await Service.shared.request (
                url: Router.get_client_weekly_rate.url(),
                params: params,
                responseType: Api_SaveRates.self
            )
            if response.status == "1" {
                minRate = Int(response.min_day_rate ?? "0") ?? 0
                urgentRate = Int(response.urgent_rate ?? "0") ?? 0
                weeklyRates = (response.result ?? []).map {
                    WeeklyRateItem (
                        id: $0.id ?? "",
                        dayName: $0.day_name ?? "",
                        rate: Int($0.rate ?? "0") ?? 0,
                        checkStatus: $0.check_status ?? "",
                        jobTypeId: $0.job_type_id ?? ""
                    )
                }
            } else {
                alertMessage = response.message ?? "Failed to load weekly rates."
                showAlert = true
            }
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
        isLoading = false
    }

    // MARK: - API: Get Date Rate
    func fetchDateRates() async {
        isLoading = true
        
        do {
            var params: [String: Any] = [:]
            params["user_id"] = AppState.shared.useriD

            print(params)
            
            let response = try await Service.shared.request (
                url: Router.get_client_date_rate.url(),
                params: params,
                responseType: Api_SpecificDateRate.self
            )
            
            if response.status == "1", let items = response.result {
                specificDateRates = items.map {
                    SpecificDateRate (
                        dateRateId: $0.id ?? "",
                        date: $0.date ?? "",
                        rate: Int(Double($0.rate ?? "0") ?? 0)
                    )
                }
            } else {
                specificDateRates = []
            }
            
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
        
        isLoading = false
    }

    // MARK: - API: Save (Add Weekly Rate)
    func saveRates() async {
        isLoading = true
        do {
            var params: [String: Any] = [:]
            params["user_id"]       = AppState.shared.useriD
            params["day_name"]      = weeklyRates.map { $0.dayName }.joined(separator: ",")
            params["min_day_rate"]  = minRate
            params["ticked_day_rate"] = 0
            params["check_status"]  = weeklyRates.map { $0.checkStatus }.joined(separator: ",")
            params["urgent_rate"]   = urgentRate
            params["rate"]          = weeklyRates.map { String($0.rate ) }.joined(separator: ",")
            params["job_type_id"]   = selectedJobType?.id ?? ""

            print(params)
            
            let response = try await Service.shared.request (
                url: Router.add_client_weekly_rate.url(),
                params: params,
                responseType: Api_Basic.self
            )
            
            if response.status == "1" {
                if !specificDateRates.isEmpty {
                    await updateDateRates()
                } else {
                    shouldDismiss = true
                }
            } else {
                alertMessage = response.message ?? "Failed to save rates."
                showAlert = true
            }
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
        isLoading = false
    }

    // MARK: - API: Update Date Rates
    private func updateDateRates() async {
        do {
            var params: [String: Any] = [:]
            params["user_id"]  = AppState.shared.useriD
            params["day_name"] = ""
            params["rate"]     = specificDateRates.map { String($0.rate) }.joined(separator: ",")
            params["date"]     = specificDateRates.map { $0.date }.joined(separator: ",")

            let response = try await Service.shared.request (
                url: Router.update_client_date_rate.url(),
                params: params,
                responseType: Api_Basic.self
            )
            
            if response.status == "1" {
                shouldDismiss = true
            } else {
                alertMessage = response.message ?? "Failed to update date rates."
                showAlert = true
            }
            
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }

    // MARK: - API: Delete Date Rate
    func deleteDateRate(id: String) async {
        isLoading = true
        do {
            let response = try await Service.shared.request(
                url: Router.delete_client_date_rate.url(),
                params: ["id": id],
                responseType: Api_Basic.self
            )
            if response.status == "1" {
                await fetchDateRates()
            } else {
                alertMessage = response.message ?? "Failed to delete."
                showAlert = true
            }
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
        isLoading = false
    }

    
}
