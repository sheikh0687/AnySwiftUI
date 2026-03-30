//
//  TextFields.swift
//  MyLedgerBook
//
//  Created by shoaib on 27/08/25.
//

import SwiftUI

struct IBTextField: View {
    
    @State var placeholder = ""
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var font: Font = .regular(.title)
    @State var textLimit: Int?
    
    var body: some View {
        GeometryReader(content: { geometry in
            TextField(placeholder, text: $text)
            //                .foregroundStyle(Color.font)
                .font(font)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .frame(width: geometry.size.width, height: 36)
            //                .overlay(RoundedRectangle(cornerRadius: 4.0).strokeBorder(Color.border, style: StrokeStyle(lineWidth: 1.0)))
            //                .background(.bg)
                .cornerRadius(4)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(keyboardType)
                .onChange(of: text) {
                    if let limit = textLimit {
                        text = String(text.prefix(limit))
                    }
                }
        })
        .frame(height: 36)
    }
}

struct IBSecureTextField: View {
    
    var placeholder: String = ""
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var font: Font = .regular(.subtitle)
    var textLimit: Int?
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(font)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 35)) // space for eye
                .frame(width: geometry.size.width, height: 36)
                .cornerRadius(4)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(keyboardType)
                .onChange(of: text) { _, newValue in
                    if let limit = textLimit {
                        text = String(newValue.prefix(limit))
                    }
                }
                
                Button(action: {
                    isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            }
        }
        .frame(height: 36)
    }
}
//#Preview {
//    IBTextField(, text: <#Binding<String>#>)
//}
