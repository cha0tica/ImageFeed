//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Agata on 18.08.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
