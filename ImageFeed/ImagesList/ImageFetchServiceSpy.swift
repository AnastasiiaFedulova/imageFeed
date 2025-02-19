//
//  ImageFetchServiceSpy.swift
//  ImageFeed
//
//  Created by Anastasiia on 17.02.2025.
//

import Foundation

final class ImageFetchServiceSpy: ImageFetchServiceProtocole  {
    var viewPresenter: ImagesListViewControllerProtocol?
    
    
    var fetchImagesCalled: Bool = false
    
    func fetchImages() {
        fetchImagesCalled = true
    }
}
