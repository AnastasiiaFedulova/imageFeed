//
//  ImageListViewControllerTests.swift
//  ImageListViewControllerTests
//
//  Created by Anastasiia on 17.02.2025.
//

import XCTest
@testable import ImageFeed

final class ImageListViewControllerTests: XCTestCase {
    
    func testImageFetchService() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let imageFetchService = ImageFetchServiceSpy()
        viewController.imageFetchService = imageFetchService
    
        _ = viewController.view
        
        XCTAssert(imageFetchService.fetchImagesCalled)
        
    }
}
