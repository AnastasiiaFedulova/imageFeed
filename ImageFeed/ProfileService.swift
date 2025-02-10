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
        
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            defer { self?.task = nil }
            switch result {
            case .success(let data):
                let profile = Profile(
                    username: data.username,
                    name: "\(data.first_name ?? "") \(data.last_name ?? "")",
                    loginName: "@\(data.username)",
                    bio: data.bio
                )
                self?.profile = profile
                DispatchQueue.main.async {
                    completion(.success(profile))
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
    
    func deletProfil() {
        profile = nil
    }
}


