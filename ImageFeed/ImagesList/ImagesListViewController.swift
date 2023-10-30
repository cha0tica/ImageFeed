//
//  ViewController.swift
//  ImageFeed
//
//  Created by Agata on 31.05.2023.
//  Sprint 08

import UIKit

class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imageListService = ImagesListService.shared
    private let service = ImagesListService.shared
    private var photos: [Photo] = []
    
    @IBOutlet private var tableView: UITableView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        UIBlockingProgressHUD.show()
        
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                self.updateTableViewAnimated()
                UIBlockingProgressHUD.dismiss()
            }
        imageListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            if
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            {
                let imageUrl = photos[indexPath.row]
                viewController.fullScreenImageURL = imageUrl.largeImageURL
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }
    }
    
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imageListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        imageListCell.configure(with: photos[indexPath.row]) { result in
            switch result {
            case.success(_):
                tableView.reloadRows(at: [indexPath], with: .fade)
                print(indexPath.row)
            case .failure(_):
                print("❤️")
            }
        }
        return imageListCell
        }
    }

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success():
                self.photos = imageListService.photos
                cell.updateLikeImage()
                self.tableView.reloadRows(at: [indexPath], with: .none)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                print("\(error)")
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

private extension ImagesListViewController {
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map{ i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .fade)
            } completion: { _ in }
        }
    }
}
