//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Anastasiia on 07.01.2025.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private init() {}
    
    private(set) var profile: Profile?
    private var task: URLSessionDataTask?
    
    struct ProfileResult: Codable {
        let username: String
        let first_name: String?
        let last_name: String?
        let bio: String?
                
    }
    struct Profile {
        let username: String
        let name: String?
        let loginName: String?
        let bio: String?
        
    }
    
    private func createRequest(endpoint: String, token: String) -> URLRequest? {
            guard let url = URL(string: "https://api.unsplash.com/\(endpoint)") else {
                return nil
            }
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"

            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            return request
        }
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard task == nil else { return }
            
        guard let request = createRequest(endpoint: "me", token: token) else {
            return
        }
        
        
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            defer { self?.task = nil }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                }
                return
            }
            
            do {
                let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                let profile = Profile(
                    username: profileResult.username,
                    name: "\(profileResult.first_name ?? "") \(profileResult.last_name ?? "").trimmingCharacters(in: .whitespaces)",
                    loginName: "@\(profileResult.username)",
                    bio: profileResult.bio
                )
                self?.profile = profile
                DispatchQueue.main.async {
                    completion(.success(profile))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task?.resume()
    }
}

