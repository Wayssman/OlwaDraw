//
//  View+Extensions.swift
//  OlwaDraw
//
//  Created by Желанов Александр Валентинович on 24.01.2023.
//

import SwiftUI

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
