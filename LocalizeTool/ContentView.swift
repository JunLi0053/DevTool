//
//  ContentView.swift
//  LocalizeTool
//
//  Created by Jun on 2023/9/10.
//

import SwiftUI



struct ContentView: View {
    @StateObject var appVM = AppVM()
    private let titles = ["多语言", "json"]
    var body: some View {
        NavigationView {
            Sidebar()
            NavView()
            NavView()
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.left")
                })
            }
        }
    }
    
    func toggleSidebar() {
      #if os(macOS)
      NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
      #endif
    }

}

struct NavView: View {
    var body: some View {
        ScrollView {
            
        }
        .frame(minWidth: 350)
    }
}




