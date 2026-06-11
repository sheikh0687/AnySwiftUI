//
//  SettingView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 30/03/26.
//

import SwiftUI

struct OverallSettingView: View {
    
    @EnvironmentObject var appState: AppState
    @State var viewModel = AppSettingViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                if appState.userType == "Client" {
                    BusinessView(viewModel: viewModel)
                    
                    AccountView(viewModel: viewModel)
                    
                    OthersView(viewModel: viewModel)
                } else {
                    AccountView(viewModel: viewModel)
                    
                    OthersView(viewModel: viewModel)
                }
            }
            .padding(.all, 16)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                logout()
            } label: {
                Text("Logout")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(Color.white)
                    .overlay {
                        Capsule()
                            .stroke(Color.red.opacity(0.7), lineWidth: 1.5)
                    }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .background(Color(.systemBackground))
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.navToCurrentShift) {
            CurrentShiftView()
        }
        .navigationDestination(isPresented: $viewModel.navToChangePassword) {
            ChangePasswordView()
        }
        .navigationDestination(isPresented: $viewModel.navToEditProfile) {
            ProfileView()
        }
        .navigationDestination(isPresented: $viewModel.navToOutletList) {
            OutletListView()
        }
        .navigationDestination(isPresented: $viewModel.navToPaymentType) {
            PaymentMethodView()
        }
        .navigationDestination(isPresented: $viewModel.navToSetHourlyRate) {
            SetRateView()
        }
        .navigationDestination(isPresented: $viewModel.navToHistory) {
            ClientTransactionHistoryView()
        }

    }
    
    func logout() {
        appState.isLoggedIn = false
        appState.useriD = ""
        appState.userFirstName = ""
        appState.userLastName = ""
        appState.emailiD = ""
        appState.userMobile = ""
        appState.ios_RegisterediD = ""
        appState.userType = ""
        appState.countryiD = ""
        appState.clientiD = ""
        appState.businessName = ""
        appState.businessLogo = ""
        appState.outletName = ""
        appState.outletImage = ""
    }
}

struct BusinessView: View {
    
    let viewModel: AppSettingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
                IBLabel (
                    text: "Business Setting",
                    font: .bold(.headLine),
                    color: .BLACK
                )
                
                Divider()
            }
            
            BusinessSettingForm (
                title: "Profile",
                subTitle: "Edit your profile",
                icons: "person"
            ) {
                viewModel.navToEditProfile = true
            }
            
            BusinessSettingForm (
                title: "My Outlets",
                subTitle: "Add, edit and delete outlet",
                icons: "storefront"
            ) {
                viewModel.navToOutletList = true
            }
            
            BusinessSettingForm (
                title: "Billing",
                subTitle: "Payment Mode and Types",
                icons: "wallet.pass"
            ) {
                viewModel.navToPaymentType = true
            }
            
            BusinessSettingForm (
                title: "Current Shift",
                subTitle: "Shift update and delete",
                icons: "clock.arrow.circlepath"
            ) {
                viewModel.navToCurrentShift = true
            }
            
            BusinessSettingForm (
                title: "History",
                subTitle: "Employment and payment history",
                icons: "clock.arrow.circlepath"
            ) {
                viewModel.navToHistory = true
            }
            
            BusinessSettingForm (
                title: "Rates",
                subTitle: "Employee payment history",
                icons: "dollarsign.circle"
            ) {
                viewModel.navToSetHourlyRate = true
            }
        }
    }
}

struct BusinessSettingForm: View {
    
    var title: String
    var subTitle: String
    var icons: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        
        Button {
            action?()
        } label: {
            
            HStack(spacing: 16) {
                
                // MARK: - ICON
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.systemGray5))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icons)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.black)
                }
                
                // MARK: - TEXT
                VStack(alignment: .leading, spacing: 5) {
                    
                    IBLabel (
                        text: title,
                        font: .semibold(.title),
                        color: .BLACK
                    )
                    .lineLimit(1)
                    
                    IBLabel (
                        text: subTitle,
                        font: .medium(.description),
                        color: .gray
                    )
                    .lineLimit(2)
                }
                
                Spacer(minLength: 10)
                
                // MARK: - CHEVRON
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.gray.opacity(0.8))
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
        .buttonStyle(.plain)
    }
}

struct AccountView: View {
    
    let viewModel: AppSettingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
                IBLabel (
                    text: "Account Setting",
                    font: .bold(.headLine),
                    color: .BLACK
                )
                Divider()
            }
            AccountSettingForm
        }
    }
    
    private var AccountSettingForm: some View {
        return VStack(alignment: .leading, spacing: 8) {
            Button {
                viewModel.navToChangePassword = true
            } label: {
                HStack {
                    IBLabel (
                        text: "Change Password",
                        font: .regular(.largeTitle),
                        color: .BLACK
                    )
                }
            }
            
            Button {
                print("Call Action")
            } label: {
                HStack {
                    IBLabel (
                        text: "Refer Friends",
                        font: .regular(.largeTitle),
                        color: .BLACK
                    )
                }
            }
        }
    }
}

struct OthersView: View {
    
    let viewModel: AppSettingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
                IBLabel (
                    text: "Others",
                    font: .bold(.headLine),
                    color: .BLACK
                )
                Divider()
            }
            OthersSettingForm
        }
    }
    
    private var OthersSettingForm: some View {
        return VStack(alignment: .leading, spacing: 8) {
            Button {
                print("Call Action")
            } label: {
                HStack {
                    IBLabel (
                        text: "Privacy Policy",
                        font: .regular(.largeTitle),
                        color: .BLACK
                    )
                }
            }
            
            Button {
                print("Call Action")
            } label: {
                HStack {
                    IBLabel (
                        text: "Terms and Conditions",
                        font: .regular(.largeTitle),
                        color: .BLACK
                    )
                }
            }
            
            Button {
                print("Call Action")
            } label: {
                HStack {
                    IBLabel (
                        text: "Customer Service",
                        font: .regular(.largeTitle),
                        color: .BLACK
                    )
                }
            }
        }
    }
}

#Preview {
    OverallSettingView()
}
