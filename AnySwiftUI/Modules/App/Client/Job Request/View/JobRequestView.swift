//
//  JobRequestView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 16/04/26.
//

import SwiftUI

struct JobRequestView: View {
    
    @State private var viewModel = JobRequestViewModel()
    
    @State private var navigateToChat: Res_WorkerRequest? = nil
    @State private var navigateToReviews: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 24) {
                tabSelector
                contentArea
            }
            .padding(.all, 16)
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
            .task { await viewModel.loadRequests() }
            .refreshable { await viewModel.loadRequests() }
            .alert("Error", isPresented: Binding (
                get: { viewModel.customError != nil },
                set: { if !$0 { viewModel.customError = nil } }
            )) {
                Button("OK") { viewModel.customError = nil }
            } message: {
                Text(viewModel.customError?.errorDescription ?? "")
            }
            .navigationDestination(isPresented: $navigateToReviews) {
//                UserRatingView()
            }
            .sheet(item: $viewModel.approvalItem) { item in
                ApprovalSheetView (
                    item: item,
                    viewModel: viewModel
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
            
            // ── Success popup ──
            .sheet(isPresented: $viewModel.showSuccessPopup) {
                ApprovalSuccessView {
                    viewModel.showSuccessPopup = false
                }
                .presentationDetents([.height(320)])
                .presentationDragIndicator(.visible)
            }
            
            // ── Save Card navigation ──
            .navigationDestination(isPresented: $viewModel.showSaveCard) {
                SavedPaymentCardView { cardiD, customeriD in
                    viewModel.onCardSaved(cardId: cardiD, customerId: customeriD)
                }
            }
            
            //            .navigationDestination(item: $navigateToChat) { item in
            ////                UserChatView (
            ////                    receiverId: item.userDetails?.id ?? "",
            ////                    userName: "\(item.userDetails?.firstName ?? "") \(item.userDetails?.lastName ?? "")",
            ////                    reasonID: item.id ?? ""
            ////                )
            //            }
        }
    }
    
    // MARK: - Tab Selector
    private var tabSelector: some View {
         HStack(spacing: 8) {
            segmentButton(title: "Pending", index: 0, badge: viewModel.pendingCount)
            segmentButton(title: "Approved", index: 1, badge: viewModel.acceptCount)
        }
    }
    
    private func segmentButton(title: String, index: Int, badge: Int) -> some View {
        let isSelected = viewModel.selectedSegment == index
        return Button {
            viewModel.selectedSegment = index
            Task { await viewModel.loadRequests() }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(isSelected ? Color(.BUTTON) : Color.white)
                    .overlay (
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(.BUTTON), lineWidth: isSelected ? 0 : 1.5)
                    )
                HStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(isSelected ? .white : Color(.BUTTON))
                    if badge > 0 {
                        Text("\(badge)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(isSelected ? Color(.red) : .white)
                            .frame(width: 20, height: 20)
                            .background(isSelected ? Color.white : Color(.red))
                            .clipShape(Circle())
                    }
                }
            }
            .frame(height: 40)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Content Area
    @ViewBuilder
    private var contentArea: some View {
        if viewModel.isLoading && viewModel.arrayOfWorkerReq.isEmpty {
            Spacer()
            ProgressView()
            Spacer()
        } else if viewModel.arrayOfWorkerReq.isEmpty {
            Spacer()
            emptyState
            Spacer()
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.arrayOfWorkerReq, id: \.id) { item in
                        WorkerRequestCardView (
                            item: item,
                            isApprovedTab: viewModel.selectedSegment == 1,
                            onApprove: {
                                // present approval sheet — wire to your PopUpApprovalVC equivalent
                                viewModel.handleApproveTap(item: item)
                            },
                            onReject: {
                                Task { await viewModel.rejectBooking(cartID: item.id ?? "") }
                            },
                            onChat: { navigateToChat = item },
                            onSeeReviews: { navigateToReviews = true }
                        )
                    }
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.4))
            Text(viewModel.selectedSegment == 0
                 ? "No Pending Bookings At The Moment"
                 : "No Approved Bookings At The Moment")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
}

struct WorkerRequestCardView: View {
    
    let item: Res_WorkerRequest
    let isApprovedTab: Bool
    var onApprove: () -> Void
    var onReject: () -> Void
    var onChat: () -> Void
    var onSeeReviews: () -> Void
    
