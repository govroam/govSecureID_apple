//
//  Theme.swift
//  SharedLibrary
//
//  Created by Yasser Farahi on 14/03/2025.
//

import UIKit
import TiqrCore

public class Theme: TiqrThemeType {
    
    public init() {}
    
    public let primaryColor: UIColor = UIColor(resource: .govRoamOrange)
    public let headerFont: UIFont = .boldSystemFont(ofSize: 20)
    public let bodyBoldFont: UIFont = .boldSystemFont(ofSize: 16)
    public let bodyFont: UIFont = .systemFont(ofSize: 16)
    public let buttonFont: UIFont = .systemFont(ofSize: 16)
    public let buttonTintColor: UIColor = .white
    public let buttonBackgroundColor: UIColor = UIColor(resource: .govRoamOrange)
    public let secondaryButtonTintColor: UIColor = .white
    public let secondaryButtonBackgroundColor: UIColor = .black
    public let aboutIcon: UIImage? = UIImage(resource: .goVconextLogo)
    public let topBarIcon: UIImage? = UIImage(resource: .goVconextLogo)
    public let bottomBarIcon: UIImage? = UIImage(resource: .goVconextLogo)
    
}
