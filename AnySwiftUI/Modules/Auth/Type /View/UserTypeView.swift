//
//  UserTypeView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 10/02/26.
//

import SwiftUI

struct UserTypeView: View {
    
    @State private var isJob: Bool = true
    @State private var goToLogin: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 24) {
                
                VStack(spacing: 8) {
//                    Text("Welcome to Anytime Work")
//                        .font(.customfont(.heavy, fontSize: 24))
                    IBLabel(text: "Welcome to Anytime Work", font: .semibold(.largeHeadLine))
                    
//                    Text("Before Anything else, let us know what you are looking for")
//                        .font(.customfont(.medium, fontSize: 16))
//                        .foregroundColor(.gray)
//                        .frame(maxWidth: .infinity)
//                        .multilineTextAlignment(.center)
                    
                    IBLabel(text: "Before Anything else, let us know what you are looking for", font: .medium(.title), color: .gray)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }
                
                HStack {
                    Button {
                        print("Jobs")
                        withAnimation {
                            isJob = true
                        }
                    } label: {
                        Text("Jobs")
                            .font(.semibold(.title))
                            .foregroundColor(isJob == true ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(isJob == true ? Color.THEME : Color(.systemGray6))
                            .cornerRadius(24)
                    }
                    
                    Button {
                        print("Jobs")
                        withAnimation {
                            isJob = false
                        }
                    } label: {
                        Text("Workers")
                            .font(.semibold(.title))
                            .foregroundColor(isJob == true ? .gray : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(isJob == true ? Color(.systemGray6) : Color.THEME)
                            .cornerRadius(24)
                    }
                }
                
                ZStack {
                    if isJob {
                        Image("Job")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 500)
                            .transition (
                                .asymmetric (
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity))
                            )
                    } else {
                        Image("Worker")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 500)
                            .transition (
                                .asymmetric (
                                    insertion: .move(edge: .leading).combined(with: .opacity),
                                    removal: .move(edge: .trailing).combined(with: .opacity))
                            )
                    }
                    IBLabel(text: isJob == true ? "I am looking for jobs" : "I am looking for workers", font: .semibold(.headLine), color: .white)
                        .offset(y: 200)
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isJob)
                
//                Button {
//                    print("Select")
//                    goToLogin = true
//                } label: {
//                    Text(isJob == true ? "I am looking for jobs" : "I am looking for workers")
//                        .font(.customfont(.black, fontSize: 18))
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                        .background(Color.BUTTON)
//                        .cornerRadius(12)
//                }
                
                IBSubmitButton(buttonText: isJob == true ? "I am looking for jobs" : "I am looking for workers") {
                    goToLogin = true
                }
            }
            .padding(.horizontal, 24)
        }
        .navigationDestination(isPresented: $goToLogin) {
            LoginView(userType: isJob == true ? "Worker" : "Client")
        }
    }
}

#Preview {
    UserTypeView()
}
