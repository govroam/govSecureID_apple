//
//  TiqrViewController.swift
//  SharedLibrary
//
//  Created by Yasser Farahi on 14/03/2025.
//

import SwiftUI
import Tiqr
import TiqrCore
import Theme

internal struct TiqrViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller: UIViewController = Tiqr.shared.startWithOptions(options: nil, theme: Theme())
        controller.view.backgroundColor = Theme().primaryColor
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
