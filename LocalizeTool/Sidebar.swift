//
//  Sidebar.swift
//  LocalizeTool
//
//  Created by aimo on 2024/1/5.
//

import Foundation
import SwiftUI

// MARK: - Sidebar
struct Sidebar: View {
    @StateObject var appVM = AppVM()
    var body: some View {
        List {
            Section("新动态") {
                NavigationLink {
                    LanguageView()
                } label: {
                    Text("多语言")
                }
                
                NavigationLink {
                    JsonToModelView()
                } label: {
                    Text("json")
                }
            }

        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 160)

        // end List

        // MARK: - Mine
//        Spacer()
//        Mine()
    }
}
