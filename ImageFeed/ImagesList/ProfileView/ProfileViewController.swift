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
    var usersAvatar: UIImageView { get }
    var usersName: UILabel { get }
    var usersEmail: UILabel { get }
    var usersText: UILabel { get }
    
    func getExitImage() -> UIImage?
    func getUserAvatarImage() -> UIImage?
    
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
    
    var usersAvatar = UIImageView()
    var usersName = UILabel()
    var usersEmail = UILabel()
    var usersText = UILabel()
    
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
    
    func getExitImage() -> UIImage? {
        return UIImage(named: "exit")
    }
    
    func getUserAvatarImage() -> UIImage? {
        return UIImage(named: "UsersAvatar")
    }
}
