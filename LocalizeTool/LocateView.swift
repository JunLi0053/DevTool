//
//  LocateView.swift
//  LocaleTool
//
//  Created by Jun on 2023/9/9.
//

import Foundation
import SwiftUI

struct LocateView: View {
    let content : String
    var body: some View {
        GeometryReader {_ in
            ScrollView {
                Text(content)
                    .textSelection(.enabled)
            }
        }.padding()
    }
}
