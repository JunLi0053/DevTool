//
//  LocateView.swift
//  LocaleTool
//
//  Created by Jun on 2023/9/9.
//

import Foundation
import SwiftUI
import WebKit

struct LocateView: View {
    let content : String
    var body: some View {
//        GeometryReader {_ in
//            ScrollView {
//                Text(content)
//                    .textSelection(.enabled)
//            }
//        }.padding()
     
        WebView(text: content)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WebView: NSViewRepresentable {
    var text: String
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.configuration.mediaTypesRequiringUserActionForPlayback = .audio
        if #available(macOS 14.0, *) {
            webView.configuration.allowsInlinePredictions = true
        } else {
            // Fallback on earlier versions
        }
        webView.loadHTMLString("<p>\(text)</p>", baseURL: nil)
        webView.loadHTMLString("<body style=\"background-color:black;color:white;\"><p>\(text)</p></body>", baseURL: nil)
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.loadHTMLString("<p>\(text)</p>", baseURL: nil)
        nsView.loadHTMLString("<body style=\"background-color:black;color:white;\"><p>\(text)</p></body>", baseURL: nil)
    }
    
}
