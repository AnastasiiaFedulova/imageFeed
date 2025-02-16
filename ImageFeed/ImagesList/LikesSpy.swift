//
//  LikesSpy.swift
//  ImageFeed
//
//  Created by Anastasiia on 16.02.2025.
//

import Foundation


final class LikesSpy: LikesProtocol {
    func tapLike(for photo: Photo, completion: @escaping (Result<Bool, Error>) -> Void) {
        tapLikesCalled = true
        
        completion(.success(true))
    }
    
    var tapLikesCalled: Bool = false
    
}
