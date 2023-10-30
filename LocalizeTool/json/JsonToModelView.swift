//
//  JsonToModelView.swift
//  LocalizeTool
//
//  Created by aimo on 2023/10/18.
//

import Foundation
import SwiftUI

struct JsonToModelView: View {
    @State private var text: String = ""
    @State private var modelStr: String = ""
    var body: some View {
        GeometryReader { geo in
                   HStack {
                       TextEditor(text: $text)
                           .font(.title3)
                           .frame(height: geo.size.height)
                        
                       Button("转换") {
                           modelStr = generateModel(from: text) ?? ""
                       }
                       
                       TextEditor(text: $modelStr)
                           .font(.title3)
                           .frame(height: geo.size.height)
                   }
               }
    }
}
