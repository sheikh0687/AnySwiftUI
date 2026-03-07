//
//  Buttons.swift
//  MyLedgerBook
//
//  Created by shoaib on 27/08/25.
//

import SwiftUI

struct IBSubmitButton : View {
    
    var buttonText = ""
    var isDisabled = false
    var font: Font = .medium(.title)
    var cloClicked:(()->Void)?
    
    var body: some View {
        Button {
            self.cloClicked?()
        } label: {
            IBLabel(text: buttonText , font: font, color: .white)
                .foregroundStyle(.white)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 40 , alignment: .center)
                .background(.BUTTON)
                .opacity(isDisabled ? 0.7 : 1)
                .cornerRadius(8)
        }
        .disabled(isDisabled)
    }
}

struct IBButtonWithImage: View {
    
    var Width = 50.0
    var height = 50.0
    var onTap: () -> Void
    var imageName: String
    
    init(imageName: String, Width: Double = 50.0, height: Double = 50.0, onTap: @escaping () -> Void) {
        self.imageName = imageName
        self.Width = Width
        self.height = height
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            VStack(alignment: .center) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .tint(.THEME)
            }
            .frame(width: Width, height: height, alignment: .center)
        }
    }
}

struct IBButtonWithImageAndBackground: View {
    
    var buttonText: String
    var Width = 50.0
    var height = 50.0
    var onTap: () -> Void
    var imageName: String
    var font: Font = .medium(.title)
    
    init(imageName: String, buttonText: String, Width: Double = 50.0, height: Double = 50.0, onTap: @escaping () -> Void) {
        self.buttonText = buttonText
        self.imageName = imageName
        self.Width = Width
        self.height = height
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            HStack(alignment: .center, spacing: 16) {
                IBLabel(text: buttonText , font: font, color: .white)
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .tint(.white)
                    .frame(width: 20, height: 20, alignment: .center)
            }
            .foregroundStyle(.white)
            .frame(minWidth: Width, maxWidth: .infinity, minHeight: height, maxHeight: height , alignment: .center)
            .background(.THEME)
            .cornerRadius(8)
        }
    }
}

struct IBButtonWithSystemImageAndBackground: View {
    
    var buttonText: String
    var Width = 50.0
    var height = 50.0
    var onTap: () -> Void
    var imageName: String
    var font: Font = .medium(.subtitle)
    
    init(imageName: String, buttonText: String, Width: Double = 50.0, height: Double = 50.0, onTap: @escaping () -> Void) {
        self.buttonText = buttonText
        self.imageName = imageName
        self.Width = Width
        self.height = height
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            HStack(alignment: .center, spacing: 8) {
                IBLabel(text: buttonText , font: font, color: .white)
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .tint(.white)
                    .frame(width: 20, height: 20, alignment: .center)
            }
            .foregroundStyle(.white)
            .frame(minWidth: Width, maxWidth: Width, minHeight: height, maxHeight: height , alignment: .center)
            .background(.THEME)
            .cornerRadius(8)
        }
    }
}
