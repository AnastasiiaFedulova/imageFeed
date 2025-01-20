//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Anastasiia on 30.11.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileServise = ProfileService.shared
    private let token = OAuth2TokenStorage().token
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let usersAvatar = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
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
    }
    
    @objc
    private func didTapButton() {
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        usersAvatar.kf.setImage(with: url, placeholder: UIImage(named: "UsersAvatar"), options: [.processor(processor)])
    }
}
