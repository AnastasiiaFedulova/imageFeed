//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Anastasiia on 15.02.2025.
//

import Foundation
import UIKit
import Kingfisher

public protocol ProfileViewPresenterProtocol {
    var viewPresenter: ProfileViewControllerProtocol? { get set }
    func setupUI()
    func updateAvatar()
    func changeLabels()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var viewPresenter: ProfileViewControllerProtocol?
    
    private let usersAvatar = UIImageView()
    private let usersName = UILabel()
    private let usersEmail = UILabel()
    private let usersText = UILabel()
    private let profileService = ProfileService.shared
    
    func setupUI() {
        setupAvatar()
        setupUsersName()
        setupUsersEmail()
        setupUsersText()
        setupButton()
    }
    
    func setupAvatar() {
        guard let view = viewPresenter?.view else { return }
        
        usersAvatar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usersAvatar)
        usersAvatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        usersAvatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        usersAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        usersAvatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        usersAvatar.clipsToBounds = true
        usersAvatar.layer.cornerRadius = 35
    }
    
    func setupUsersName() {
        guard let view = viewPresenter?.view else { return }
        
        usersName.textColor = .white
        usersName.font = .boldSystemFont(ofSize: 23)
        usersName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usersName)
        usersName.topAnchor.constraint(equalTo: usersAvatar.bottomAnchor, constant: 8).isActive = true
        usersName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        usersName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
    }
    
    func setupUsersEmail() {
        guard let view = viewPresenter?.view else { return }
        
        usersEmail.textColor = .ypGray
        usersEmail.font = .systemFont(ofSize: 13)
        usersEmail.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usersEmail)
        usersEmail.topAnchor.constraint(equalTo: usersName.bottomAnchor, constant: 8).isActive = true
        usersEmail.leadingAnchor.constraint(equalTo: usersName.leadingAnchor).isActive = true
        usersEmail.trailingAnchor.constraint(equalTo: usersName.trailingAnchor).isActive = true
    }
    
    func setupUsersText() {
        guard let view = viewPresenter?.view else { return }
        
        usersText.textColor = .white
        usersText.font = .systemFont(ofSize: 13)
        usersText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usersText)
        usersText.topAnchor.constraint(equalTo: usersEmail.bottomAnchor, constant: 8).isActive = true
        usersText.leadingAnchor.constraint(equalTo: usersEmail.leadingAnchor).isActive = true
        usersText.trailingAnchor.constraint(equalTo: usersEmail.trailingAnchor).isActive = true
    }
    
    func setupButton() {
        guard let exitImage = UIImage(named: "exit") else {
            print("Ошибка: изображение 'exit' не найдено")
            return
        }
        guard let view = viewPresenter?.view else { return }
        
        let button = viewPresenter?.getButton(exitImage: exitImage)
        guard let button = button else {
            print("Ошибка: изображение 'exitButton' не создан")
            return
        }
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: usersAvatar.centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @MainActor func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        usersAvatar.kf.setImage(with: url, placeholder: UIImage(named: "UsersAvatar"), options: [.processor(processor)])
    }
    
    func changeLabels() {
        usersName.text = profileService.profile?.name
        usersEmail.text = profileService.profile?.loginName
        usersText.text = profileService.profile?.bio
    }
}
