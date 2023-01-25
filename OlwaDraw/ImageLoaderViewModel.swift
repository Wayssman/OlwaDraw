//
//  ImageLoaderViewModel.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 24.01.2023.
//

import SwiftUI

@MainActor class ImageLoaderViewModel: ObservableObject {
    // MARK: Properties
    @Published var workImage: Image? = nil
    
    // MARK: Dependencies
    private let fileManager = FileManager()
    
    func loadImage() {
        
    }
}
