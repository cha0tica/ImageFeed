//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Agata on 27.09.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private var lastToken: String = ""
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private init() { }
    
    func fetchProfile(authToken: String, completion: @escaping (Result<Profile?, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeHTTPReqeust() else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let body):
                profile = Profile(
                    username: body.username,
                    bio: body.bio ?? "",
                    firstName: body.firstName,
                    lastName: body.lastName ?? ""
                )
                
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
}

extension ProfileService {
    func makeHTTPReqeust() -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/me", httpMethod: .GET)
    }
}
