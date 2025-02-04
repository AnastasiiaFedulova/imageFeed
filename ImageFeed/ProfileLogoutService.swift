//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Anastasiia on 01.02.2025.
//

import Foundation
// Обязательный импорт
import WebKit

var oAuth2TokenStorage = OAuth2TokenStorage()

final class ProfileLogoutService {
    
    static let shared = ProfileLogoutService()
    private init() {}

   func logout() {

    ProfileService.shared.deletProfil()
    ProfileImageService.shared.deleteAvatar()
    ImagesListService.shared.deletImagesList()
    oAuth2TokenStorage.removeToken()

    cleanCookies()
   }

   private func cleanCookies() {
      // Очищаем все куки из хранилища
      HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      // Запрашиваем все данные из локального хранилища
      WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         // Массив полученных записей удаляем из хранилища
         records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
      }
   }
}
    
