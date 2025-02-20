//
//  ProfileViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Anastasiia on 16.02.2025.
//

import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewPresenter: ProfileViewControllerProtocol?
    var setupCalled: Bool = false
    var updateAvatarCalled: Bool = false
    var changeLabesCalled: Bool = false
    func setupUI() {
        setupCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func changeLabels() {
        changeLabesCalled = true
    }

}

