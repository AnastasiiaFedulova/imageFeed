//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Anastasiia on 20.01.2025.
//

import Foundation

struct AlertModel {
    
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
