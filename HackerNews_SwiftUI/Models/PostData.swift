//
//  PostData.swift
//  HackerNews_SwiftUI
//
//  Created by paigeshin on 2021/02/11.
//

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
