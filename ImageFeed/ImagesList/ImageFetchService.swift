//
//  ImagesListViewControllerPresenter.swift
//  ImageFeed
//
//  Created by Anastasiia on 17.02.2025.
//

import Foundation

public protocol ImageFetchServiceProtocole {
    func fetchImages()
}

final class ImageFetchService: ImageFetchServiceProtocole {
 
    
    
    private let imageListService = ImagesListService.shared
    private let alertPresenter = AlertPresenter()

    
    func fetchImages() {
        imageListService.fetchPhotosNextPage() { [weak self] result in
            switch result {
            case .success(_):
                return
            case .failure(_):
                let alertModel = AlertModel(title: "Ошибка", message: "Не удалось загрузить изображения.", buttonText: "OK", completion: nil)
                self?.alertPresenter.alert(alertData: alertModel)
            }
        }
    }
}
