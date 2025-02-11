//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Anastasiia on 13.12.2024.
//

import UIKit
import WebKit

//private enum WebViewConstants {
//    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
//}

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_newValue: Float)
    func setProgressHidden(_isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    @IBOutlet private var webView: WKWebView!
    
    @IBOutlet private var progressView: UIProgressView!
    
    var delegate: WebViewViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // loadAuthView()
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        //    updateProgress()
        
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 //          self.updateProgress()
             })
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        //    updateProgress()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            //            updateProgress()
            presenter?.didUpdateProgressValue(_newValue: webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func setProgressValue(_newValue newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_isHidden isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    //    private func updateProgress() {
    //        progressView.progress = Float(webView.estimatedProgress)
    //        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    //    }
    
    //    private func loadAuthView() {
    //        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
    //            print("URL components not found")
    //            return
    //        }
    //        
    //        urlComponents.queryItems = [
    //            URLQueryItem(name: "client_id", value: Constants.accessKey),
    //            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
    //            URLQueryItem(name: "response_type", value: "code"),
    //            URLQueryItem(name: "scope", value: Constants.accessScope)
    //        ]
    //        
    //        guard let url = urlComponents.url else {
    //            print ("Not fount URL")
    //            return
    //        }
    //        
    //        let request = URLRequest(url: url)
    //        webView.load(request)
    //    }
    
    //    private func code(from navigationAction: WKNavigationAction) -> String? {
    //        if
    //            let url = navigationAction.request.url,
    //            let urlComponents = URLComponents(string: url.absoluteString),
    //            urlComponents.path == "/oauth/authorize/native",
    //            let items = urlComponents.queryItems,
    //            let codeItem = items.first(where: { $0.name == "code" })
    //        {
    //            return codeItem.value
    //        } else {
    //            print("Code not found")
    //            return nil
    //        }
    //    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        let code = code(from: navigationAction)
        if let code {
            // TODO: process code
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

protocol WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
