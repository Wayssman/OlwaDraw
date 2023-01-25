//
//  ContentView.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 24.01.2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject private var viewModel = ImageLoaderViewModel()
    @State private var showDocumentPicker = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Text("Select a photo")
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                guard let data = try? await newItem?.loadTransferable(type: Data.self) else {
                    return
                }
                selectedImageData = data
            }
        }
        
        if
            let selectedImageData,
            let uiImage = UIImage(data: selectedImageData)
        {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
