//
//  ContentView.swift
//  HackerNews_SwiftUI
//
//  Created by paigeshin on 2021/02/11.
//

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


