//
//  SimpleToastView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 05/06/26.
//

import SwiftUI

struct SimpleToastView: View {
    
    let message: String
    let isPresented: Bool
    let colorss: Color

    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .font(.regular(.subtitle))
                .padding()
                .frame(maxWidth: .infinity)
                .background(colorss)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
                .opacity(isPresented ? 1 : 0)
                .offset(y: isPresented ? 0 : 50)
                .animation(.easeInOut(duration: 0.3), value: isPresented)
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    SimpleToastView(message: "Hello,", isPresented: true, colorss: .red.opacity(0.8))
}
