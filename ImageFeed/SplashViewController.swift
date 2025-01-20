//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Anastasiia on 18.12.2024.
//

import UIKit

final class SplashViewController: UIViewController, ViewControllerProtocol {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    private let profileService = ProfileService.shared
    private let storage = OAuth2TokenStorage()
    
    private let profileImageService = ImageFeed.ProfileImageService.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    private var alertPresenter: AlertPresenter?

    
    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "splash_screen_logo")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        alertPresenter = AlertPresenter()
        alertPresenter?.setup(delegate: self)

    }
    
    private func setupUI() {
        view.addSubview(splashImageView)
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        if let token = oAuth2TokenStorage.token {
            fetchProfile(token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true, completion: nil)
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
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                fetchProfileImageURL(profile.username)
            case .failure:
                let alertModel = AlertModel(title: "Ошибка", message: "Не удалось получить профиль.", buttonText: "OK", completion: nil)
                self.alertPresenter?.alert(alertData: alertModel)
                break
            }
        }
    }
    
    func fetchProfileImageURL(_ username: String) {
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.switchToTabBarController()
                break
            case .failure:
                let alertModel = AlertModel(title: "Ошибка", message: "Не удалось получить профиль.", buttonText: "OK", completion: nil)
                self.alertPresenter?.alert(alertData: alertModel)
                break
            }
        }
    }

    
//    private func showErrorAlert(message: String) {
//        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        present(alertController, animated: true, completion: nil)
//    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(with: code) { [weak self] result in
        }
    }
    
}

