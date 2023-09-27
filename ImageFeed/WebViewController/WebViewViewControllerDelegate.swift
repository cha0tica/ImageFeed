//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Agata on 27.09.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
