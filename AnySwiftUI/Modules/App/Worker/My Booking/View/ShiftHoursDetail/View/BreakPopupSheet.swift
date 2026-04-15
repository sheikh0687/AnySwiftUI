//
//  BreakPopupSheet.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 14/04/26.
//

import SwiftUI

struct Approver: Identifiable {
    let id:        String
    let firstName: String
    let lastName:  String
    let type:      String
 
    var displayName: String { "\(firstName) \(lastName) (\(type))" }
}

struct BreakPopupSheet: View {
    
    let popup: BreakPopup
    let onSuccess: (_ from: String) -> Void   // mirrors delegate?.myVCDidFinish(text: strFrom)
    let onDismiss: () -> Void
 
    @State private var approvers: [Approver] = []
    @State private var selectedApprover: Approver?
    @State private var showApproverPicker = false
 
    @State private var isLoading  = false
    @State private var errorAlert: String?
 
    // Mirrors viewDidLoad strBreakTime assignment
    private var resolvedBreakTime: String {
        switch popup.from {
        case "0":       return "No Break Taken"
        case "1":       return "30 min"
        case "2":       return "1 hour"
        default:        return popup.breakTime   // Dynamic
        }
    }
 
    // Mirrors btn_two title logic
    private var confirmTitle: String {
        switch popup.from {
        case "1":   return "Start Break"
        default:    return "Yes, proceed"
        }
    }
 
    // Mirrors view_Top.isHidden — top approver section visible only for row 0
    private var showApproverSection: Bool { popup.from == "0" }
 
    // Mirrors view_Approve.isHidden — approve picker visible for rows 0 & 1
    private var showApproverPicker2: Bool { popup.from == "0" || popup.from == "1" }

    
    var body: some View {
        VStack(spacing: 0) {
 
            // Handle bar
            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 40, height: 4)
                .padding(.top, 12)
                .padding(.bottom, 20)
 
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
 
                    // MARK: Title (lbl_Head)
                    Text(popup.head)
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
 
                    // MARK: Description (lbl_DEsc)
                    Text(popup.desc)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(showApproverSection ? .leading : .center)
                        .frame(maxWidth: .infinity,
                               alignment: showApproverSection ? .leading : .center)
 
                    // MARK: Approver section (view_Top — only row 0)
                    if showApproverSection {
                        VStack(alignment: .leading, spacing: 6) {
                            if !popup.desc2.isEmpty {
                                Text(popup.desc2)
                                    .font(.system(size: 13))
                                    .foregroundStyle(.secondary)
                            }
 
                            // Approver picker button (mirrors DropDown)
                            if showApproverPicker2 {
                                approverPickerButton
                            }
                        }
                    }
 
                    // MARK: Approver picker for row 1 (view_Approve visible, view_Top hidden)
                    if popup.from == "1" {
                        VStack(alignment: .leading, spacing: 6) {
                            if !popup.desc2.isEmpty {
                                Text(popup.desc2)
                                    .font(.system(size: 13))
                                    .foregroundStyle(.secondary)
                            }
                            approverPickerButton
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
 
            Spacer(minLength: 16)
 
            // MARK: Buttons
            HStack(spacing: 12) {
                Button {
                    onDismiss()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 15, weight: .medium))
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .overlay(Capsule().stroke(Color.BUTTON, lineWidth: 1.5))
                        .foregroundColor(.primary)
                }
 
                Button {
                    Task { await submitBreak() }
                } label: {
                    Group {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text(confirmTitle)
                                .font(.system(size: 15, weight: .medium))
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(Color.THEME)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                }
                .disabled(isLoading)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color(.systemBackground))
        .alert("Error", isPresented: Binding(
            get: { errorAlert != nil },
            set: { if !$0 { errorAlert = nil } }
        )) {
            Button("OK", role: .cancel) { errorAlert = nil }
        } message: {
            Text(errorAlert ?? "")
        }
        // mirrors viewWillAppear → GetProfile()
//        .task { await fetchApprovers() }
    }
    
    // MARK: - Approver Picker Button
    // Mirrors DropDown behaviour → SwiftUI confirmationDialog
 
    private var approverPickerButton: some View {
        Button {
            showApproverPicker = true
        } label: {
            HStack {
                Text(selectedApprover?.displayName ?? "Select approver")
                    .font(.system(size: 14))
                    .foregroundColor(selectedApprover == nil ? .secondary : .primary)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .confirmationDialog("Select Approver",
                            isPresented: $showApproverPicker,
                            titleVisibility: .visible) {
            ForEach(approvers) { approver in
                Button(approver.displayName) {
                    selectedApprover = approver
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
 
    // MARK: - Fetch Approvers
    // Mirrors GetProfile()
 
//    private func fetchApprovers() async {
//        let params: [String: Any] = [
//            "client_id": popup.clientID,
//            "status":    "Accept"
//        ]
// 
//        do {
//            let response = try await Service.shared.request (
//                url: Router.get_OutletAdmin_AuthrisedApprover.url(),
//                params: params,
//                responseType: Api_Approvers.self
//            )
//            if response.status == "1" {
//                approvers = (response.result ?? []).map {
//                    Approver (
//                        id:        $0.id        ?? "",
//                        firstName: $0.first_name ?? "",
//                        lastName:  $0.last_name  ?? "",
//                        type:      $0.type       ?? ""
//                    )
//                }
//                selectedApprover = approvers.first
//            } else {
//                selectedApprover = nil
//            }
//        } catch {
//            errorAlert = error.localizedDescription
//        }
//    }
 
    // MARK: - Submit Break
    // Mirrors webbrakType()
 
    private func submitBreak() async {
        isLoading = true
        defer { isLoading = false }
 
        var params: [String: Any] = [:]
        params["cart_id"]             = popup.cartID
        params["break_type"]          = popup.breakType
        params["break_time"]          = resolvedBreakTime
 
        if let approver = selectedApprover {
            params["break_approver_id"]   = approver.id
            params["break_approver_name"] = "\(approver.firstName) \(approver.lastName)"
        } else {
            params["break_approver_id"]   = ""
            params["break_approver_name"] = ""
        }
 
        print(params)
 
        do {
            let response = try await Service.shared.request (
                url: Router.add_break_time.url(),
                params: params,
                responseType: Api_AddBreakTime.self
            )
            if response.status == "1" {
                onSuccess(popup.from)   // mirrors delegate?.myVCDidFinish(text: strFrom)
            } else {
                errorAlert = response.message ?? "Something went wrong"
            }
        } catch {
            errorAlert = error.localizedDescription
        }
    }
}

//#Preview {
//    BreakPopupSheet()
//}
