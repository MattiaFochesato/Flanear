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
        
        /*let standardAppearance = UINavigationBarAppearance()
         standardAppearance.backgroundColor = .white
         
         let compactAppearance = UINavigationBarAppearance()
         compactAppearance.backgroundColor = .white
         
         let scrollEdgeAppearance = UINavigationBarAppearance()
         scrollEdgeAppearance.backgroundColor = .white
         
         navigationBar.standardAppearance = standardAppearance
         navigationBar.compactAppearance = compactAppearance
         navigationBar.scrollEdgeAppearance = scrollEdgeAppearance*/
        
        var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle) /// the default large title font
        titleFont = UIFont(
            descriptor:
                titleFont.fontDescriptor
                .withDesign(.rounded)? /// make rounded
                .withSymbolicTraits(.traitBold) /// make bold
            ??
            titleFont.fontDescriptor, /// return the normal title if customization failed
            size: titleFont.pointSize
        )
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.font : titleFont]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        
        
    }
}
