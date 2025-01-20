//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Anastasiia on 20.01.2025.
//

import Foundation
import UIKit

class AlertPresenter {
weak var delegate: ViewControllerProtocol?
    func alert (alertData: AlertModel) {
        let alert = UIAlertController(title: alertData.title,
                                      message: alertData.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertData.buttonText, style: .default) { _ in (alertData.completion ?? nil)
        }
        
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
    func setup(delegate: ViewControllerProtocol) {
        self.delegate = delegate
    }
}
    
