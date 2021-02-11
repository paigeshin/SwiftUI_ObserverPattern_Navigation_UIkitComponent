//
//  DetailView.swift
//  HackerNews_SwiftUI
//
//  Created by paigeshin on 2021/02/11.
//

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


