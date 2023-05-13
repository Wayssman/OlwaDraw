//
//  ObjectsListDropViewDelegate.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 12.05.2023.
//

import SwiftUI

struct ObjectsListDropViewDelegate: DropDelegate {
    let destinationItem: ODCompositionObject
    @ObservedObject var viewModel: MainPageViewModel
    @Binding var draggedItem: ODCompositionObject?

    func dropEntered(info: DropInfo) {
        guard
            let draggedItem = draggedItem,
            let fromIndex = viewModel.compositionObjects.firstIndex(of: draggedItem),
            let toIndex = viewModel.compositionObjects.firstIndex(of: destinationItem),
            fromIndex != toIndex
        else {
            return
        }
        
        withAnimation {
            viewModel.compositionObjects.move(
                fromOffsets: IndexSet(integer: fromIndex),
                toOffset: (toIndex > fromIndex) ? toIndex + 1 : toIndex
            )
        }
        swap(&viewModel.compositionObjects[fromIndex].layerIndex, &viewModel.compositionObjects[toIndex].layerIndex)
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
}
