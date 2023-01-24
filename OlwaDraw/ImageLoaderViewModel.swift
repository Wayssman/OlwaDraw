//
//  ImageLoaderViewModel.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 24.01.2023.
//

import SwiftUI

@MainActor class ImageLoaderViewModel: ObservableObject {
    @Published private(set) var workImage: Image? = nil
    
    func loadImage() {
        
    }
}
