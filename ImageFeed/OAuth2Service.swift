//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Anastasiia on 16.12.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    //let score: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            //case score = "score"
            case createdAt = "created_at"
        }
}

class OAuth2TokenStorage {
    private let tokenKey = "Bearer Token"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: tokenKey)
        }
    }
}
    
class OAuth2Service{
    private let tokenStorage = OAuth2TokenStorage()
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
         let baseURL = URL(string: "https://unsplash.com")!
         let url = URL(
             string: "/oauth/token"
             + "?client_id=\(Constants.accessKey)"         // Используем знак ?, чтобы начать перечисление параметров запроса
             + "&&client_secret=\(Constants.secretKey)"    // Используем &&, чтобы добавить дополнительные параметры
             + "&&redirect_uri=\(Constants.redirectURI)"
             + "&&code=\(code)"
             + "&&grant_type=authorization_code",
             relativeTo: baseURL                           // Опираемся на основной или базовый URL, которые содержат схему и имя хоста
         )!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         return request
     }
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
                completion(.failure(NSError(domain: "OAuth2Service", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ошибка создания запроса"])))
                return
            }

            URLSession.shared.data(for: request) { [weak self] result in
                switch result {
                case .success(let data):
                    do {
                        let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        self?.tokenStorage.token = tokenResponse.accessToken
                        completion(.success(tokenResponse.accessToken))
                    } catch {
                        print("Ошибка декодирования ответа: \(error)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Ошибка сети или запроса: \(error)")
                    completion(.failure(error))
                }
            }.resume()
        }
    }

