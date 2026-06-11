//
//  SetRateView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 08/06/26.
//

import SwiftUI

struct SetRateView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var viewModel = SetRateViewModel()
    
    var isComingFrom: String = ""
    var preselectedJobId: String = ""
    var preselectedJobName: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        jobTypeDropdown
                        sectionDivider("Weekly Rate Setup")
                        weeklyRatesSection
                        sectionDivider("General Rates")
                        generalRatesSection
                        sectionDivider("Custom Rate")
                        customRateSection
                        noticeText
                        saveButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                
                if viewModel.isLoading {
                    Color.black.opacity(0.15).ignoresSafeArea()
                    ProgressView()
                        .scaleEffect(1.3)
                        .tint(.THEME)
                }
            }
            .navigationTitle("Rates")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .alert("Notice", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage)
            }
            .onChange(of: viewModel.shouldDismiss) { _, newVal in
                if newVal { dismiss() }
            }
            .task {
                viewModel.isComingFrom = isComingFrom
                viewModel.preselectedJobId = preselectedJobId
                viewModel.preselectedJobName = preselectedJobName
                await viewModel.fetchJobCategories()
                await viewModel.fetchDateRates()
            }
        }
    }
    
    // MARK: - Job Type Dropdown
    private var jobTypeDropdown: some View {
        Menu {
            ForEach(viewModel.jobTypes, id: \.id) { job in
                Button(job.name ?? "") {
                    viewModel.selectedJobType = job
                    Task { await viewModel.fetchWeeklyRate(jobTypeId: job.id ?? "") }
                }
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    IBLabel(
                        text: viewModel.selectedJobType?.name ?? "Select Job Type",
                        font: .system(size: 15, weight: .medium),
                        color: .black
                    )
                    IBLabel(
                        text: "Update rate by job type",
                        font: .system(size: 12),
                        color: .gray
                    )
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.top, 16)
        .padding(.bottom, 20)
    }
    
    // MARK: - Weekly Rates
    private var weeklyRatesSection: some View {
        ForEach(Array(viewModel.weeklyRates.enumerated()), id: \.offset) { index, item in
            RateStepperRow (
                label: item.dayName,
                rate: item.rate,
                currencySymbol: viewModel.currencySymbol,
                onIncrement: { viewModel.incrementWeeklyRate(at: index) },
                onDecrement: { viewModel.decrementWeeklyRate(at: index) }
            )
            Divider()
        }
    }
    
    // MARK: - General Rates
    private var generalRatesSection: some View {
        VStack(spacing: 0) {
            RateStepperRow(
                label: "Minimum Rate",
                rate: viewModel.minRate,
                currencySymbol: viewModel.currencySymbol,
                onIncrement: { viewModel.incrementMinRate() },
                onDecrement: { viewModel.decrementMinRate() }
            )
            Divider()
            RateStepperRow(
                label: "Urgent Rate",
                rate: viewModel.urgentRate,
                currencySymbol: viewModel.currencySymbol,
                onIncrement: { viewModel.incrementUrgentRate() },
                onDecrement: { viewModel.decrementUrgentRate() }
            )
            Divider()
        }
    }
    
    // MARK: - Custom Rate (Specific Date)
    private var customRateSection: some View {
        VStack(spacing: 0) {
            // Navigate to SetCustomDateRateView
            NavigationLink {
                // SetCustomDateRateView()
                SetCustomDateRateView()
            } label: {
                HStack  {
                    IBLabel (
                        text: "Specific Date Rate",
                        font: .system(size: 15),
                        color: .black
                    )
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 12)
            }
            
            Divider()
            
            if !viewModel.specificDateRates.isEmpty {
                ForEach(Array(viewModel.specificDateRates.enumerated()), id: \.offset) { index, item in
                    RateStepperRow (
                        label: item.date,
                        rate: item.rate,
                        currencySymbol: viewModel.currencySymbol,
                        showDeleteIcon: true,
                        onIncrement: { viewModel.incrementSpecificRate(at: index) },
                        onDecrement: { viewModel.decrementSpecificRate(at: index) },
                        onDelete: {
                            Task { await viewModel.deleteDateRate(id: item.dateRateId) }
                        }
                    )
                    Divider()
                }
            }
        }
    }
    
    // MARK: - Notice + Save
    private var noticeText: some View {
        IBLabel(
            text: "Important Notice: Custom rate will override the week rate set-up selected check dates.",
            font: .system(size: 12),
            color: .gray
        )
        .padding(.top, 16)
    }
    
    private var saveButton: some View {
        Button {
            Task { await viewModel.saveRates() }
        } label: {
            IBLabel (
                text: "Save & Return",
                font: .system(size: 16, weight: .semibold),
                color: .white
            )
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(.BUTTON)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.top, 24)
        .disabled(viewModel.isLoading)
    }
    
    // MARK: - Helpers
    private func sectionDivider(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            IBLabel(text: title, font: .system(size: 16, weight: .bold), color: .black)
                .padding(.top, 24)
                .padding(.bottom, 8)
            Divider()
        }
    }
}

struct RateStepperRow: View {
    
    let label: String
    let rate: Int
    let currencySymbol: String
    var showDeleteIcon: Bool = false
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    var onDelete: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            if showDeleteIcon {
                Button { onDelete?() } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.gray)
                }
                .buttonStyle(.plain)
            }
            
            IBLabel(text: label, font: .system(size: 15), color: .black)
            
            Spacer()
            
            HStack(spacing: 10) {
                // Plus
                Button { onIncrement() } label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 22))
                        .foregroundStyle(.THEME)
                }
                .buttonStyle(.plain)
                
                // Rate
                IBLabel (
                    text: "\(currencySymbol)\(rate)/h",
                    font: .system(size: 15, weight: .semibold),
                    color: .THEME
                )
                .frame(minWidth: 60, alignment: .center)
                
                // Minus
                Button { onDecrement() } label: {
                    Image(systemName: "minus.circle")
                        .font(.system(size: 22))
                        .foregroundStyle(.THEME)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SetRateView()
}
