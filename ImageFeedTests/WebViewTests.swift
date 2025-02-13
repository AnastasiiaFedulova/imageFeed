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
    
    func testPresenterCallsLoadRequest() {
        
    let viewController = WebViewViewControllerSpy()
    let authHelper = AuthHelper()
    let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.loadRequestCalled)
        
    }
    
    func testProgressVisibleWhenLessThenOne() {
        let authHelper = AuthHelper()
            let presenter = WebViewPresenter(authHelper: authHelper)
            let progress: Float = 0.6
            
            //when
            let shouldHideProgress = presenter.shouldHideProgress(for: progress)
            
            //then
            XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress = 1
        
        let shouldHideProgress = presenter.shouldHideProgress(for: Float(progress))
        
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.authURL()
        let urlString = url!.absoluteString
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        let code = authHelper.code(from: url)
        
        XCTAssertEqual(code, "test code")
    }
}

