//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Anastasiia on 30.11.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, ViewControllerProtocol {
    
    private let profileLogoutService = ProfileLogoutService.shared
    
    
    private let profileServise = ProfileService.shared
    private let token = OAuth2TokenStorage().token
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let usersAvatar = UIImageView()
    
    private var alertPresenter: AlertPresenter?
    
//     var animationLayers = Set<CALayer>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        alertPresenter = AlertPresenter()
        alertPresenter?.setup(delegate: self)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
//                self.removeGradient()
                self.updateAvatar()

            }
        setupUI()
        updateAvatar()
    }
    
    private func setupUI() {
        usersAvatar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usersAvatar)
        usersAvatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        usersAvatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        usersAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        usersAvatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        usersAvatar.clipsToBounds = true
        usersAvatar.layer.cornerRadius = 35
        
        
        let usersName = UILabel()
        usersName.text = "Екатерина Новикова"
        usersName.textColor = .white
        usersName.font = .boldSystemFont(ofSize: 23)
        usersName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usersName)
        usersName.topAnchor.constraint(equalTo: usersAvatar.bottomAnchor, constant: 8).isActive = true
        usersName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        usersName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
        
        let usersEmail = UILabel()
        usersEmail.text = "@ekaterina_nov"
        usersEmail.textColor = .ypGray
        usersEmail.font = .systemFont(ofSize: 13)
        usersEmail.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usersEmail)
        usersEmail.topAnchor.constraint(equalTo: usersName.bottomAnchor, constant: 8).isActive = true
        usersEmail.leadingAnchor.constraint(equalTo: usersName.leadingAnchor).isActive = true
        usersEmail.trailingAnchor.constraint(equalTo: usersName.trailingAnchor).isActive = true
        
        let usersText = UILabel()
        usersText.text = "Hello, world!"
        usersText.textColor = .white
        usersText.font = .systemFont(ofSize: 13)
        usersText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usersText)
        usersText.topAnchor.constraint(equalTo: usersEmail.bottomAnchor, constant: 8).isActive = true
        usersText.leadingAnchor.constraint(equalTo: usersEmail.leadingAnchor).isActive = true
        usersText.trailingAnchor.constraint(equalTo: usersEmail.trailingAnchor).isActive = true
        
        
        guard let exitImage = UIImage(named: "exit") else {
            print("Ошибка: изображение 'exit' не найдено")
            return
        }
        
        let button = UIButton.systemButton(
            with: exitImage,
            target: self,
            action: #selector(Self.didTapButton)
        )
        
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: usersAvatar.centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        usersName.text = profileServise.profile?.name
        usersEmail.text = profileServise.profile?.loginName
        usersText.text = profileServise.profile?.bio
        
//        addGradient(to: usersAvatar, size: CGSize(width: 70, height: 70), cornerRadius: 35)
//        addGradient(to: usersName, size: CGSize(width: 270, height: 23),cornerRadius: 10)
//        addGradient(to: usersEmail, size: CGSize(width: 140, height: 18),cornerRadius: 9)
//        addGradient(to: usersText, size: CGSize(width: 80, height: 18),cornerRadius: 9)
        
    }
    
    @objc
        private func didTapButton() {
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
            
            present(alert, animated: true, completion: nil)
        }
    
//    private func addGradient(to view: UIView, size: CGSize, cornerRadius: CGFloat = 0) {
//        let gradient = CAGradientLayer()
//        gradient.frame = CGRect(origin: .zero, size: size)
//        gradient.locations = [0, 0.1, 0.3]
//        gradient.colors = [
//            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
//               UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
//               UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
//        ]
//        gradient.startPoint = CGPoint(x: 0, y: 0.5)
//        gradient.endPoint = CGPoint(x: 1, y: 0.5)
//        gradient.cornerRadius = cornerRadius
//        gradient.masksToBounds = true
//        animationLayers.insert(gradient)
//        view.layer.addSublayer(gradient)
//
//        
//        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
//        gradientChangeAnimation.duration = 1.0
//        gradientChangeAnimation.repeatCount = .infinity
//        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
//        gradientChangeAnimation.toValue = [0, 0.8, 1]
//        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
//    }
    
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        usersAvatar.kf.setImage(with: url, placeholder: UIImage(named: "UsersAvatar"), options: [.processor(processor)])
    }
    
//    private func removeGradient() {
//           animationLayers.forEach { $0.removeFromSuperlayer() }
//           animationLayers.removeAll()
//       }
}

