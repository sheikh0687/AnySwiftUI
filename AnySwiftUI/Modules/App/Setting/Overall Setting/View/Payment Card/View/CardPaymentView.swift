//
//  CardPaymentView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 06/06/26.
//

import SwiftUI
import StripePayments
import StripePaymentsUI

struct CardPaymentView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var viewModel = CardPaymentViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                infoSection
                cardBrandLogos
                nameOnCardField
                stripeCardSection
                saveCardButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .navigationTitle("Card Payment Information")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadCustomeriD()
        }
        .alert("Payment", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
    func loadCustomeriD() async {
        
        guard viewModel.customerId.isEmpty else {
            print("Customer id already created!!")
            return
        }
        
        do {
            let response = try await viewModel.getCustomeriD()
            if response.status == "1" {
                viewModel.customerId = response.result?.customer_id ?? ""
            }
        } catch {
            viewModel.alertMessage = error.localizedDescription
        }
    }
    
    private var infoSection: some View {
        IBLabel (
            text: "Upon approval of shift bookings, your card will be charged for\n*Estimated hourly rates + 15% commission fee.\nOver time charges will be processed after the shift ends.\n\nAutomatic refunds are provided for:\n*Under time\nNo-shows/Cancellations",
            font: .system(size: 14, weight: .medium),
            color: .black
        )
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }
    
    private var cardBrandLogos: some View {
        HStack(spacing: 12) {
            Spacer()
            Image("mastercard")
                .resizable().scaledToFit().frame(height: 36)
            Image("visa")
                .resizable().scaledToFit().frame(height: 36)
            Image("amex")
                .resizable().scaledToFit().frame(height: 36)
            Spacer()
        }
    }
    
    private var nameOnCardField: some View {
        VStack(alignment: .leading, spacing: 6) {
            IBLabel (
                text: "Name On Card",
                font: .system(size: 14, weight: .regular),
                color: .black
            )
            TextField("Enter name on card", text: $viewModel.cardHolderName)
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .font(.system(size: 15))
        }
    }
    
    private var stripeCardSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            IBLabel (
                text: "Card Details",
                font: .system(size: 14, weight: .regular),
                color: .black
            )
            StripeCardField (
                cardParams: $viewModel.cardParams,
                isValid: $viewModel.isCardValid
            )
            .frame(height: 50)
            .padding(.horizontal, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
        }
    }
    
    private var saveCardButton: some View {
        Button {
            viewModel.saveCard()
        } label: {
            ZStack {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    IBLabel(
                        text: "Save Card",
                        font: .system(size: 16, weight: .semibold),
                        color: .white
                    )
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(viewModel.isLoading)
        .padding(.top, 8)
    }
    
    //    @ToolbarContentBuilder
    //    private var backButton: some ToolbarContent {
    //        ToolbarItem(placement: .topBarLeading) {
    //            Button {
    //                dismiss()
    //            } label: {
    //                Image(systemName: "chevron.left")
    //                    .foregroundStyle(.black)
    //            }
    //        }
    //    }
}

struct StripeCardField: UIViewRepresentable {
    
    @Binding var cardParams: STPPaymentMethodCardParams?
    @Binding var isValid: Bool
    
    func makeUIView(context: Context) -> STPPaymentCardTextField {
        let field = STPPaymentCardTextField()
        field.delegate = context.coordinator
        field.borderWidth = 0
        field.backgroundColor = .clear
        field.postalCodeEntryEnabled = false
        return field
    }
    
    func updateUIView(_ uiView: STPPaymentCardTextField, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(cardParams: $cardParams, isValid: $isValid)
    }
    
    class Coordinator: NSObject, STPPaymentCardTextFieldDelegate {
        
        @Binding var cardParams: STPPaymentMethodCardParams?
        @Binding var isValid: Bool
        
        init(cardParams: Binding<STPPaymentMethodCardParams?>, isValid: Binding<Bool>) {
            _cardParams = cardParams
            _isValid = isValid
        }
        
        func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
            isValid = textField.isValid
            cardParams = textField.isValid ? textField.paymentMethodParams.card : nil
        }
    }
}

#Preview {
    CardPaymentView()
}
