//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Agata on 27.09.2023.
//

import Foundation

final class ProfileImageService {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    
    private (set) var avatarURL: URL?
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = urlRequestWithBearerToken(username: username) else {
            return
        }
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileImageResponseModel, Error>) in
            guard let self else { return }
            task = nil
            switch result {
            case .success(let body):
                let profileImageURL = body.profileImage.medium
                avatarURL = URL(string: profileImageURL!)
                completion(.success(profileImageURL!))
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification,
                          object: self,
                          userInfo: ["URL": profileImageURL as Any]
                    )
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task?.resume()
    }
}

private extension ProfileImageService {
    func urlRequestWithBearerToken(username: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: .GET
        )
    }
}
