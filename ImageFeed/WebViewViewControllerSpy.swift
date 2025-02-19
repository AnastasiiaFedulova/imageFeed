//
//  WebViewViewControllerSpy.swift
//  ImageFeed
//
//  Created by Anastasiia on 12.02.2025.
//

import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ _newValue: Float) {
        
    }
    
    func setProgressHidden(_ _isHidden: Bool) {
        
    }
    
}
