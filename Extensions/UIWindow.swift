//
//  UIWindow.swift
//  iSearcher
//
//  Created by Engin KUK on 23.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import UIKit

extension UIWindow {
    static var isLandscape: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation
                .isLandscape ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
}
