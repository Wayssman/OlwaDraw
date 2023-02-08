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
    @Published var lastPickedItem: PhotosPickerItem? {
        didSet {
            didPickItemFromGallery()
        }
    }
    @Published var compositionObjects: [ODCompositionObject] = []
    @Published var isAlertShown: Bool = false
    var assembledCompositionImage: UIImage?
    
    // MARK: Initializers
    override init() {
        super.init()
        prepareCanvas()
        assembleComposition()
    }
    
    // MARK: Internal
    private func prepareCanvas() {
        guard compositionObjects.first?.content.type != .canvas else {
            return
        }
        
        let canvasObject = ODCanvas(
            size: CGSize(width: 10, height: 10),
            backgroundColor: .white
        )
        let canvasCompositionObject = ODCompositionObject(
            content: .canvas(canvasObject),
            layerIndex: 0
        )
        compositionObjects.append(canvasCompositionObject)
        compositionObjects.sort(by: { $0.layerIndex < $1.layerIndex })
    }
    
    func exportData() {
        guard
            let imageForExport = assembledCompositionImage
        else {
            isAlertShown = true
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageForExport, self, #selector(exportCompletion), nil)
    }
    
    @objc private func exportCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        isAlertShown = (error != nil)
    }
    
    private func addImageToComposition() {
        Task {
            guard
                let data = try? await lastPickedItem?.loadTransferable(type: Data.self),
                let image = UIImage(data: data)
            else {
                return
            }
            
            let imageObject = ODImage(image: image)
            let imageCompositionObject = ODCompositionObject(
                content: .image(imageObject),
                layerIndex: compositionObjects.count
            )
            resizeCanvasIfNeeded(toFit: imageObject)
            compositionObjects.append(imageCompositionObject)
            assembleComposition()
        }
    }
    
    private func resizeCanvasIfNeeded(toFit imageObject: ODImage) {
        guard
            case .canvas(let canvasObject) = compositionObjects.first?.content,
            !compositionObjects.contains(where: { $0.content.type == .image })
        else {
            return
        }
        
        let expandHeight = canvasObject.size.height < imageObject.image.size.height
        let expandWidth = canvasObject.size.width < imageObject.image.size.width
        
        if expandHeight || expandWidth {
            var expandedCanvasObject = canvasObject
            expandedCanvasObject.size = imageObject.image.size
            compositionObjects[0].content = .canvas(expandedCanvasObject)
        }
    }
    
    private func assembleComposition() {
        guard case .canvas(let canvasObject) = compositionObjects.first?.content else {
            assertionFailure("Canvas not found!")
            return
        }
        
        let canvasSize = canvasObject.size
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        
        assembledCompositionImage = renderer.image { context in
            for compositionObject in compositionObjects {
                switch compositionObject.content {
                case .canvas(let canvasObject):
                    apply(object: canvasObject, to: context, with: canvasSize)
                case .image(let imageObject):
                    apply(object: imageObject, to: context, with: canvasSize)
                }
            }
        }
    }
    
    private func apply(object: ODCanvas, to context: UIGraphicsImageRendererContext, with size: CGSize) {
        context.cgContext.setFillColor(object.backgroundColor.cgColor)
        context.fill(.init(origin: .zero, size: size))
    }
    
    private func apply(object: ODImage, to context: UIGraphicsImageRendererContext, with size: CGSize) {
        guard let cgImage = object.image.cgImage else {
            return
        }
        
        let offsetX = (size.width - object.image.size.width) / 2
        let offsetY = (size.height - object.image.size.height) / 2
        context.cgContext.draw(
            cgImage,
            in: CGRect(
                origin: .init(x: offsetX, y: offsetY),
                size: size
            )
        )
    }
}

// MARK: - User Interactivity
extension MainPageViewModel {
    private func didPickItemFromGallery() {
        addImageToComposition()
    }
}
