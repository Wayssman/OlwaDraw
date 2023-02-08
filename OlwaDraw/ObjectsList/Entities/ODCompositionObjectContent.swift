//
//  ODCompositionObjectContent.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 08.02.2023.
//

import Foundation

enum ODCompositionObjectContent {
    case canvas(ODCanvas)
    case image(ODImage)
    
    var type: ODCompositionObjectType {
        switch self {
        case .canvas:
            return .canvas
        case .image:
            return .image
        }
    }
}
