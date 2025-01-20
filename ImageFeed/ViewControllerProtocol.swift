//
//  ViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Anastasiia on 20.01.2025.
//

import Foundation
import UIKit

protocol ViewControllerProtocol: AnyObject {

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}
