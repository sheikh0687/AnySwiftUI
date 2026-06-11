//
//  AddUpdateOutletView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 04/06/26.
//

import SwiftUI

struct AddUpdateOutletView: View {
    
    @State var viewModel: AddUpdateOutletViewModel
    @Environment(\.dismiss) var dismess
    
    var body: some View {
         ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 24) {
                inputFields
                
                IBSubmitButton(buttonText: viewModel.isFor == "Update" ? "UPDATE" : "ADD") {
                    if viewModel.validFeilds() {
                        Task {
                            await callAddUpdateOutlet()
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.all, 24)
            
            SimpleToastView (
                message: viewModel.isFor == "Update"
                ? "Your outlet updated successfully."
                : "Your outlet added successfully.",
                isPresented: viewModel.showSuccessMsg,
                colorss: .GREEN.opacity(0.8)
            )
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle(viewModel.isFor == "Update" ? "Update Outlet" : "Add Outlet" )
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showAddressPicker) {
            LocationPickerView { result in
                if let res = result {
                    viewModel.outletAddress = res["address"] as? String ?? ""
                    viewModel.outletLat     = res["lat"] as? Double ?? 0.0
                    viewModel.outletLon     = res["lng"] as? Double ?? 0.0
                }
            }
        }
        .sheet(isPresented: $viewModel.showCameraPicker) {
            ImagePicker(sourceType: .camera) { img in
                viewModel.outletLogoImg = img
            }
        }
        .alert(item: $viewModel.customError) { error in
            Alert (
                title: Text(appName),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("Ok"))
            )
        }
        .onChange(of: viewModel.responseComplete) {
            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.showSuccessMsg = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.showSuccessMsg = false
                }
                dismess()
            }
        }
    }
    
    func callAddUpdateOutlet() async {
        do {
            let response = try await viewModel.addOrUpdateOutlet()
            if response.status == "1" {
                viewModel.responseComplete = true
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }

    private var inputFields: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    IBTextField(placeholder: "Enter Outlet Name",
                                text: $viewModel.outletName, keyboardType: UIKeyboardType.phonePad)
                }
                Divider()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Button {
                    viewModel.showAddressPicker = true
                } label: {
                    HStack {
                        IBLabel (
                            text: viewModel.outletAddress.isEmpty ? "Select Outlet Address" : viewModel.outletAddress,
                            font: .regular(.subtitle),
                            color: viewModel.outletAddress.isEmpty ? .gray : .black
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
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                    .frame(height: 140)
                
                if let selectedImage = viewModel.outletLogoImg {

                    // User selected image
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())

                } else if let imageURL = URL(string: viewModel.outletLogoUrl),
                          !viewModel.outletLogoUrl.isEmpty {

                    // API image
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image("profile")
                            .resizable()
                            .scaledToFit()
                            .background (
                                Circle()
                                    .stroke(Color.black.opacity(0.2), lineWidth: 0.5)
                            )
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())

                } else {

                    // Placeholder
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
                    .background(viewModel.outletLogoImg == nil ? Color("BUTTON_COLOR") : Color("BUTTON_COLOR").opacity(0.75))
                    .cornerRadius(6)
                }
            }
        }
    }
}

#Preview {
    AddUpdateOutletView(viewModel: .init(outletiD: "1", outletName: "dd", outletAddress: "ss", outletLat: 22, outletLon: 12, outletLogoUrl: "sas", isFor: "Update"))
}
