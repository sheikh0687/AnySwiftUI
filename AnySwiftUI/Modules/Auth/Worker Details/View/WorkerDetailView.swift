//
//  WorkerDetailView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 16/03/26.
//

import SwiftUI

struct WorkerDetailView: View {
    
    @StateObject private var viewModel = WorkerDetailViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center, spacing: 24) {
                    
                    profileImageView
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        IBLabel (
                            text: "Do you meet and agree with the following requirements?",
                            font: .regular(.title),
                            color: .black
                        )
                        .multilineTextAlignment(.center)

                        requirementRow("I am at least 16 years old.")
                        requirementRow("I have a valid government‑issued ID for identity verification.")
                        requirementRow("I am able to work in F&B, hospitality, or events roles in my country of residence.")
                        requirementRow("I acknowledge that I am signing up as an independent contractor under a Contract for Service, not as an employee of Anytime Work or its partners.")
                        requirementRow("I understand I am responsible for my own insurance coverage in the event of any injury or accident at work, unless otherwise required by local law or stated in writing.")
                        requirementRow("I have read and agree to the Anytime Work Terms of Use and Contractor Agreement applicable to my country.")
                    }
                    .padding()
                    .background (
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(radius: 3)
                    )
                    
                    
                    IBSubmitButton(buttonText: "I AGREE") {
                        if viewModel.validateFields() {
                            Task {
                                do {
                                    let response = try await viewModel.updateWorkerProfile()
                                    if response.status == "1" {
                                        viewModel.isWorkerCreated = true
                                    }
                                } catch {
                                    viewModel.customError = .customError(message: error.localizedDescription)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        IBLabel (
                            text: "Important Notes",
                            font: .medium(.title),
                            color: .black
                        )
                        
                        IBLabel (
                            text: "• Malaysia: Certain roles may require Typhoid Vaccine and Food Hygiene Certificate.",
                            font: .regular(.subtitle),
                            color: .gray
                        )
                        
                        IBLabel (
                            text: "• Singapore: Some roles may require a valid Food Hygiene Certificate. CPF is not paid for independent contractors.",
                            font: .regular(.subtitle),
                            color: .gray
                        )
                    }
                    .padding()
                    .background (
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                    )
                }
                .padding(.all, 24)
            }
            
            if viewModel.isWorkerCreated {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                viewModel.isWorkerCreated = false
                            }
                        }
                    
                    PopUp(cloOk: {
                        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
                        window?.rootViewController = UIHostingController(rootView: DashboardView())
                    })
                    .transition(.scale)
                    .zIndex(1)
                }
            }

        }
        .sheet(isPresented: $viewModel.showCameraActionSheet) {
            ImagePicker(sourceType: .camera) { img in
                viewModel.selectedProfileImage = img
            }
        }
        .alert(item: $viewModel.customError) { error in
            Alert (
                title: Text(appName),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("Ok"))
            )
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle("Create Worker Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var profileImageView: some View {
        ZStack(alignment: .bottomTrailing) {
            if let uiImage = viewModel.selectedProfileImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
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
            
            Image("edit")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(2)
                .background(.white)
                .cornerRadius(6)
                .shadow(radius: 2)
        }
        .onTapGesture {
            viewModel.showCameraActionSheet = true
        }
    }
    
    func requirementRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {

            IBLabel(text: "*", font: .regular(.subtitle))
                .padding(.top, 2)
            
            IBLabel (
                text: text,
                font: .regular(.subtitle),
                color: .black
            )
        }
    }
}

#Preview {
    WorkerDetailView()
}
