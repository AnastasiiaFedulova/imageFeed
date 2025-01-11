//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Anastasiia on 18.12.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"

    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    private let profileService = ProfileService.shared
    private let storage = OAuth2TokenStorage()

    private let profileImageService = ImageFeed.ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = oAuth2TokenStorage.token {
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
        guard let token = storage.token else {
            return
        }
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
     //   UIBlockingProgressHUD.show()
        profileService.fetchProfile(token: token) { [weak self] result in
          //  UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                fetchProfileImageURL(profile.username)
       
               // self.switchToTabBarController()
            case .failure:
                // TODO [Sprint 11] Покажите ошибку получения профиля
                break
            }
        }
    }
    
    func fetchProfileImageURL(_ username: String) {
      //  UIBlockingProgressHUD.show()
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
           // UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.switchToTabBarController()
                break
            case .failure:
                // TODO [Sprint 11] Покажите ошибку получения профиля
                break
            }
        }
    }
  
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(with: code) { [weak self] result in
        }
    }
    
}
