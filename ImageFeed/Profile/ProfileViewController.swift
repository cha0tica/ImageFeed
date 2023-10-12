//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Agata on 16.06.2023.
//

import Foundation
import UIKit
import Kingfisher

final  class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let gradient = Gradient()
    private var animationLayers = Set<CALayer>()
    private var alertPresenter: AlertPresenter?
    
    private var profilePhotoImage : UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private var profileUserNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        
        return label
    }()
    
    private var profileNicknameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_novikova"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGray
        return label
    }()
    
    private var profileDescLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world!"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhite
        
        return label
    }()
    
    private var exitButton : UIButton = {
        let image = UIImage(named: "logout_button") ?? UIImage(systemName: "ipad.and.arrow.forward")!
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileInfo(profile: profileService.profile)
        addSubViews()
        configureConstraints()
        alertPresenter = AlertPresenter(delagate: self)
        addButtonAction()
        addGradients()
    }
}

private extension ProfileViewController {
    
    func addSubViews() {
        view.addSubview(profilePhotoImage)
        view.addSubview(profileUserNameLabel)
        view.addSubview(profileNicknameLabel)
        view.addSubview(profileDescLabel)
        view.addSubview(exitButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            profilePhotoImage.widthAnchor.constraint(equalToConstant: 70),
            profilePhotoImage.heightAnchor.constraint(equalToConstant: 70),
            profilePhotoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePhotoImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.centerYAnchor.constraint(equalTo: profilePhotoImage.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            profileUserNameLabel.leadingAnchor.constraint(equalTo: profilePhotoImage.leadingAnchor),
            profileUserNameLabel.topAnchor.constraint(equalTo: profilePhotoImage.bottomAnchor, constant: 8),
            
            profileNicknameLabel.leadingAnchor.constraint(equalTo: profilePhotoImage.leadingAnchor),
            profileNicknameLabel.topAnchor.constraint(equalTo: profileUserNameLabel.bottomAnchor, constant: 8),
            
            profileDescLabel.leadingAnchor.constraint(equalTo: profilePhotoImage.leadingAnchor),
            profileDescLabel.topAnchor.constraint(equalTo: profileNicknameLabel.bottomAnchor, constant: 8)
            
        ])
    }
}

private extension ProfileViewController {
    @objc
    func didTapButton() {
        showAlertBeforeExit()
    }
    
    func updateProfileInfo(profile: Profile?) {
        guard let profile = profile else { return }
        profileUserNameLabel.text = profile.name
        profileNicknameLabel.text = profile.loginName
        profileDescLabel.text = profile.bio
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
        print(profileUserNameLabel)
    }
    
    func updateAvatar() {
        guard
            let avatarURL = profileImageService.avatarURL,
            let url = URL(string: avatarURL)
        else { return }
        
        let avatarPlaceholderImage = UIImage(named: "avatar_placeholder")
        
        profilePhotoImage.kf.indicatorType = .activity
        profilePhotoImage.kf.setImage(
            with: url,
            placeholder: avatarPlaceholderImage
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.removeGradients()
            case .failure:
                self.removeGradients()
                profilePhotoImage.image = avatarPlaceholderImage
            }
        }
    }
    
    func addGradients() {
        let profilePhotoImageGradient = gradient.getGradient(
            size: CGSize(
                width: 70,
                height: 70
            ),
            cornerRadius: profilePhotoImage.layer.cornerRadius)
        profilePhotoImage.layer.addSublayer(profilePhotoImageGradient)
        animationLayers.insert(profilePhotoImageGradient)
        
        let profileUserNameLabelGradient = gradient.getGradient(size: CGSize(
            width: profileUserNameLabel.bounds.width,
            height: profileUserNameLabel.bounds.height
        ))
        profileUserNameLabel.layer.addSublayer(profileUserNameLabelGradient)
        animationLayers.insert(profileUserNameLabelGradient)
        
        let profileDescLabelGradient = gradient.getGradient(size: CGSize(
            width: profileDescLabel.bounds.width,
            height: profileDescLabel.bounds.height
        ))
        profileDescLabel.layer.addSublayer(profileDescLabelGradient)
        animationLayers.insert(profileDescLabelGradient)
        
        let profileNicknameLabelGradient = gradient.getGradient(size: CGSize(
            width: profileNicknameLabel.bounds.width,
            height: profileNicknameLabel.bounds.height
        ))
        profileNicknameLabel.layer.addSublayer(profileNicknameLabelGradient)
        animationLayers.insert(profileNicknameLabelGradient)
    }
    
    func removeGradients() {
        for gradient in animationLayers {
            gradient.removeFromSuperlayer()
        }
    }
    
    func addButtonAction() {
        if #available(iOS 14.0, *) {
            let logOutAction = UIAction(title: "showAlert") { [weak self] (ACTION) in
                guard let self = self else { return }
                self.showAlertBeforeExit()
            }
            exitButton.addAction(logOutAction, for: .touchUpInside)
        } else {
            exitButton.addTarget(ProfileViewController.self,
                                   action: #selector(didTapButton),
                                   for: .touchUpInside)
        }
    }
    
    func showAlertBeforeExit(){
        DispatchQueue.main.async {
            let alert = AlertModel(
                title: "Пока, пока!",
                message: "Уверены что хотите выйти?",
                buttonText: "Да",
                firstcompletion: { [weak self] in
                    guard let self = self else { return }
                    self.logOut()
                },
                secondButtonText: "Нет",
                secondCompletion: { [weak self] in
                    guard let self = self else { return }
                    
                    self.dismiss(animated: true)
                })
            
            self.alertPresenter?.show(alert)
        }
    }
    
    func logOut() {
        OAuth2TokenStorage().token = nil
        WebViewViewController.cleanCookies()
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        
        window.rootViewController = SplashViewController()
    }
}

extension ProfileViewController: AlertPresentableDelagate {
    func present(alert: UIAlertController, animated flag: Bool) {
        self.present(alert, animated: flag)
    }
}
