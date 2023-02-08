//
//  ObjectsListView.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 06.02.2023.
//

import SwiftUI

struct ObjectsListView: View {
    @StateObject var viewModel: MainPageViewModel
    
    var body: some View {
        List(viewModel.compositionObjects.reversed()) {
            compositionObject in
            
            switch compositionObject.content {
            case .canvas(let canvas):
                let text = "\(canvas.size.width)x\(canvas.size.height)"
                Text(text)
            case .image(let image):
                Text("\(compositionObject.layerIndex)")
            }
        }
    }
}

struct ObjectsListView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectsListView(viewModel: MainPageViewModel())
    }
}
