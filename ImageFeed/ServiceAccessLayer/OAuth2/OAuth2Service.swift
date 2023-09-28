//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Agata on 18.08.2023.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    let urlSession = URLSession.shared
    var task: URLSessionTask?
    var lastCode: String?
    private (set) var authToken: String? {
        get {
            let tokenStorage = OAuth2TokenStorage()
            return tokenStorage.token
        }
        set {
            let tokenStorage = OAuth2TokenStorage()
            tokenStorage.token = newValue
        }
    }
    
    init() { }
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String,Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let request = authTokenRequest(code: code) else {
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                    case .success(let body):
                        let authToken = body.accessToken
                        self.authToken = authToken
                        completion(.success(authToken))
                        self.task = nil
                    case .failure(let error):
                        completion(.failure(error))
                        self.lastCode = nil
                }
            }
        }
        
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
    
    func authTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(string: "https://unsplash.com"),
              let request = URLRequest.makeHTTPRequest(
                path: "/oauth/token"
                + "?client_id=\(accessKey)"
                + "&&client_secret=\(secretKey)"
                + "&&redirect_uri=\(redirectURI)"
                + "&&code=\(code)"
                + "&&grant_type=authorization_code",
                httpMethod: "POST",
                baseURL: url)
        else {
            return nil
        }
        return request
    }
}
