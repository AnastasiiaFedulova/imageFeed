//
//  WebViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Anastasiia on 11.02.2025.
//

import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_newValue newValue: Double) {
    
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
