//
//  TupButton.swift
//  ImageFeed
//
//  Created by Anastasiia on 15.02.2025.
//

import UIKit

final class TupButton {
    
    private let profileLogoutService = ProfileLogoutService.shared
    
    func tapButton() -> UIAlertController {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            self.profileLogoutService.logout()
            
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            let authViewController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "AuthViewController")
            window.rootViewController = authViewController
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: nil)
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        return alert
    }

}
