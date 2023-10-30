//
//  LocateView.swift
//  LocaleTool
//
//  Created by Jun on 2023/9/9.
//

import Foundation
import SwiftUI
import WebKit

struct TranslateView: View {
    let language : String
    let content : String
    var body: some View {
//        GeometryReader {_ in
//            ScrollView {
//                Text(content)
//                    .textSelection(.enabled)
//            }
//        }.padding()
     
        WebView(language: language, content: content)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WebView: NSViewRepresentable {
    var language: String
    var content: String
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.configuration.mediaTypesRequiringUserActionForPlayback = .audio
        webView.loadHTMLString("<body style=\"background-color:black;\"><p style=\"color:green;\">//================\(language)================</p><p style=\"color:white;\">\(content)</p></body>", baseURL: nil)
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.loadHTMLString("<body style=\"background-color:black;\"><p style=\"color:green;\">//================\(language)================</p><p style=\"color:white;\">\(content)</p></body>", baseURL: nil)
    }
}

