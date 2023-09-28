//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Agata on 27.09.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
