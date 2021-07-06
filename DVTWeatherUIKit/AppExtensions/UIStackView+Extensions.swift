//
//  UIStackView+Extensions.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ collection: [UIView]) {
        for item in collection {
            self.addArrangedSubview(item)
        }
    }
}
