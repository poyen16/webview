//
//  SwiftUIView.swift
//  webview
//
//  Created by boncor chen on 2022/7/7.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable{
    var url : URL
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
    
        
}



