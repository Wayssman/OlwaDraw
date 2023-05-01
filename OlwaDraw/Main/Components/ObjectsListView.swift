//
//  ObjectsListView.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 06.02.2023.
//

import SwiftUI

struct ObjectsListView: View {
    @StateObject var viewModel: MainPageViewModel
    @Binding var contentOffset: CGFloat
    var insideContentOffset: CGFloat
    
    var body: some View {
        GeometryReader { outsideProxy in
            ScrollView(showsIndicators: false) {
                    GeometryReader { insideProxy in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: calculateContentOffset(
                                    fromOutsideProxy: outsideProxy,
                                    insideProxy: insideProxy
                                )
                            )
                    }
                    VStack {
                        ForEach(viewModel.compositionObjects.reversed(), id: \.self) { compositionObject in
                            
                            switch compositionObject.content {
                            case .canvas(let canvas):
                                let text = "\(canvas.size.width)x\(canvas.size.height)"
                                Text(text)
                            case .image(let image):
                                Text("\(compositionObject.layerIndex)")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(.green)
                    .offset(y: insideContentOffset)
                    .padding(.bottom, insideContentOffset)
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.contentOffset = value
            }
        }
    }
    
    private func calculateContentOffset(
        fromOutsideProxy outsideProxy: GeometryProxy,
        insideProxy: GeometryProxy
    ) -> CGFloat {
        return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        return
    }
}

struct ObjectsListView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectsListView(
            viewModel: MainPageViewModel(),
            contentOffset: .constant(0),
            insideContentOffset: 100
        )
    }
}
