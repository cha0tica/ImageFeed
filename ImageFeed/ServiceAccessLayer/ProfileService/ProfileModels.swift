//
//  ProfileModels.swift
//  ImageFeed
//
//  Created by Agata on 27.09.2023.
//

import Foundation

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}

struct ProfileImageResponseModel: Decodable {
    let profileImage: ProfileImage

}

//struct UserResult: Codable {
//    let profileImage: ProfileImage?
//    
//    enum CodingKeys: String, CodingKey {
//        case profileImage = "profile_image"
//    }
//}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

struct Profile {
    let username: String
    var loginName: String {
        return "@\(username)"
    }
    let bio: String
    let firstName: String
    let lastName: String
    var name: String {
        return "\(firstName) \(lastName)"
    }
}
