//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Anastasiia on 06.02.2025.
//

import Foundation

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
