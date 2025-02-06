//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Anastasiia on 01.02.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    
    static let shared = ProfileLogoutService()
    private init() {}
    var oAuth2TokenStorage = OAuth2TokenStorage.shared
    func logout() {
        
        ProfileService.shared.deletProfil()
        ProfileImageService.shared.deleteAvatar()
        ImagesListService.shared.deletImagesList()
        oAuth2TokenStorage.removeToken()
        
        cleanCookies()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

