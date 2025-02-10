
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Anastasiia on 08.01.2025.


import Foundation

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    static let shared = ProfileImageService()
    private init() {}
    
    private(set) var avatarURL: String?
    private var currentTask: URLSessionDataTask?
    
    struct UserResult: Codable {
        let profile_image: ProfileImage
    }
    
    struct ProfileImage: Codable {
        let small: String
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        currentTask?.cancel()
        
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NSError(domain: "ProfileImageService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
            return
        }
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            completion(.failure(NSError(domain: "ProfileImageService", code: 500, userInfo: [:])))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let currentTask = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let data):
                self?.avatarURL = data.profile_image.small
                DispatchQueue.main.async {
                    completion(.success(data.profile_image.small))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": data.profile_image.small])
                }
            case .failure(let error):
                print("[ProfileImageService]: Ошибка - \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        currentTask.resume()
    }
    
    func deleteAvatar() {
        avatarURL = nil
    }
}

