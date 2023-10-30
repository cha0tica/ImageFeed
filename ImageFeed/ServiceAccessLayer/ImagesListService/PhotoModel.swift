//
//  PhotoModel.swift
//  ImageFeed
//
//  Created by Agata on 29.09.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: CGFloat
    let height: CGFloat
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}

struct UrlsResult: Codable {
    let raw: String?
    let small: String?
    let thumb: String?
    let full: String?
}

struct LikeResponse: Codable {
    let photo: LikeResult
}

struct LikeResult: Codable {
    let id: String
    let likedByUser: Bool
}
