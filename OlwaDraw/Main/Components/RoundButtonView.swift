//
//  RoundButtonView.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 01.05.2023.
//

import SwiftUI

struct RoundButtonView: View {
    let systemIconName: String
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(.white)
                .frame(
                    width: 32,
                    height: 32
                )
            
            Image(systemName: systemIconName)
                .resizable()
                .frame(width: 14, height: 16)
                .offset(y: -2)
                .foregroundColor(.black)
        }
        .shadow(radius: 2)
    }
}

struct RoundButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RoundButtonView(systemIconName: "square.and.arrow.up")
    }
}
