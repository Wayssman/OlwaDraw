//
//  MainPageViewModel.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 24.01.2023.
//

import SwiftUI
import PhotosUI

@MainActor class MainPageViewModel: NSObject, ObservableObject {
    // MARK: Properties
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            getImageDataFromPickerItem()
        }
    }
    @Published var selectedImageData: Data?
    @Published var isAlertShown: Bool = false
    
    // MARK: Internal
    private func getImageDataFromPickerItem() {
        Task {
            guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else {
                return
            }
            
            selectedImageData = data
        }
    }
    
    func exportData() {
        guard
            let selectedImageData,
            let imageForExport = UIImage(data: selectedImageData)
        else {
            isAlertShown = true
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageForExport, self, #selector(exportCompletion), nil)
    }
    
    @objc private func exportCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        isAlertShown = (error != nil)
    }
}
