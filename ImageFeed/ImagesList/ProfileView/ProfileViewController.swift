//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Anastasiia on 30.11.2024.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    var view: UIView! { get }
    
    func getButton(exitImage: UIImage) -> UIButton
    
}

final class ProfileViewController: UIViewController, ViewControllerProtocol & ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    
    
    private let profileLogoutService = ProfileLogoutService.shared
    
    private let profileService = ProfileService.shared
    private let token = OAuth2TokenStorage.shared.token
    
    private let tupButton = TupButton()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private var alertPresenter: AlertPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        if nil == presenter {
            presenter = ProfileViewPresenter()
            presenter?.viewPresenter = self
        }
  
        
        alertPresenter = AlertPresenter()
        alertPresenter?.setup(delegate: self)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.presenter?.updateAvatar()
            }
        presenter?.setupUI()
        presenter?.updateAvatar()
        presenter?.changeLabels()
    }
    
   
    
//    func setupAvatar() {
//        usersAvatar.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(usersAvatar)
//        usersAvatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
//        usersAvatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
//        usersAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
//        usersAvatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
//        usersAvatar.clipsToBounds = true
//        usersAvatar.layer.cornerRadius = 35
//    }
//    
//    func setupUsersName() {
//        usersName.textColor = .white
//        usersName.font = .boldSystemFont(ofSize: 23)
//        usersName.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(usersName)
//        usersName.topAnchor.constraint(equalTo: usersAvatar.bottomAnchor, constant: 8).isActive = true
//        usersName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        usersName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
//    }
    
//    func setupUsersEmail() {
//        usersEmail.textColor = .ypGray
//        usersEmail.font = .systemFont(ofSize: 13)
//        usersEmail.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(usersEmail)
//        usersEmail.topAnchor.constraint(equalTo: usersName.bottomAnchor, constant: 8).isActive = true
//        usersEmail.leadingAnchor.constraint(equalTo: usersName.leadingAnchor).isActive = true
//        usersEmail.trailingAnchor.constraint(equalTo: usersName.trailingAnchor).isActive = true
//    }
//    
//    
//    func setupUsersText() {
//        usersText.textColor = .white
//        usersText.font = .systemFont(ofSize: 13)
//        usersText.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(usersText)
//        usersText.topAnchor.constraint(equalTo: usersEmail.bottomAnchor, constant: 8).isActive = true
//        usersText.leadingAnchor.constraint(equalTo: usersEmail.leadingAnchor).isActive = true
//        usersText.trailingAnchor.constraint(equalTo: usersEmail.trailingAnchor).isActive = true
//    }
    
//    func setupButton() {
//        guard let exitImage = UIImage(named: "exit") else {
//            print("Ошибка: изображение 'exit' не найдено")
//            return
//        }
//        
//        let button = UIButton.systemButton(
//            with: exitImage,
//            target: self,
//            action: #selector(Self.didTapButton)
//        )
//        
//        button.tintColor = .ypRed
//        button.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(button)
//        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
//        button.centerYAnchor.constraint(equalTo: usersAvatar.centerYAnchor).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
//    }
    
    
    
    func getButton(exitImage: UIImage) -> UIButton {
        return UIButton.systemButton(
            with: exitImage,
            target: self,
            action: #selector(didTapButton)
        )
    }
    
    @objc
    func didTapButton() {
        present(tupButton.tapButton(), animated: true, completion: nil)
    }
    
   
}
