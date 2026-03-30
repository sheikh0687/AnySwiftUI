//
//  RegisteredView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 16/03/26.
//

import SwiftUI

struct RegisteredView: View {
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 24) {
                IBLabel (
                    text: "Welcome to Anytime Work! You can now post jobs to find suitable workers, anytime, anywhere.",
                    font: .semibold(.subtitle),
                    color: .gray
                )
                
                VStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 120)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                            .frame(width: 240, height: 240)

                        Image("profile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 180, height: 180)
                    }
                    
                    IBLabel(text: "Backery shop", font: .semibold(.title))
                }
                
                IBSubmitButton(buttonText: "Go to dashboard") {
                    print("Go to dashboard")
                }
                
                Spacer()
            }
            .padding(.all, 24)
        }
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    RegisteredView()
}
