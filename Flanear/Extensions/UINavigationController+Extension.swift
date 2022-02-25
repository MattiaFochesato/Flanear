//
//  UINavigationController+Extension.swift
//  Flanear
//
//  Created by Mattia Fochesato on 23/02/22.
//

import Foundation
import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.font : UIFont.systemFont(ofSize: 34, weight: .black)]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
