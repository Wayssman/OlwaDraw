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
            // Image Preview Area
            ZStack(alignment: .topTrailing) {
                // Image Preview
                Rectangle()
                    .fill(.gray.opacity(0.2))
                
                if
                    let selectedImageData = viewModel.selectedImageData,
                    let uiImage = UIImage(data: selectedImageData)
                {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                
                // Export Button
                ZStack(alignment: .center) {
                    Circle()
                        .fill(.white)
                        .frame(
                            width: 32,
                            height: 32
                        )
                    
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .frame(width: 14, height: 16)
                        .offset(y: -2)
                        .foregroundColor(.black)
                }
                .offset(
                    CGSize(
                        width: -10,
                        height: 10
                    )
                )
                .shadow(radius: 2)
                .onTapGesture {
                    viewModel.exportData()
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            
            // Instrumental Panel
            HStack(spacing: 10) {
                // Picker Action Button
                PhotosPicker(
                    selection: $viewModel.selectedItem,
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
            Rectangle()
                .fill(.white)
                .frame(maxHeight: 200)
                .cornerRadius(radius: 20, corners: [.topLeft, .topRight])
                .shadow(color: .gray, radius: 8, x: 0, y: 0)
        }
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $viewModel.isAlertShown) {
            Alert(
                title: Text("Ошибка"),
                message: Text("Не удалось экспортировать изображение"),
                dismissButton: .cancel()
            )
        }
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}
