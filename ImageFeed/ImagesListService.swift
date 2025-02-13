//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Anastasiia on 23.01.2025.
//

import Foundation

final class ImagesListService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var task: URLSessionDataTask?
    
    private(set) var photos: [Photo] = []
    private let isoFormatter = ISO8601DateFormatter()
    static let shared = ImagesListService()
    private init() {}
    
    static var lastLoadedPage: Int = 0
    
    private func getPage() -> Int {
        ImagesListService.lastLoadedPage += 1
        return ImagesListService.lastLoadedPage
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        if isLike == false {
            unlikePhoto(photoId: photoId, completion: completion)
        } else {
            likePhoto(photoId: photoId, completion: completion)
        }
    }
    
    func likePhoto(photoId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            return
        }
        
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NSError(domain: "ImagesListService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[ProfileService]: Ошибка - \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            self.updatePhoto(photoId: photoId)
            completion(.success(()))
        }
        task.resume()
    }
    func updatePhoto(photoId: String) -> Void {
        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
            
            let photo = self.photos[index]
            let newPhoto = Photo(
                id: photo.id,
                size: photo.size,
                createdAt: photo.createdAt,
                welcomeDescription: photo.welcomeDescription,
                thumbImageURL: photo.thumbImageURL,
                largeImageURL: photo.largeImageURL,
                isLiked: !photo.isLiked
            )
            
            self.photos[index] = newPhoto
        }
    }
    
    func unlikePhoto(photoId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            return
        }
        
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NSError(domain: "ImagesListService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[ProfileService]: Ошибка - \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            self.updatePhoto(photoId: photoId)
            completion(.success(()))
        }
        task.resume()
    }
    
    func fetchPhotosNextPage( completion: @escaping (Result<[Photo], Error>) -> Void) {
        task?.cancel()
        
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(getPage())") else {
            return
        }
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NSError(domain: "ImagesListService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            defer { self?.task = nil }
            switch result {
            case .success(let data):
                for photoResult in data {
                    var date: Date?
                    
                    if let photoCreatedDate = photoResult.created_at {
                        date = self?.isoFormatter.date(from: photoCreatedDate)
                    }
                    
                    let photo = Photo(id: photoResult.id, size: CGSize(width: Double(photoResult.width), height: Double(photoResult.height)), createdAt: date, welcomeDescription: photoResult.description, thumbImageURL: photoResult.urls.thumb, largeImageURL: photoResult.urls.full, isLiked: photoResult.liked_by_user
                    )
                    self?.photos.append(photo)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                }
                
                DispatchQueue.main.async {
                    completion(.success(self?.photos ?? []))
                }
            case .failure(let error):
                print("[ProfileService]: Ошибка - \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    func deletImagesList() {
        photos = []
    }
}

