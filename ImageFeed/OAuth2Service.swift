//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Anastasiia on 16.12.2024.
//

import Foundation
import SwiftKeychainWrapper

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case createdAt = "created_at"
    }
}

final class OAuth2TokenStorage {
    private let tokenKey = "Bearer Token"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            guard let newValue = newValue else {
                return
            }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            guard isSuccess else {
                print("oib")
                return
            }
        }
    }
    
    func removeToken() {
        KeychainWrapper.standard.removeObject(forKey: tokenKey)
    }
}

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    private let tokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print ("Ошибка: не удалось создать baseURL")
            return nil
        }
        guard let url = URL(string: "/oauth/token"
                            + "?client_id=\(Constants.accessKey)"
                            + "&client_secret=\(Constants.secretKey)"
                            + "&redirect_uri=\(Constants.redirectURI)"
                            + "&code=\(code)"
                            + "&grant_type=authorization_code",
                            relativeTo: baseURL) else {
            assertionFailure("Не удалось создать URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let data):
                self?.tokenStorage.token = data.accessToken
                completion(.success(data.accessToken))
            case .failure(let error):
                print("[OAuth2Service]: Ошибка - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
}
