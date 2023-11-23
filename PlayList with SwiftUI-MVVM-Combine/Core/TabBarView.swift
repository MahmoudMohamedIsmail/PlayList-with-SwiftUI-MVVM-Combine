//
//  TabBarView.swift
//  SwiftUI-MVVM-Combine
//
//  Created by Mahmoud Ismail on 22/11/2023.
//

import SwiftUI

struct TabBarView: View {
    private let viewModel = HomeViewModel()
    
    @State private var selectedTab: Tab = .home
    
    enum Tab: String, Identifiable {
        case home
        case search
        case library
        
        var id: String { rawValue }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel)
                .tabItem {
                    let isSelected: Bool = selectedTab == .home
                    Image(isSelected ? "home_fill_icon" : "home_icon")
                    Text("الرئيسية")
                        .foregroundColor(isSelected ? AppColors.primary : AppColors.secondary)
                }
                .tag(Tab.home)
            
            Text("البحث")
                .tabItem {
                    let isSelected: Bool = selectedTab == .search
                    Image(isSelected ? "search_fill_icon" : "search_icon")
                    Text("البحث")
                        .foregroundColor(isSelected ? AppColors.primary : AppColors.secondary)
                }
                .tag(Tab.search)
            
            Text("المكتبة")
                .tabItem {
                    let isSelected: Bool = selectedTab == .library
                    Image(isSelected ? "library_fill_icon" : "library_icon")
                    Text("المكتبة")
                        .foregroundColor(isSelected ? AppColors.primary : AppColors.secondary)
                }
                .tag(Tab.library)
        }
    }
    
}