    private var shiftTimeRange: String {
        let start = item.set_shift_details?.start_time ?? ""
        let end   = item.set_shift_details?.end_time ?? ""
        return "\(start) to \(end)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection
            Divider().padding(.vertical, 10)
            statsSection
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                workerAvatar
                workerInfo
            }
            estimatedAmountRow
            notesRow
            actionButtons
        }
    }
    
    private var workerAvatar: some View {
        AsyncImage(url: URL(string: item.user_details?.image ?? "")) { phase in
            switch phase {
            case .success(let img): img.resizable().scaledToFill()
            default:
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray.opacity(0.4))
            }
        }
        .frame(width: 64, height: 64)
        .clipShape(Circle())
    }
    
    private var workerInfo: some View {
        VStack(alignment: .leading, spacing: 3) {
//            HStack(alignment: .top) {
//                Spacer()
//            }
            
            Text("\(item.user_details?.first_name ?? "") \(item.user_details?.last_name ?? "")")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)

            let currency = item.user_details?.currency_symbol ?? ""
            let rate     = item.shift_rate ?? ""
            let jobType  = item.set_shift_details?.job_type ?? ""
            let date     = item.format_date ?? ""
            
            Text("\(currency)\(rate)/Hour")
                .font(.system(size: 14, weight: .bold))
            Text(jobType)
                .font(.system(size: 14, weight: .semibold))
            Text(date)
                .font(.system(size: 14, weight: .semibold))
            Text(shiftTimeRange)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            
            if isApprovedTab {
                let clockIn = item.clock_in_time ?? ""
                Text(clockIn.isEmpty ? "Confirmed" : "Clock-In : \(clockIn)")
                    .font(.system(size: 13))
                    .foregroundColor(.GREEN)
            }
        }
    }
    
    @ViewBuilder
    private var estimatedAmountRow: some View {
        if item.client_details?.request_payment_type != "Monthly" {
            let currency   = item.user_details?.currency_symbol ?? ""
            let amount     = item.shift_estimate_amount ?? 0
            let commission = item.admin_commission ?? ""
            Text("Estimated Amount: \(currency)\(amount) + \(commission)%")
                .font(.system(size: 14))
                .foregroundColor(.primary)
        }
    }
    
    private var notesRow: some View {
        Text("Notes: \(item.set_shift_details?.note ?? "")")
            .font(.system(size: 14))
            .foregroundColor(.primary)
    }
    
    // MARK: - Action Buttons
    
    @ViewBuilder
    private var actionButtons: some View {
        if isApprovedTab {
            Button { onChat() } label: {
                Label("Chat", systemImage: "message.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color(.BUTTON))
                    .clipShape(Capsule())
            }
        } else {
            HStack(spacing: 12) {
                Button { onApprove() } label: {
                    Text("Approve")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color(.BUTTON))
                        .clipShape(Capsule())
                }
                Button { onReject() } label: {
                    Text("Reject")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.BUTTON)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .overlay(Capsule().stroke(Color(.BUTTON), lineWidth: 1.5))
                }
            }
        }
    }
    
    // MARK: - Stats Section
    
    private var statsSection: some View {
        VStack(spacing: 8) {
            statRow(label: "Attendance rate", value: item.user_details?.attandance ?? "")
            statRow(label: "Completed Shift",  value: String(item.user_details?.completed_shift ?? 0))
            
            HStack {
                Text("Experience")
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                Text(item.user_details?.worker_experience ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(Color(.BUTTON))
                    .font(.system(size: 13))
                Text("\(item.user_details?.average_rating ?? "") (\(String(item.user_details?.total_rating_count ?? 0)) Reviews)")
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                Button { onSeeReviews() } label: {
                    Text("See All")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(.BUTTON))
                }
            }
            
            HStack(alignment: .top) {
                Text("Certificate \(item.user_details?.certificate ?? "")")
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                AsyncImage(url: URL(string: item.user_details?.job_document ?? "")) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill()
                    default:
                        Image(systemName: "photo")
                            .foregroundColor(.gray.opacity(0.4))
                            .frame(width: 56, height: 56)
                            .background(Color(.systemGray5))
                    }
                }
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
    
    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .medium))
            Spacer()
            Text(value)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
    }
}

struct ApprovalSheetView: View {
    
    let item: Res_WorkerRequest
    @Bindable var viewModel: JobRequestViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle
            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 40, height: 4)
                .padding(.top, 12)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    Divider()
                    approverSection
                    Divider()
                    shiftSummarySection
                    confirmButton
                }
                .padding(20)
            }
        }
        .background(Color(.systemBackground))
        .task { await viewModel.fetchApprovers() }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Approve Shift")
                .font(.system(size: 20, weight: .bold))
            Text("Confirm approval for \(item.user_details?.first_name ?? "") \(item.user_details?.last_name ?? "")")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Approver Picker
    
    private var approverSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Approver")
                .font(.system(size: 15, weight: .semibold))
            
            if viewModel.isApproverLoading {
                HStack {
                    ProgressView()
                    Text("Loading approvers…")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            } else if viewModel.approvers.isEmpty {
                Text("No approvers available")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            } else {
                // Dropdown replacement using native Picker
                Menu {
                    ForEach(viewModel.approvers, id: \.id) { approver in
                        Button {
                            viewModel.selectedApprover = approver
                        } label: {
                            Text("\(approver.first_name ?? "") \(approver.last_name ?? "") (\(approver.type ?? ""))")
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedApprover.map {
                            "\($0.first_name ?? "") \($0.last_name ?? "") (\($0.type ?? ""))"
                        } ?? "Select an approver")
                            .font(.system(size: 14))
                            .foregroundColor(viewModel.selectedApprover == nil ? .secondary : .primary)
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
    
    // MARK: - Shift Summary
    
    private var shiftSummarySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Shift Summary")
                .font(.system(size: 15, weight: .semibold))
            
            summaryRow(label: "Date",    value: item.format_date ?? "")
            summaryRow(label: "Time",    value: "\(item.set_shift_details?.start_time ?? "") – \(item.set_shift_details?.end_time ?? "")")
            summaryRow(label: "Job",     value: item.set_shift_details?.job_type ?? "")
            summaryRow(label: "Rate",    value: "\(item.user_details?.currency_symbol ?? "")\(item.shift_rate ?? "")/Hour")
            
            if item.client_details?.request_payment_type != "Monthly" {
                summaryRow (
                    label: "Estimated",
                    value: "\(item.user_details?.currency_symbol ?? "")\(item.shift_estimate_amount ?? 0) + \(item.admin_commission ?? "")%"
                )
            }
        }
        .padding(14)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func summaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
    
    // MARK: - Confirm Button
    
    private var confirmButton: some View {
        Button {
            Task {
                await viewModel.acceptShift()
                dismiss()
            }
        } label: {
            ZStack {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Confirm Approval")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color(.BUTTON))
            .clipShape(Capsule())
        }
        .disabled(viewModel.isLoading)
        .padding(.top, 8)
    }
}

#Preview {
    JobRequestView()
}
