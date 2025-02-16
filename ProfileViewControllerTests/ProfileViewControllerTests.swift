//
//  ProfileViewControllerTests.swift
//  ProfileViewControllerTests
//
//  Created by Anastasiia on 13.02.2025.
//

import XCTest
@testable import ImageFeed

final class ProfileViewControllerTests: XCTestCase {
    
    func testProfileViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.viewPresenter = viewController
        
        _ = viewController.view
        viewController.viewDidLoad()
        
        XCTAssert(presenter.setupCalled)
        XCTAssert(presenter.updateAvatarCalled)
        XCTAssert(presenter.changeLabesCalled)
    }
}
