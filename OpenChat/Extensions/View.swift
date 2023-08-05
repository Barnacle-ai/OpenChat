//
//  View.swift
//  OpenChat
//
//  Created by Duncan Anderson on 03/08/2023.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func applyIf<M: View>(condition: Bool, transform: (Self) -> M) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

