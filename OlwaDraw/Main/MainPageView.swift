//
//  MainPageView.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 24.01.2023.
//

import SwiftUI
import PhotosUI

struct MainPageView: View {
    @ObservedObject var viewModel = MainPageViewModel()
    
    var body: some View {
        VStack {
            // Image Preview
            ZStack {
                Rectangle()
                    .fill(.gray.opacity(0.2))
                
                if
                    let uiImage = viewModel.assembledCompositionImage
                {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            
            // Instrumental Panel
            HStack(spacing: 10) {
                // Picker Action Button
                PhotosPicker(
                    selection: $viewModel.lastPickedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("Фон")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: 100)
                        .background(
                            Rectangle()
                                .fill(.gray.opacity(0.2))
                                .cornerRadius(10)
                        )
                }
                
                // Other
                Rectangle()
                    .fill(.gray.opacity(0.7))
                    .frame(maxHeight: 100)
                    .cornerRadius(10)
                
                // Other
                Rectangle()
                    .fill(.gray.opacity(0.7))
                    .frame(maxHeight: 100)
                    .cornerRadius(10)
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            
            // Items List
            ObjectsListView(viewModel: viewModel)
                .frame(maxHeight: 200)
                .cornerRadius(radius: 20, corners: [.topLeft, .topRight])
                .shadow(color: .gray, radius: 8, x: 0, y: 0)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}
