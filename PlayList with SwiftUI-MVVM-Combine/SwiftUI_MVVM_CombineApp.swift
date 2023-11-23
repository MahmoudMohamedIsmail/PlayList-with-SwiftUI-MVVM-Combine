//
//  SwiftUI_MVVM_CombineApp.swift
//  SwiftUI-MVVM-Combine
//
//  Created by Mahmoud Ismail on 22/11/2023.
//

import SwiftUI

@main
struct SwiftUI_MVVM_CombineApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
    
}
