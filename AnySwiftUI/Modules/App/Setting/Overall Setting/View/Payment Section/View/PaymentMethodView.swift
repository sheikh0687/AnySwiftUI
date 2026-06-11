//
//  PaymentMethodView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 05/06/26.
//

import SwiftUI

struct PaymentMethodView: View {
    
    @State var viewModel = PaymentMethodViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 0) {
                    IBLabel (
                        text: "Payment Type",
                        font: .medium(.largeTitle),
                        color: .black
                    )
                    
                    Divider()
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    PaymentCardView (
                        title: "Card Payment",
                        subTitle: "Hourly Wages + 15% Commission Fee",
                        isSelected: viewModel.isCardPayment) {
                            print("Set the card")
                            viewModel.isCardPayment = true
                            viewModel.isMonthlyPayment = false
                            viewModel.paymentType = "Each Job"
                        }
                    
                    PaymentCardView (
                        title: "Monthly Payment",
                        subTitle: "Hourly Wages + 20% Commission Fee",
                        isSelected: viewModel.isMonthlyPayment) {
                            print("Set the card")
                            viewModel.isCardPayment = false
                            viewModel.isMonthlyPayment = true
                            viewModel.paymentType = "Monthly"
                        }
                }

                Spacer()
                
                IBSubmitButton(buttonText: "Save Changes", isLoading: viewModel.isLoading) {
                    print("Call Api")
                    Task {
                        await callToUpdateCards()
                    }
                }
            }
            .padding(.all, 24)
            
            SimpleToastView (
                message: "Your card updated successfully",
                isPresented: viewModel.informUser,
                colorss: .GREEN.opacity(0.8)
            )
        }
        .onAppear {
            if AppState.shared.paymentType == "Monthly" {
                viewModel.isCardPayment = false
                viewModel.isMonthlyPayment = true
            } else {
                viewModel.isCardPayment = true
                viewModel.isMonthlyPayment = false
            }
        }
        .onChange(of: viewModel.gotResponse) {
            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.informUser = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.informUser = false
                }
            }
        }
    }
    
    func callToUpdateCards() async {
        viewModel.isLoading = true
        viewModel.gotResponse = false
        viewModel.informUser = false
        
        defer {
            viewModel.isLoading = false
        }
        
        do {
            let response = try await viewModel.updatePaymentMethod()
            if response.status == "1" {
                AppState.shared.paymentType = response.result?.request_payment_type ?? ""
                viewModel.gotResponse = true
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

struct PaymentCardView: View {
    
    let title: String
    let subTitle: String
    var isSelected: Bool
    let cloOnTab: (() -> Void)?
    
    var body: some View {
        Button {
          cloOnTab?()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    IBLabel (
                        text: title,
                        font: .semibold(.title),
                        color: .black
                    )
                    
                    IBLabel (
                        text: subTitle,
                        font: .medium(.subtitle),
                        color: .black
                    )
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.THEME.opacity(0.15) : Color.gray.opacity(0.12))
                        .frame(width: 34, height: 34)

                    Image(systemName: isSelected ? "checkmark" : "")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.THEME)
                }
            }
            .padding()
            .background (
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color(.systemGray6))
            )
            .overlay (
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
            )
            .shadow (
                color: Color.black.opacity(0.06),
                radius: 10,
                x: 0,
                y: 5
            )
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    PaymentMethodView()
}
