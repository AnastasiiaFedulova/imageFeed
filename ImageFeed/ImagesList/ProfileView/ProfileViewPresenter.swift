//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Anastasiia on 15.02.2025.
//

import Foundation
import Kingfisher

public protocol ProfileViewPresenterProtocol {
    var viewPresenter: ProfileViewControllerProtocol? { get set }
    func setupUI()
    func updateAvatar()
    func changeLabels()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var viewPresenter: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    
    func setupUI() {
        setupAvatar()
        setupUsersName()
        setupUsersEmail()
        setupUsersText()
        setupButton()
    }
    
    func setupAvatar() {
        guard let viewPresenter = viewPresenter else { return }
        
        guard let view = viewPresenter.view else { return }
        
        viewPresenter.usersAvatar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewPresenter.usersAvatar)
        viewPresenter.usersAvatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        viewPresenter.usersAvatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        viewPresenter.usersAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        viewPresenter.usersAvatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        viewPresenter.usersAvatar.clipsToBounds = true
        viewPresenter.usersAvatar.layer.cornerRadius = 35
    }
    
    func setupUsersName() {
        
        guard let viewPresenter = viewPresenter else { return }
        guard let view = viewPresenter.view else { return }
        
        viewPresenter.usersName.textColor = .white
        viewPresenter.usersName.font = .boldSystemFont(ofSize: 23)
        viewPresenter.usersName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewPresenter.usersName)
        viewPresenter.usersName.topAnchor.constraint(equalTo: viewPresenter.usersAvatar.bottomAnchor, constant: 8).isActive = true
        viewPresenter.usersName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        viewPresenter.usersName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
    }
    
    func setupUsersEmail() {
        
        guard let viewPresenter = viewPresenter else { return }
        guard let view = viewPresenter.view else { return }
        
        viewPresenter.usersEmail.textColor = .ypGray
        viewPresenter.usersEmail.font = .systemFont(ofSize: 13)
        viewPresenter.usersEmail.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview( viewPresenter.usersEmail)
        viewPresenter.usersEmail.topAnchor.constraint(equalTo:  viewPresenter.usersName.bottomAnchor, constant: 8).isActive = true
        viewPresenter.usersEmail.leadingAnchor.constraint(equalTo:  viewPresenter.usersName.leadingAnchor).isActive = true
        viewPresenter.usersEmail.trailingAnchor.constraint(equalTo:  viewPresenter.usersName.trailingAnchor).isActive = true
    }
    
    func setupUsersText() {
        guard let viewPresenter = viewPresenter else { return }
        guard let view = viewPresenter.view else { return }
        
        viewPresenter.usersText.textColor = .white
        viewPresenter.usersText.font = .systemFont(ofSize: 13)
        viewPresenter.usersText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewPresenter.usersText)
        viewPresenter.usersText.topAnchor.constraint(equalTo: viewPresenter.usersEmail.bottomAnchor, constant: 8).isActive = true
        viewPresenter.usersText.leadingAnchor.constraint(equalTo: viewPresenter.usersEmail.leadingAnchor).isActive = true
        viewPresenter.usersText.trailingAnchor.constraint(equalTo: viewPresenter.usersEmail.trailingAnchor).isActive = true
    }
    
    func setupButton() {
        guard let exitImage = viewPresenter?.getExitImage() else {
            print("Ошибка: изображение 'exit' не найдено")
            return
        }
        guard let viewPresenter = viewPresenter else { return }
        guard let view = viewPresenter.view else { return }
        
        let button = viewPresenter.getButton(exitImage: exitImage)
        
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: viewPresenter.usersAvatar.centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @MainActor func updateAvatar() {
        
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        viewPresenter?.usersAvatar.kf.setImage(with: url, placeholder: viewPresenter?.getUserAvatarImage(), options: [.processor(processor)])
    }
    
    func changeLabels() {
        
        guard let viewPresenter = viewPresenter else { return }
        
        viewPresenter.usersName.text = profileService.profile?.name
        viewPresenter.usersEmail.text = profileService.profile?.loginName
        viewPresenter.usersText.text = profileService.profile?.bio
    }
}
