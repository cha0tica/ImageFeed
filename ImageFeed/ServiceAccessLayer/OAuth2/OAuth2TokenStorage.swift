//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Agata on 18.08.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let keyChainWrapper = KeychainWrapper.standard
    
    private enum Keys: String {
        case accessToken
    }
    
    var token: String? {
        get {
            keyChainWrapper.string(forKey: Keys.accessToken.rawValue)
        }
        set {
            keyChainWrapper.set(newValue ?? "", forKey: Keys.accessToken.rawValue)
        }
    }
    
    func removeToken() {
        token = nil
        keyChainWrapper.removeObject(forKey: Keys.accessToken.rawValue)
    }
}
