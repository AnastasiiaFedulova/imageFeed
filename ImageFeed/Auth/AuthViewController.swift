//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Anastasiia on 13.12.2024.
//
import UIKit

final class AuthViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service()
    weak var delegate: AuthViewControllerDelegate?
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    let identifier = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(identifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
           navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
           navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
           navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }

}
protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)

}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) // Закрыли WebView
    
        // Используем сервис OAuth2 для получения токена
        oauth2Service.fetchOAuthToken(with: code) { [weak self] (result: Result<String, Error>) in
                  guard let self = self else { return }
                  switch result {
                  case .success(let token):
                      // Уведомляем делегата об успешной авторизации
                      oauth2TokenStorage.token = token
                      self.delegate?.didAuthenticate(self)
                      print("Успешно получен токен: \(token)")
                  case .failure(let error):
                      // Логируем ошибку
                      print("Ошибка авторизации: \(error.localizedDescription)")
                  }
              }
          }

      func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
          dismiss(animated: true)
      }
  }
