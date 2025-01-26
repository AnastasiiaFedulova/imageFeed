//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Anastasiia on 13.12.2024.
//

import UIKit
import ProgressHUD


final class AuthViewController: UIViewController, ViewControllerProtocol {
    
    private let oauth2Service = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    private var alertPresenter: AlertPresenter?
    
    let identifier = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
        alertPresenter = AlertPresenter()
        alertPresenter?.setup(delegate: self)
      
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
    
    
    //    private func showAlert() {
    //        let alertController = UIAlertController(
    //            title: "Что-то пошло не так(",
    //            message: "Не удалось войти в систему",
    //            preferredStyle: .alert
    //        )
    //        let okAction = UIAlertAction(title: "Ок", style: .default)
    //        alertController.addAction(okAction)
    //        present(alertController, animated: true)
    //    }
    
}
protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController,didAuthenticateWithCode code: String)
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(with: code) { [weak self] (result: Result<String, Error>) in defer {
            UIBlockingProgressHUD.dismiss()
        }
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                oauth2TokenStorage.token = token
                self.delegate?.didAuthenticate(self, didAuthenticateWithCode: token)
                print("Успешно получен токен: \(token)")
            case .failure(let error):
                print("Ошибка авторизации: \(error.localizedDescription)")
                let alertModel = AlertModel(title: "Что-то пошло не так(", message: "Не удалось войти в систему", buttonText: "OK", completion: nil)
                self.alertPresenter?.alert(alertData: alertModel)
               // showAlert()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

