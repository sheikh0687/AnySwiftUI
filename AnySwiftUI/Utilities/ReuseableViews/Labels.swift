//
//  Labels.swift
//  MyLedgerBook
//
//  Created by shoaib on 27/08/25.
//

import SwiftUI

struct IBLabel: View {
    
    var text: String
    var font: Font
    var color: Color = .black
    
    var body: some View {
        Text(text)
            .foregroundStyle(color)
            .font(font)
    }
}
