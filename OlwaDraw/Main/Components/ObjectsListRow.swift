//
//  ObjectsListRow.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 08.02.2023.
//

import SwiftUI

struct ObjectsListRow: View {
    var image: UIImage?
    var color: UIColor = .white
    var name: String
    var isDraggable: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .center) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(.init(1), contentMode: .fit)
            .background(Color(color))
            .cornerRadius(radius: 8, corners: .allCorners)
            .overlay(
                CornerRadiusShape(radius: 8, corners: .allCorners)
                    .stroke(Color.gray.opacity(0.7), lineWidth: 1)
            )
            .padding(.leading, 20)
            .padding(.trailing, 10)
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                HStack(alignment: .center) {
                    Text(name)
                        .foregroundColor(.black)
                    Spacer()
                    if isDraggable {
                        Image(systemName: "rectangle.grid.3x2.fill")
                            .resizable()
                            .rotationEffect(.degrees(90))
                            .frame(width: 16, height: 10)
                            .foregroundColor(.gray.opacity(0.7))
                            .padding(.trailing, 20)
                    }
                }
                
                Spacer()
                
                Rectangle()
                    .fill(.gray.opacity(0.7))
                    .frame(height: 1)
            }
        }
        .frame(maxHeight: 60)
    }
}

struct ObjectsListRow_Previews: PreviewProvider {
    static var previews: some View {
        ObjectsListRow(image: .init(systemName: "square.and.arrow.up"), name: "Background", isDraggable: true)
    }
}
