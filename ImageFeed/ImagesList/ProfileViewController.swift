//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Anastasiia on 30.11.2024.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileServise = ProfileService.shared
    private let token = OAuth2TokenStorage().token
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default    // 2
                    .addObserver(
                        forName: ProfileImageService.didChangeNotification, // 3
                        object: nil,                                        // 4
                        queue: .main                                        // 5
                    ) { [weak self] _ in
                        guard let self = self else { return }
                        self.updateAvatar()                                 // 6
                    }
                updateAvatar()                                              // 7
    
    
    
        
        //ProfileImageService.shared.avatarURL
//        let imageUrlPath = L
//        let imageUrl = URL(string: imageUrlPath!)!
//        let request = URLRequest(url: imageUrl)
//        
//        // Так как сетевые операции URLSession — асинхронные, то есть результат от них мы получаем не сразу, необходимо передать замыкание окончания загрузки
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            // Если данные картинки не загружены или не удалось создать картинку из полученных данных, то ничего не делаем.
//            if let data = data,
//                let image = UIImage(data: data) {
//                // Помните, что все взаимодействия с UI-элементами возможны только на главном потоке!
//                DispatchQueue.main.async {
//                    self.view.addSubview(image)
//                }
//            }
//        // Не забудьте возобновить загрузку! Все операции по загрузке изначально создаются в спящем состоянии!
//        }.resume()
        
        let avatar = UIImage(named: "UsersAvatar")
        let usersAvatar = UIImageView(image: avatar)
        usersAvatar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usersAvatar)
        usersAvatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        usersAvatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        usersAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        usersAvatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
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
   
    
        
//        func updateProfileDetails(profile: Profile) {
//            usersName.text = profile.name
//            usersEmail.text = profile.loginName
//            usersText.text = profile.bio
//       }
        //        profileServise.fetchProfile(token: token ?? "") { [weak self] result in
        //            DispatchQueue.main.async {
        //                switch result {
        //                case .success(let profile):
        //                    // Обновление лейблов с данными профиля
        //                    usersName.text = profile.name
        //                    usersEmail.text = profile.loginName
        //                    usersText.text = profile.bio
        //                case .failure(let error):
        //                    // Вывод ошибки в консоль
        //                    print("Failed to fetch profile: \(error)")
        //                }
        //            }
        //        }
    }
    
    @objc
    private func didTapButton() {
    }
    
private func updateAvatar() {                                   // 8
       guard
           let profileImageURL = ProfileImageService.shared.avatarURL,
           let url = URL(string: profileImageURL)
       else { return }
       // TODO [Sprint 11] Обновить аватар, используя Kingfisher
   }
   
}
