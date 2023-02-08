//
//  ODCompositionObject.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 06.02.2023.
//

import Foundation

struct ODCompositionObject: Identifiable {
    let id = UUID()
    var content: ODCompositionObjectContent
    var layerIndex: Int
}

