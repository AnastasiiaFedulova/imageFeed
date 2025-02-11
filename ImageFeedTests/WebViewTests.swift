//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Anastasiia on 10.02.2025.
//
@testable import ImageFeed
import XCTest

final class ImageFeedTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssert(presenter.viewDidLoadCalled)
    }
}
