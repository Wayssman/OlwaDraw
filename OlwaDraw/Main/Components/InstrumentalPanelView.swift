//
//  InstrumentalPanelView.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 01.05.2023.
//

import SwiftUI

struct InstrumentalPanelView: View {
    @Binding var imageButtonTapped: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            // Picker Action Button
            Rectangle()
                .fill(.gray.opacity(0.2))
                .frame(height: 80)
                .cornerRadius(10)
                .background {
                    Text("Изображение")
                        .foregroundColor(.black)
                }
                .onTapGesture {
                    imageButtonTapped = true
                }
            
            // Other
            Rectangle()
                .fill(.gray.opacity(0.7))
                .frame(height: 80)
                .cornerRadius(10)
            
            // Other
            Rectangle()
                .fill(.gray.opacity(0.7))
                .frame(height: 80)
                .cornerRadius(10)
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}

struct InstrumentalPanelView_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentalPanelView(imageButtonTapped: .constant(false))
    }
}
