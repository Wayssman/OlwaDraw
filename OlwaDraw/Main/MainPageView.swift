//
//  MainPageView.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 24.01.2023.
//

import SwiftUI
import PhotosUI

struct MainPageView: View {
    @StateObject var viewModel = MainPageViewModel()
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var showingImagePicker = false
    @State private var objectsListOffset = CGFloat(0)
    @State private var headerWidth = CGFloat(0)
    private var minHeight: CGFloat = 200
    private var maxHeight: CGFloat {
        guard let image = viewModel.assembledCompositionImage else {
            return minHeight
        }
        
        let ratio = image.size.height / image.size.width
        let width = headerWidth
        let height = width * ratio + 15 + 80 - 20
        
        return (height > minHeight && height < 800) ? height: minHeight
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                // Header
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: HeaderFramePreferenceKey.self, value: [geometry.size])
                    
                    VStack {
                        ImageObserverView(
                            image: viewModel.assembledCompositionImage
                        )
                        
                        InstrumentalPanelView(
                            imageButtonTapped: $showingImagePicker
                        )
                        
                        Spacer()
                    }
                    .frame(height: getHeaderHeight())
                }
                .frame(height: minHeight)
                
                // Content
                ObjectsListView(
                    viewModel: viewModel,
                    contentOffset: $objectsListOffset,
                    insideContentOffset: maxHeight - minHeight
                )
                .zIndex(-1)
            }
            .onPreferenceChange(HeaderFramePreferenceKey.self) { headerSize in
                headerWidth = headerSize[0].width
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(viewModel: viewModel)
            }
            .alert(isPresented: $viewModel.isAlertShown) {
                Alert(
                    title: Text("Ошибка"),
                    message: Text("Не удалось экспортировать изображение"),
                    dismissButton: .cancel()
                )
            }
            
            RoundButtonView(systemIconName: "square.and.arrow.up")
                .offset(CGSize(width: -20, height: 0))
                .onTapGesture {
                    viewModel.exportData()
                }
        }
    }
    
    
    func getHeaderHeight() -> CGFloat {
        let offset = objectsListOffset
        
        guard offset > 0 else {
            return maxHeight
        }
        
        if offset < (maxHeight - minHeight) {
            return maxHeight - offset
        }
        return minHeight
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: UIEdgeInsets {
        UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }.compactMap { $0 as? UIWindowScene }.first?.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension EnvironmentValues {
    var safeAreaInsets: UIEdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

struct HeaderFramePreferenceKey: PreferenceKey {
    typealias Value = [CGSize]
    
    static var defaultValue: [CGSize] = []
    
    static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue())
    }
}
