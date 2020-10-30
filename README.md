# SwiftUI-SimpleWebView

A SwiftUI component that you can use wherever like WKWebView.

Usage: 

```swift
import SwiftUI
import WebView

struct ContentView: View {
    var uRLRequest = URLRequest(url: URL(string: "https://www.google.com/")!)
    
    var body: some View {
        WebView(uRLRequest: .constant(uRLRequest)) { action in
            handleAction(action)
        }
    }
    
    private func handleAction(_ action: WebView.NavigationAction) {
        switch action {
        case .decidePolicy(_, let handlerAction):
            handlerAction(.allow)
        case .didRecieveAuthChallange(_, let completionHandler):
            completionHandler(.performDefaultHandling, nil)
        case .didFail(_, let error):
            debugPrint(error)
        default:
            break
        }
    }
}
```
