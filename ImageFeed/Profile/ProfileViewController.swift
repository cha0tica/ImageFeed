//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Agata on 16.06.2023.
//

import Foundation
import UIKit

final  class ProfileViewController: UIViewController {
    
    private var profilePhotoImage = UIImageView()
    private var profileUserNameLabel = UILabel()
    private var profileNicknameLabel = UILabel()
    private var profileDescLabel = UILabel()
    private var exitButton = UIButton()
    
    private let profilePhoto = "avatar"
    private let profileUserName = "Екатерина новикова"
    private let profileNickname = "@ekaterina_novikova"
    private let profileDescription = "Hello, world!"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeProfilePhotoImage()
        makeProfileFullNameLabel()
        makeProfileNicknameLabel()
        makeProfileBioLabel()
        makeProfileExitButton()
    }
}

// MARK: - Private methods
private extension ProfileViewController {
    @objc func didTapButton() {
    }
    
    func makeProfilePhotoImage() {
        profilePhotoImage.image = UIImage(named: profilePhoto)
        profilePhotoImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profilePhotoImage)
        
        NSLayoutConstraint.activate([
            profilePhotoImage.widthAnchor.constraint(equalToConstant: 70),
            profilePhotoImage.heightAnchor.constraint(equalToConstant: 70),
            profilePhotoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePhotoImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    func makeProfileFullNameLabel() {
        profileUserNameLabel.text = profileUserName
        profileUserNameLabel.textColor = UIColor.ypWhite
        profileUserNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        profileUserNameLabel.lineBreakMode = .byWordWrapping
        profileUserNameLabel.numberOfLines = 2
        
        profileUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileUserNameLabel)
        
        NSLayoutConstraint.activate([
            profileUserNameLabel.topAnchor.constraint(equalTo: profilePhotoImage.bottomAnchor, constant: 8),
            profileUserNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileUserNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func makeProfileNicknameLabel() {
        profileNicknameLabel.text = profileNickname
        profileNicknameLabel.textColor = UIColor.ypGray
        profileNicknameLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        profileNicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileNicknameLabel)
        
        NSLayoutConstraint.activate([
            profileNicknameLabel.topAnchor.constraint(equalTo: profileUserNameLabel.bottomAnchor, constant: 8),
            profileNicknameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileNicknameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func makeProfileBioLabel() {
        profileDescLabel.text = profileDescription
        profileDescLabel.textColor = UIColor.ypWhite
        profileDescLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        profileDescLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileDescLabel)
        
        NSLayoutConstraint.activate([
            profileDescLabel.topAnchor.constraint(equalTo: profileNicknameLabel.bottomAnchor, constant: 8),
            profileDescLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileDescLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func makeProfileExitButton() {
        let profileExitButtonImage = UIImage(named: "logout_button") ?? UIImage()
        
        exitButton = UIButton.systemButton(
            with: profileExitButtonImage,
            target: self,
            action: #selector(self.didTapButton)
        )
        exitButton.tintColor = UIColor.ypRed
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.centerYAnchor.constraint(equalTo: profilePhotoImage.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

extension UIColor {
    static let ypRed: UIColor = {
        if let redColor = UIColor(named: "Colors.YP Red") {
            return redColor
        } else {
            return UIColor.red // Цвет по умолчанию, если цвет с именем "YP Red" не удалось загрузить
        }
    }()
    
    static let ypWhite: UIColor = {
        if let whiteColor = UIColor(named: "Colors.YP White") {
            return whiteColor
        } else {
            return UIColor.white // Цвет по умолчанию, если цвет с именем "YP White" не удалось загрузить
        }
    }()
    
    static let ypGray: UIColor = {
        if let grayColor = UIColor(named: "Colors.YP Gray") {
            return grayColor
        } else {
            return UIColor.gray // Цвет по умолчанию, если цвет с именем "YP Gray" не удалось загрузить
        }
    }()
}
