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
            VStack(spacing: 16) {
                // Title
                VStack(spacing: 8) {
                    IBLabel (
                        text: "Welcome to Anytime Work",
                        font: .semibold(.largeHeadLine),
                        color: .primary
                    )
                    
                    IBLabel (
                        text: "Before Anything else, let us know what you are looking for",
                        font: .medium(.title),
                        color: .secondary
                    )
                    .multilineTextAlignment(.center)
                }
                
                // Toggle Buttons
                HStack {
                    Button {
                        withAnimation { isJob = true }
                    } label: {
                        Text("Jobs")
                            .font(.semibold(.title))
                            .foregroundColor(isJob ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(isJob ? Color.THEME : Color(.systemGray6))
                            .cornerRadius(24)
                    }
                    
                    Button {
                        withAnimation { isJob = false }
                    } label: {
                        Text("Workers")
                            .font(.semibold(.title))
                            .foregroundColor(isJob ? .gray : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(isJob ? Color(.systemGray6) : Color.THEME)
                            .cornerRadius(24)
                    }
                }
                
                // ⭐️ Dynamic Image Section
                ZStack(alignment: .bottom) {
                    
                    Group {
                        if isJob {
                            Image("Job")
                                .resizable()
                                .scaledToFit()
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)))
                        } else {
                            Image("Worker")
                                .resizable()
                                .scaledToFit()
                                .transition(.asymmetric(
                                    insertion: .move(edge: .leading).combined(with: .opacity),
                                    removal: .move(edge: .trailing).combined(with: .opacity)))
                        }
                    }
                    .frame(maxWidth: .infinity)
//                    .frame(minHeight: UIScreen.main.height * 0.45)  ⭐️ dynamic height
                    
                    IBLabel(
                        text: isJob ? "I am looking for jobs" : "I am looking for workers",
                        font: .semibold(.headLine),
                        color: .white
                    )
                    .padding(.bottom, 20)
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isJob)
                
                // Button
                IBSubmitButton (
                    buttonText: isJob ? "I am looking for jobs" : "I am looking for workers"
                ) {
                    goToLogin = true
                }
            }
            .padding(.all, 16)
        }
        .navigationDestination(isPresented: $goToLogin) {
            LoginView(userType: isJob ? "Worker" : "Client")
        }
    }
}

#Preview {
    UserTypeView()
}
