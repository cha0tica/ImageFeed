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
        let image = UIImage(named: "logout_image") ?? UIImage(systemName: "ipad.and.arrow.forward")!
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        
        if #available(iOS 14.0, *) {
            let logOutAction = UIAction(title: "Logout") { (ACTION) in
                //TODO: Выход из профиля
            }
            button.addAction(logOutAction, for: .touchUpInside)
        } else {
            button.addTarget(ProfileViewController.self,
                             action: #selector(didTapButton),
                             for: .touchUpInside)
        }
        
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
        //TODO: Выход из профиля
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
        )
    }
}

