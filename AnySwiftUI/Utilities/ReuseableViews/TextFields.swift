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
                .onChange(of: text) { _ in
                    if let limit = textLimit {
                        text = String(text.prefix(limit))
                    }
                }
        })
        .frame(height: 36)
    }
}

struct IBSecureTextField: View {
    
    @State var placeholder = ""
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var font: Font = .regular(.subtitle)
    @State var textLimit: Int?
    
    var body: some View {
        GeometryReader(content: { geometry in
            SecureField(placeholder, text: $text)
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
                .onChange(of: text) { _ in
                    if let limit = textLimit {
                        text = String(text.prefix(limit))
                    }
                }
        })
        .frame(height: 36)
    }
}

//#Preview {
//    IBTextField(, text: <#Binding<String>#>)
//}
