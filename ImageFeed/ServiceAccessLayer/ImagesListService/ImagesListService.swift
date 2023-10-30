//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Agata on 29.09.2023.
//

import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    static let shared = ImagesListService()
    
    private let urlSession = URLSession.shared
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int = 1
    private var currentTask: URLSessionTask?
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        currentTask?.cancel()
        
        guard let request = getImagesListRequest(page: lastLoadedPage) else {
            assertionFailure("\(NetworkError.urlSessionError)")
            return
        }
        
        currentTask = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult],Error>) in
            guard let self else { return }
            currentTask = nil
            switch result {
            case .success(let photoResults):
                photoResults.forEach {
                    self.photos.append(
                        Photo(
                            id: $0.id,
                            size: CGSize(width: $0.width, height: $0.height),
                            createdAt: $0.createdAt?.formatISODateString(),
                            welcomeDescription: $0.description,
                            thumbImageURL: $0.urls.thumb ?? "",
                            largeImageURL: $0.urls.full ?? "",
                            isLiked: $0.likedByUser)
                    )
                }
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["photos": photos]
                )
                lastLoadedPage += 1
            case .failure(let error):
                print(error)
            }
        }
        currentTask?.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        currentTask?.cancel()
        
        let request = isLike ? likeRequest(photoId: photoId) : dislikeRequest(photoId: photoId)
        guard let request else {
            assertionFailure("\(NetworkError.urlSessionError)")
            return
        }
        currentTask = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResponse, Error>) in
            guard let self else { return }
            currentTask = nil
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    self.photos[index] = newPhoto
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        currentTask?.resume()
    }
    
}

private extension ImagesListService {
    func getImagesListRequest(page: Int, perPage: Int = 10) -> URLRequest? {
        let path: String = "/photos?"
        + "page=\(page)"
        + "&per_page=\(perPage)"
        + "&order_by=relevant"
        + "&collections=11649432"
        return URLRequest.makeHTTPRequest(
            path: path,
            httpMethod: .GET)
    }
    
    func likeRequest(photoId: String) -> URLRequest? {
        let path = "/photos/\(photoId)/like"
        return URLRequest.makeHTTPRequest(
            path: path,
            httpMethod: .POST
        )
    }
    
    func dislikeRequest(photoId: String) -> URLRequest? {
        let path = "/photos/\(photoId)/like"
        return URLRequest.makeHTTPRequest(
            path: path,
            httpMethod: .DELETE
        )
    }
}

