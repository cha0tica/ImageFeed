//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Agata on 27.09.2023.
//

import Foundation
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?
    
    var topVC: UIViewController {
           var topController: UIViewController = UIApplication.shared.mainKeyWindow!.rootViewController!
           while (topController.presentedViewController != nil) {
               topController = topController.presentedViewController!
           }
           return topController
       }
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func showAlert(_ model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
            )
        
        let action = UIAlertAction(
            title: model.firstButtonText,
            style: .default) { _ in
            model.firstButtonCompletion()
        }
        
        let secondAction = UIAlertAction(
            title: model.secondButtonText,
            style: .default) { _ in
                model.secondButtonCompletion()
        }
        
        alert.addAction(action)
        alert.addAction(secondAction)
        topVC.present(alert, animated: true)
    }
}

extension UIApplication {
    var mainKeyWindow: UIWindow? {
        get {
            if #available(iOS 13, *) {
                return connectedScenes
                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }
            } else {
                return keyWindow
            }
        }
    }
}

