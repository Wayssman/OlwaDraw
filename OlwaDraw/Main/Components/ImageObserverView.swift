//
//  ImageObserverView.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 01.05.2023.
//

import SwiftUI

struct ImageObserverView: View {
    let image: UIImage?
    
    var body: some View {
        if
            let uiImage = image
        {
            HStack {
                Spacer()
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 5)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                Spacer()
            }
            .padding(.bottom, 15)
        }
    }
}

struct ImageObserverView_Previews: PreviewProvider {
    static var previews: some View {
        ImageObserverView(image: nil)
    }
}
