//
//  JsonToModelView.swift
//  LocalizeTool
//
//  Created by aimo on 2023/10/18.
//

import Foundation
import SwiftUI

struct JsonToModelView: View {
    @StateObject var appVM = AppVM()
    @State private var text: String = ""
    @State private var modelStr: String = ""
    var body: some View {
        HStack {
            TextEditor(text: $text)
                .font(.title3)
            NavigationLink {
                JsonToModelContentView(content: text)
            } label: {
                Text("转换")
            }
            Spacer().frame(width: 5)
        }
        
    }
}


struct JsonToModelContentView: View {
    var content = ""
    @StateObject var appVM = AppVM()
    var body: some View {
        GeometryReader { geo in
            TextEditor(text: $appVM.jsonModelStirng)
                .font(.title3)
                .frame(height: geo.size.height)
        }.onAppear(perform: {
            appVM.jsonModelStirng = generateModel(from: content) ?? ""
        })
    }
}
