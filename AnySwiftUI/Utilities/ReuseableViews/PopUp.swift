//
//  PopUp.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 24/03/26.
//

import SwiftUI

struct PopUp: View {
    
    var cloOk: () -> Void = { }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            VStack(spacing: 16) {
                
                IBLabel (
                    text: "Successfull!", font: .semibold(.largeTitle))
                IBLabel (
                    text: "Your account is pending approval and you will receive notifications once you are authorised to book jobs.",
                    font: .regular(.subtitle),
                    color: .black
                )
                .multilineTextAlignment(.center)
                
                Button(action: {
                    self.cloOk()
                }) {
                    Text("Ok")
                        .font(.bold(.subtitle))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(.BUTTON)
                        .cornerRadius(12)
                }
            }
        } // MAIN VSTACK
        .padding(16)
        .background (
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.gray, lineWidth: 0.5)
                .background (
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.white))
                )
        )
        .padding(.horizontal, 40)
    }
    
}

struct PopBeforeBooking: View {
    
    var cloYes: (Bool) -> Void = { _ in }
    var companyName: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            VStack(spacing: 16) {
                
                IBLabel (
                    text: "Are you sure you want to cancel your booking?", font: .semibold(.largeTitle)
                )
                .multilineTextAlignment(.center)
                
                IBLabel (
                    text: companyName,
                    font: .regular(.subtitle),
                    color: .black
                )
                .multilineTextAlignment(.center)
                
                IBLabel (
                    text: "Any Confirmed bookings will have $10 cancellation penalty fee to be deducted on you next shifts payment.",
                    font: .semibold(.subtitle),
                    color: .black
                )
                .multilineTextAlignment(.center)
                
                IBLabel (
                    text: "Account suspension for 1 month if you have cancelled last minute twice in a month.",
                    font: .semibold(.subtitle),
                    color: .black
                )
                .multilineTextAlignment(.center)
                
                IBLabel (
                    text: "Any shift cancelled within 48 hours of work start with is considered last minute.",
                    font: .regular(.subtitle),
                    color: .black
                )
                .multilineTextAlignment(.center)
                
                HStack(spacing: 24) {
                    IBSimpletButton(height: 24, width: 120, fgColor: .black, buttonText: "Yes, Proceed", bg: .clear, cloClicked: {
                        cloYes(true)
                    })
                    .padding(.all, 8)
                    .overlay (
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.BUTTON, lineWidth: 0.5)
                    )
                    
                    IBSimpletButton(height: 24, width: 120, fgColor: .black, buttonText: "Back", bg: .clear, cloClicked: {
                        cloYes(false)
                    })
                    .padding(.all, 8)
                    .overlay (
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.BUTTON, lineWidth: 0.5)
                    )
                }
            }
        } // MAIN VSTACK
        .padding(16)
        .background (
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.gray, lineWidth: 0.5)
                .background (
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.white))
                )
        )
        .padding(.horizontal, 40)
    }
}

struct PopUpDelete: View {
    
    let companyDetail: String
    var cloOk: () -> Void = { }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            VStack(spacing: 16) {
                
                IBLabel (
                    text: "Your shift has been successfully cancelled in:", font: .semibold(.largeTitle)
                )
                .multilineTextAlignment(.center)
                
                IBLabel (
                    text: companyDetail,
                    font: .regular(.subtitle),
                    color: .black
                )
                .multilineTextAlignment(.center)
                
                IBSimpletButton (
                    height: 24, width: 120, fgColor: .black,buttonText: "Ok", bg: .clear, cloClicked: {
                        cloOk()
                    }
                )
                .padding(.all, 8)
                .overlay (
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.BUTTON, lineWidth: 0.5)
                )
            }
        } // MAIN VSTACK
        .padding(16)
        .background (
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.gray, lineWidth: 0.5)
                .background (
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.white))
                )
        )
        .padding(.horizontal, 40)
    }
    
}

#Preview {
    PopUpDelete(companyDetail: "Techimmense Software solution")
}
