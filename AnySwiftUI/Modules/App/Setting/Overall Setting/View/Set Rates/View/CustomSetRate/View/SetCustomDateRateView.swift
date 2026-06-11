//
//  SetCustomDateRateView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/06/26.
//

import SwiftUI

import SwiftUI

struct SetCustomDateRateView: View {

    @Environment(\.dismiss) private var dismiss
    @State var viewModel = SetCustomDateRateViewModel()

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: Select Date
                VStack(alignment: .leading, spacing: 8) {
                    IBLabel(text: "Select Date", font: .system(size: 16, weight: .bold))

                    Button {
                        viewModel.showDatePicker = true
                    } label: {
                        HStack {
                            IBLabel(
                                text: viewModel.displayDate.isEmpty
                                    ? "Select Date"
                                    : viewModel.displayDate,
                                font: .system(size: 15),
                                color: viewModel.selectedDate == nil ? .gray : .black
                            )
                            Spacer()
                        }
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    }
                }

                // MARK: Select Rate
                VStack(alignment: .leading, spacing: 12) {
                    IBLabel(text: "Select Rate", font: .system(size: 16, weight: .bold))

                    HStack(spacing: 14) {
                        // Plus
                        Button { viewModel.increment() } label: {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 28))
                                .foregroundStyle(.THEME)
                        }
                        .buttonStyle(.plain)

                        // Rate Label
                        IBLabel (
                            text: "\(viewModel.currencySymbol)\(viewModel.rate)/h",
                            font: .system(size: 18, weight: .medium),
                            color: .THEME
                        )

                        // Minus
                        Button { viewModel.decrement() } label: {
                            Image(systemName: "minus.circle")
                                .font(.system(size: 28))
                                .foregroundStyle(.THEME)
                        }
                        .buttonStyle(.plain)
                    }
                }

                // MARK: Buttons
                HStack(spacing: 16) {
                    // Return
                    Button { dismiss() } label: {
                        IBLabel(
                            text: "Return",
                            font: .system(size: 15, weight: .medium),
                            color: .BLACK
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .overlay (
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.BUTTON, lineWidth: 1.5)
                        )
                    }

                    // Set Rate
                    Button { viewModel.setRate() } label: {
                        IBLabel(
                            text: "Set Rate",
                            font: .system(size: 15, weight: .medium),
                            color: .BLACK
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.BUTTON, lineWidth: 1.5)
                        )
                    }
                    .disabled(viewModel.isLoading)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            // MARK: Loading Overlay
            if viewModel.isLoading {
                Color.black.opacity(0.15).ignoresSafeArea()
                ProgressView().scaleEffect(1.3)
            }
        }
        .navigationTitle("Set Custom Date Rate")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar { backButton }
        .alert("Notice", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
        .sheet(isPresented: $viewModel.showDatePicker) {
            DatePickerSheet(selectedDate: $viewModel.selectedDate)
        }
        .onChange(of: viewModel.shouldDismiss) { _, newVal in
            if newVal { dismiss() }
        }
    }

    @ToolbarContentBuilder
    private var backButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left").foregroundStyle(.black)
            }
        }
    }
}

// MARK: - Date Picker Sheet
struct DatePickerSheet: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date?
    @State private var tempDate: Date = Date()

    var body: some View {
        NavigationStack {
            DatePicker(
                "Select Date",
                selection: $tempDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding()
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        selectedDate = tempDate
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
