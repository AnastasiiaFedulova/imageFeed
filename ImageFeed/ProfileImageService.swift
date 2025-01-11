
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

        guard let token = OAuth2TokenStorage().token else {
            completion(.failure(NSError(domain: "ProfileImageService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
            return
        }

        var request = URLRequest(url: URL(string: "https://api.unsplash.com/users/\(username)")!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        currentTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "ProfileImageService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                }
                return
            }

            do {
                let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                self?.avatarURL = userResult.profile_image.small
                DispatchQueue.main.async {
                    completion(.success(userResult.profile_image.small))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": userResult.profile_image.small])
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        currentTask?.resume()
    }
}

