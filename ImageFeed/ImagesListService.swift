//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Anastasiia on 23.01.2025.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
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
struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var task: URLSessionDataTask?
    
    private(set) var photos: [Photo] = []
    
    static var lastLoadedPage: Int = 0
    
    func fetchPhotosNextPage() -> Int {

        ImagesListService.lastLoadedPage += 1
        return ImagesListService.lastLoadedPage
    }
        
    func fetchImages( completion: @escaping (Result<[Photo], Error>) -> Void) {
        task?.cancel()
        
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(fetchPhotosNextPage())") else {
            return
        }
        guard let token = OAuth2TokenStorage().token else {
            completion(.failure(NSError(domain: "ImagesListService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let isoFormatter = ISO8601DateFormatter()
    
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            defer { self?.task = nil }
            switch result {
            case .success(let data):
                for photoResult in data {
                    var date: Date? = nil
                    
                    if let date2 = photoResult.created_at {
                        date = isoFormatter.date(from: date2)
                    }
                    
                    let photo = Photo(id: photoResult.id, size: CGSize(width: Double(photoResult.width), height: Double(photoResult.height)), createdAt: date, welcomeDescription: photoResult.description, thumbImageURL: photoResult.urls.thumb, largeImageURL: photoResult.urls.full, isLiked: photoResult.liked_by_user
                    )
                    self?.photos.append(photo)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                }
                
                DispatchQueue.main.async {
                    completion(.success(self!.photos))
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
}
