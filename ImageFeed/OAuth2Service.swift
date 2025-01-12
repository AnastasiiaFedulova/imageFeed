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

//final class OAuth2TokenStorage {
//    private let tokenKey = "Bearer Token"
//    
//    var token: String? {
//        get {
//            return UserDefaults.standard.string(forKey: tokenKey)
//        }
//        set {
//            UserDefaults.standard.setValue(newValue, forKey: tokenKey)
//        }
//    }
//}
    
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
        if task != nil {
            if lastCode != code {
                // Отменить текущий запрос и начать новый
                task?.cancel()
            } else {
                // Если код не совпадает, ничего не делаем
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NSError(domain: "OAuth2Service", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ошибка создания запроса"])))
            return
        }

//        let task = URLSession.shared.data(for: request) { [weak self] result in
//            switch result {
//            case .success(let data):
//                do {
//                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
//                    self?.tokenStorage.token = tokenResponse.accessToken
//                    completion(.success(tokenResponse.accessToken))
//                } catch {
//                    print("Ошибка декодирования ответа: \(error)")
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                print("Ошибка сети или запроса: \(error)")
//                completion(.failure(error))
//            }
//        }
        
        
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

