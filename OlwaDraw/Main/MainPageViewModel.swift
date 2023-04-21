//
//  MainPageViewModel.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 24.01.2023.
//

import SwiftUI
import PhotosUI
import ImageIO

@MainActor class MainPageViewModel: NSObject, ObservableObject {
    // MARK: Properties
    @Published var compositionObjects: [ODCompositionObject] = []
    @Published var isAlertShown: Bool = false
    var assembledCompositionImage: UIImage?
    
    // MARK: Initializers
    override init() {
        super.init()
        prepareCanvas()
        assembleComposition()
    }
    
    // MARK: Interface
    func addImageToComposition(imageUrl: URL) {
        guard let image = downsample(imageAt: imageUrl, to: .init(width: 720, height: 720), scale: 1) else {
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
    
    // MARK: Internal
    private func prepareCanvas() {
        guard compositionObjects.first?.content.type != .canvas else {
            return
        }
        
        let canvasObject = ODCanvas(
            size: CGSize(width: 50, height: 50),
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
        
        
        PHPhotoLibrary.shared().performChanges {
            _ = PHAssetChangeRequest.creationRequestForAsset(from: imageForExport)
        }
    }
    
    @objc private func exportCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        isAlertShown = (error != nil)
    }
    
    private func downsample(
        imageAt imageUrl: URL,
        to pointSize: CGSize,
        scale: CGFloat
    ) -> UIImage? {
        // Calculatge the desire dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        
        // Perform downsampling
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        
        guard
            let imageSource = CGImageSourceCreateWithURL(imageUrl as NSURL, imageSourceOptions),
            let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)
        else {
            return nil
        }
        
        // Return the downsampled image as UIImage
        return UIImage(cgImage: downsampledImage)
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
            let width = min(imageObject.image.size.width, 4032)
            let height = min(imageObject.image.size.height, 4032)
            expandedCanvasObject.size = CGSize(width: width, height: height)
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
        let size = object.image.size
        object.image.draw(in: CGRect(origin: .zero, size: size))
    }
}
