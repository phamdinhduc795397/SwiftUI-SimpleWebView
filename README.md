# SwiftUI-SimpleWebView
A SwiftUI component to use WKWebView

A component that you can use wherever like WKWebView.

Usage: 

```
import SwiftUI
import WebView

struct ContentView: View {
@State var urlRequest: URLRequest?

var body: some View {
    WebView(uRLRequest: $urlRequest) { action in
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
