//
//  AlertPresentableDelagate.swift
//  ImageFeed
//
//  Created by Agata on 28.09.2023.
//

import Foundation
import UIKit

protocol AlertPresentableDelagate: AnyObject {
    func present(alert: UIAlertController, animated flag: Bool)
}
