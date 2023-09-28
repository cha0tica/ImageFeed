//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Agata on 27.09.2023.
//

import Foundation

final class ProfileImageService {

    private struct Keys {
        static let authorization = "Authorization"
        static let bearer = "Bearer"
        static let httpMethodGet = "GET"
        static let notificationName = "ProfileImageProviderDidChange"
        static let paramNameURL = "URL"
    }
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: Keys.notificationName)
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    private init() { }
    
    func fetchProfileImageURL(
        token: String,
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ){
        assert(Thread.isMainThread)
        if avatarURL != nil { return }
        task?.cancel()
        
        var requestImage = profileImageURLRequest(userName: username)
        requestImage?.addValue("\(Keys.bearer) \(token)", forHTTPHeaderField: Keys.authorization)
        
        guard let requestImage = requestImage else { return }
        
        let task = urlSession.objectTask(for: requestImage) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                    case .success(let body):
                        let avatarURL = body.profileImage?.small
                        
                        guard let avatarURL = avatarURL else { return }
                        self.avatarURL = avatarURL
                        
                        completion(.success(avatarURL))
                        NotificationCenter.default
                            .post(
                                name: ProfileImageService.DidChangeNotification,
                                object: self,
                                userInfo: [Keys.paramNameURL: avatarURL])
                        
                        self.task = nil
                    case .failure(let error):
                        completion(.failure(error))
                        self.avatarURL = nil
                }
            }
        }
        
        self.task = task
        task.resume()
    }
}

private extension ProfileImageService {
    func profileImageURLRequest(userName: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/users/\(userName)",
            httpMethod: Keys.httpMethodGet
        )
    }
}

