//
//  ContentView.swift
//  LocalizeTool
//
//  Created by Jun on 2023/9/10.
//

import SwiftUI



struct ContentView: View {
    @State private var selectedMenuItem: String? = nil
    @State var languages = [String: String]()
    private let titles = ["多语言", "json"]
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(titles), id: \.self){title in
                    NavigationLink(destination: destinationView(title), tag: title, selection: $selectedMenuItem) {
                        Text(title)
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
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
    
    @ViewBuilder
    func destinationView(_ menuItem: String) -> some View {
        if menuItem == "多语言" {
            // 返回右侧视图1
            LanguageView(languages: $languages)
            
        } else if menuItem == "json" {
            // 返回右侧视图2
            JsonToModelView()
        } else if menuItem == "视图3" {
            // 返回右侧视图3
            Text("视图3")
        } else {
            EmptyView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
    
}



