//
//  Likes.swift
//  ImageFeed
//
//  Created by Anastasiia on 14.02.2025.
//

import Foundation

 protocol LikesProtocol {
     func tapLike(for photo: Photo, completion: @escaping (Result<Bool, Error>) -> Void)
}

final class Likes: LikesProtocol {
    
    let imageListService = ImagesListService.shared
    
    func tapLike(for photo: Photo, completion: @escaping (Result<Bool, Error>) -> Void) {
        let newLike = !photo.isLiked
        imageListService.changeLike(photoId: photo.id, isLike: newLike) { result in
            switch result {
            case .success:
                completion(.success(newLike))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
