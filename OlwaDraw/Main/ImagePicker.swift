//
//  ImagePicker.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 21.02.2023.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @ObservedObject var viewModel: MainPageViewModel
    
    func makeUIViewController(context: Context) -> some PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, PHPickerViewControllerDelegate {
    let parent: ImagePicker
    
    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard
            let item = results.first,
            item.itemProvider.hasItemConformingToTypeIdentifier("public.image")
        else {
            return
        }
        
        item.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { [weak self] (url, error) in
            guard
                error == nil,
                let url = url
            else {
                return
            }
            
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            Task {
                await MainActor.run {
                    self?.parent.viewModel.addImageToComposition(imageUrl: url)
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.wait()
        }
    }
}
