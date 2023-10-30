//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Agata on 18.08.2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage()
    private var lastCode: String?
    private var task: URLSessionTask?
    
    private (set) var authToken: String? {
        get {
            tokenStorage.token
        }
        set {
            tokenStorage.token = newValue
        }
    }
    
    private init() { }
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let request = authTokenRequest(code: code) else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>)  in
            guard let self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

private extension OAuth2Service {
    func authTokenRequest(code: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(accessKey)"
            + "&&client_secret=\(secretKey)"
            + "&&redirect_uri=\(redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: .POST,
            baseURL: defaultURL
        )
    }
    
}
