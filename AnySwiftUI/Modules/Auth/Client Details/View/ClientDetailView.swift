//
//  ClientDetailView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 16/03/26.
//

import SwiftUI
import CountryPicker

struct ClientDetailView: View {
    
    @State private var viewModel = ClientDetailViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 24) {
                inputFields
                
                IBSubmitButton(buttonText: "FINISH") {
                    if viewModel.validateLoginFields() {
                        Task {
                            await callUpdateClientProfile()
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.all, 24)
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle("Create Business Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.navContinue) {
            RegisteredView()
        }
        .sheet(isPresented: $viewModel.showAddressPicker) {
            LocationPickerView { result in
                if let res = result {
                    viewModel.businessAddress = res["address"] as? String ?? ""
                    viewModel.businessLat     = res["lat"] as? Double ?? 0.0
                    viewModel.businessLon     = res["lng"] as? Double ?? 0.0
                }
            }
        }
        .sheet(isPresented: $viewModel.showCameraPicker) {
            ImagePicker(sourceType: .camera) { img in
                viewModel.selectedBusinessProfile = img
            }
        }
        .alert(item: $viewModel.customError) { error in
            Alert (
                title: Text(appName),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("Ok"))
            )
        }
    }
    
    func callUpdateClientProfile() async {
        viewModel.isLoading = true
        
        defer { viewModel.isLoading = false }
        
        do {
            let response = try await viewModel.updateClientDetails()
            if response.status == "1" {
                viewModel.saveCredentials(res: response.result!)
                viewModel.navContinue = true
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
    
    private var inputFields: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    IBTextField(placeholder: "Enter Business Name",
                                text: $viewModel.businessName, keyboardType: UIKeyboardType.phonePad)
                }
                Divider()
                    .frame(height: 0.5)
                    .background(Color.LIGHTGRAY)
            }
            
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    IBTextField(placeholder: "CIN or LLPIN or GSTIN or PAN Number",
                                text: $viewModel.registerNumber, keyboardType: UIKeyboardType.default)
                }
                Divider()
                    .frame(height: 0.5)
                    .background(Color.LIGHTGRAY)
            }
            
//            VStack(spacing: 4) {
//                HStack(spacing: 16) {
////                    Image(systemName: "phone.fill")
////                        .font(.title2)
////                        .foregroundColor(.gray)
//                    
//                    Button {
//                        viewModel.showCountryPicker = true
//                    } label: {
//                        HStack(spacing: 6) {
//                            if let countryObj = viewModel.countryObj {
//                                IBLabel(text: "+\(countryObj.phoneCode)", font: .medium(.largeTitle), color: .black)
//                            }
//                            
//                            Image(systemName: "chevron.down")
//                                .font(.system(size: 12, weight: .medium))
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .background(Color.white)
//      
//                    IBTextField(placeholder: "Mobile", text: $viewModel.mobileNumber, keyboardType: .phonePad)
//                }
//                Divider()
//                    .frame(height: 0.5)
//                    .background(Color.LIGHTGRAY)
//            }
            
            VStack(alignment: .leading, spacing: 4) {
                Button {
                    viewModel.showAddressPicker = true
                } label: {
                    HStack {
                        IBLabel (
                            text: viewModel.businessAddress.isEmpty ? "Choose Address" : viewModel.businessAddress,
                            font: .regular(.subtitle),
                            color: viewModel.businessAddress.isEmpty ? .gray : .black
                        )
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                
                Divider()
                    .frame(height: 0.5)
                    .background(Color.LIGHTGRAY)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    .frame(height: 140)

                if let image = viewModel.selectedBusinessProfile {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                } else {
                    Image("profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .background (
                            Circle()
                                .stroke(Color.black.opacity(0.2), lineWidth: 0.5)
                        )
                }
                
                Button {
                    viewModel.showCameraPicker = true
                } label: {
                    IBLabel(text: "Upload a photo", font: .semibold(.note),
                            color: .white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(viewModel.selectedBusinessProfile == nil ? Color("BUTTON_COLOR") : Color("BUTTON_COLOR").opacity(0.75))
                    .cornerRadius(6)
                }
            }
        }
    }
}

#Preview {
    ClientDetailView()
}
