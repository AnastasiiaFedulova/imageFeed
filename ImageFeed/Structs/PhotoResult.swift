//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Anastasiia on 06.02.2025.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let created_at: String?
    let updated_at: String?
    let width: Int
    let height: Int
    let color: String?
    let blur_hash: String?
    let likes: Int
    let liked_by_user: Bool
    let description: String?
    let urls: UrlsResult
}
