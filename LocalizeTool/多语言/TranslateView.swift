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
    @State var orgContents : [String]
    @State private var contents : [String]
    @State private var text = "去重"
    var body: some View {
        WebView(language: language, contents: contents)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(text) {
                        if self.text == "去重" {
                            self.text = "还原"
                            contents = orgContents.duplicate()
                        } else {
                            self.text = "去重"
                            contents = orgContents
                        }
                    }
                }
            }
    }
    
    init(language: String, orgContents: [String]) {
        self.language = language
        self.orgContents = orgContents
        self.contents = orgContents
    }
}

public extension Array where Element: Equatable {
   
   /// 去除数组重复元素
   /// - Returns: 去除数组重复元素后的数组
   func duplicate() -> Array {
      return self.enumerated().filter { (index,value) -> Bool in
           return self.firstIndex(of: value) == index
       }.map { (_, value) in
           value
       }
   }
}


struct WebView: NSViewRepresentable {
    var language: String
    var contents: [String]
    var content : String {
        get {
            var localeContent = ""
            contents.forEach { s in
                localeContent = localeContent + s
            }
            return localeContent
        }
    }
    
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

