//
//  ODCompositionObject.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 06.02.2023.
//

import Foundation

struct ODCompositionObject: Identifiable, Hashable {
    static func == (lhs: ODCompositionObject, rhs: ODCompositionObject) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id = UUID()
    var content: ODCompositionObjectContent
    var layerIndex: Int
}

