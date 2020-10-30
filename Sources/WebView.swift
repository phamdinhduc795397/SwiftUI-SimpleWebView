//
//  WebView.swift
//  SimpleWebView
//
//  Created by DucPD on 2020/10/29.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias ActionHandler = ((_ navigationAction: WebView.NavigationAction) -> Void)
    
    enum NavigationAction {
        //Mandatory
        case decidePolicy(WKNavigationAction, (WKNavigationActionPolicy) -> Void)
        case didRecieveAuthChallange(URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
        
        //Optional
        case didStartProvisional(WKNavigation)
        case didReceiveServerRedirectForProvisional(WKNavigation)
        case didCommit(WKNavigation)
        case didFinish(WKNavigation)
        case didFailProvisional(WKNavigation, Error)
        case didFail(WKNavigation, Error)
    }

    private var actionHandler: ActionHandler

    let uRLRequest: Binding<URLRequest?>
    
    init(uRLRequest: Binding<URLRequest?>, actionHandler: @escaping ActionHandler) {
        self.uRLRequest = uRLRequest
        self.actionHandler = actionHandler
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        if let request = uRLRequest.wrappedValue {
            view.load(request)
        }
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let request = uRLRequest.wrappedValue {
            uiView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(action: actionHandler)
    }

    final class Coordinator: NSObject {
        let action: ActionHandler
        init(action: @escaping ActionHandler) {
            self.action = action
        }
    }
    
}

extension WebView.Coordinator: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        action(.decidePolicy(navigationAction, decisionHandler))
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        action(.didStartProvisional(navigation))
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation) {
        action(.didReceiveServerRedirectForProvisional(navigation))

    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: Error) {
        action(.didFailProvisional(navigation, error))
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation) {
        action(.didCommit(navigation))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        action(.didFinish(navigation))
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: Error) {
        action(.didFail(navigation, error))
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        action(.didRecieveAuthChallange(challenge, completionHandler))
    }
}
