# NetworkManager.swift

- It conforms to `ObservableObject`
- Use `@Published` for data

```swift
import Foundation

class NetworkManager: ObservableObject {
    
    @Published var posts = [Post]()
    
    func fetchData() {
        if let url = URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(Results.self, from: safeData)
                            DispatchQueue.main.async {
                                self.posts = results.hits
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}
```

# ContentView.swift

- Mark Object which conforms to `ObservableObject` with  `@ObservedObject`
- Here, `onAppear()` is the same thing as `viewDidLoad()` on UIKit

```swift
import SwiftUI

struct ContentView: View {
    
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView {
            List(networkManager.posts) { post in
                HStack {
                    Text(String(post.points))
                    Text(post.title)
                }
            }
            .navigationTitle("H4X0OR NEWS")
        }
        // viewDidLoad() on SwiftUI
        .onAppear(perform: {
            self.networkManager.fetchData()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

# Model

```swift
import Foundation

struct Results: Decodable {
    let hits: [Post]
}

/*
 
Identifiable Protocol
=> Recognize the order of post objects based on `id`
=> If any object than conforms to `Indentifiable` doesn't have property `id` it will throw an error
 
 */

struct Post: Decodable, Identifiable {
    var id: String {
        return objectID
    }
    let objectID: String
    let points: Int
    let title: String
    let url: String?
}
```

# Make UIKit Component

- When you create a file, create it with `SwiftUI View`

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a7a6de64-1457-43b8-bce0-206987e13ebf/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a7a6de64-1457-43b8-bce0-206987e13ebf/Untitled.png)

- WebView.swift

```swift
import Foundation
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    
    let urlString: String?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let safeString = urlString {
            if let url = URL(string: safeString) {
                let request = URLRequest(url: url)
                uiView.load(request)
            }
        }
    }
    
}
```

- DetailView

```swift
import SwiftUI
import WebKit

struct DetailView: View {
    
    //다른 화면에서 넘어온 값
    let url: String?
    
    var body: some View {
        WebView(urlString: url)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: "https://www.google.com")
    }
}
```

# Go to another screen

- `NavigationLink`

```swift
var body: some View {
        NavigationView {
            List(networkManager.posts) { post in
                //NavigationLink, 화면 전환을 가능하게 한다.
                NavigationLink(destination: DetailView(url: post.url), label: {
                    HStack {
                        Text(String(post.points))
                        Text(post.title)
                    }
                })
            }
            .navigationTitle("H4X0OR NEWS")
        }
        // viewDidLoad() on SwiftUI
        .onAppear(perform: {
            self.networkManager.fetchData()
        })
    }
```

# Entire Project

- NetworkManager.swift

```swift
import Foundation

class NetworkManager: ObservableObject {
    
    @Published var posts = [Post]()
    
    func fetchData() {
        if let url = URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(Results.self, from: safeData)
                            DispatchQueue.main.async {
                                self.posts = results.hits
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}
```

- PostData.swift

```swift
import Foundation

struct Results: Decodable {
    let hits: [Post]
}

/*
 
Identifiable Protocol
=> Recognize the order of post objects based on `id`
=> If any object than conforms to `Indentifiable` doesn't have property `id` it will throw an error
 
 */

struct Post: Decodable, Identifiable {
    var id: String {
        return objectID
    }
    let objectID: String
    let points: Int
    let title: String
    let url: String?
}
```

- ContentView.swift

```swift
import SwiftUI

struct ContentView: View {
    
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView {
            List(networkManager.posts) { post in
                //NavigationLink, 화면 전환을 가능하게 한다.
                NavigationLink(destination: DetailView(url: post.url), label: {
                    HStack {
                        Text(String(post.points))
                        Text(post.title)
                    }
                })
            }
            .navigationTitle("H4X0OR NEWS")
        }
        // viewDidLoad() on SwiftUI
        .onAppear(perform: {
            self.networkManager.fetchData()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

- WebView.swift

```swift
import Foundation
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    
    let urlString: String?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let safeString = urlString {
            if let url = URL(string: safeString) {
                let request = URLRequest(url: url)
                uiView.load(request)
            }
        }
    }
    
}
```

- DetailView.swift (it uses `WebView Component`)

```swift
import SwiftUI
import WebKit

struct DetailView: View {
    
    //다른 화면에서 넘어온 값
    let url: String?
    
    var body: some View {
        WebView(urlString: url)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: "https://www.google.com")
    }
}
```