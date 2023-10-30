//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Agata on 18.08.2023.
//

import Foundation
import UIKit


final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    @IBOutlet private weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSignInButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}


private extension AuthViewController {
    func configureSignInButton() {
        signInButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        signInButton.layer.cornerRadius = 16
        signInButton.layer.masksToBounds = true
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
        vc.dismiss(animated: true)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
