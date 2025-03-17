//
//  File.swift
//  SharedLibrary
//
//  Created by Yasser Farahi on 14/03/2025.
//

import SwiftUI
import Theme

public struct MainView: View {
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color(Theme().primaryColor).ignoresSafeArea(.all)
            TiqrViewController()
        }
    }
    
}
