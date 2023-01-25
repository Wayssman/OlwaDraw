//
//  MainPageViewModel.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 24.01.2023.
//

import SwiftUI
import PhotosUI

@MainActor class MainPageViewModel: ObservableObject {
    // MARK: Properties
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            getImageDataFromPickerItem()
        }
    }
    @Published var selectedImageData: Data?
    
    // MARK: Internal
    private func getImageDataFromPickerItem() {
        Task {
            guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else {
                return
            }
            
            selectedImageData = data
        }
    }
}
