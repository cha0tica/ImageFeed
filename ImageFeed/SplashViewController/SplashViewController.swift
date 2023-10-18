//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Agata on 18.08.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private struct Keys {
        static let main = "Main"
        static let authViewControllerID = "AuthViewController"
        static let launchScreenNameImage = "LaunchScreen"
        static let showAuthSegueIdentifierName = "authStoryBordID"
        static let tabBarViewControllerName = "TabBarViewController"
    }
    
    private let splashScreenImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: Keys.launchScreenNameImage))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let ShowAuthSegueIdentifier = Keys.showAuthSegueIdentifierName
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter: AlertPresenterProtocol?
    private var authViewController: AuthViewController?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            self.fetchProfile(token: token)
        } else {
            switchToAuthViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubViews()
        configureConstraints()
    }
}

extension SplashViewController: AuthViewControllerDelegate{
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: Keys.main, bundle: .main)
        authViewController = storyboard.instantiateViewController(withIdentifier: Keys.authViewControllerID) as? AuthViewController
        
        guard let authViewController = authViewController else { return }
        authViewController.delegate = self
        
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
}

extension SplashViewController {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchAuthToken(code)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        
        let tapBarController = UIStoryboard(name: Keys.main, bundle: .main).instantiateViewController(withIdentifier: Keys.tabBarViewControllerName)
        window.rootViewController = tapBarController
    }
    
    private func fetchAuthToken(_ code: String){
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let token):
                    self.fetchProfile(token: token)
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showErrorAlert()
                    
                    break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let data):
                    
                    profileImageService.fetchProfileImageURL(
                        token: token,
                        username: data.username
                    ){ _ in }
                    
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
                case .failure:
                    self.showErrorAlert()
                    break
            }
        }
        
    }
}

//MARK: - AlertPresenter
extension SplashViewController {
    private func showErrorAlert(message: String = "Не удалось войти в систему"){
        let alert = AlertModel(title: "Что-то пошло не так(",
                               message: message,
                               buttonText: "Ок",
                               firstcompletion: { [weak self] in
            guard let self = self else {
                return
            }
            oauth2TokenStorage.token = nil
            WebViewViewController.cleanCookies()
        })
        
        let topController = UIApplication.topViewController()
        if let topController = topController {
            alertPresenter = AlertPresenter(delagate: topController as? AlertPresentableDelagate)
        } else {
            alertPresenter = AlertPresenter(delagate: self)
        }
        
        alertPresenter?.show(alert)
    }
}

extension SplashViewController: AlertPresentableDelagate {
    func present(alert: UIAlertController, animated flag: Bool) {
        self.present(alert, animated: flag)
    }
}

extension SplashViewController {
    func addSubViews() {
        view.addSubview(splashScreenImageView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            splashScreenImageView.heightAnchor.constraint(equalToConstant: 77),
            splashScreenImageView.widthAnchor.constraint(equalToConstant: 74),
            splashScreenImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashScreenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
