//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Agata on 10.06.2023.
//

import Foundation
import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    static let reuseIdentifier = "ImagesListCell"
    private var isLiked = false
    
    weak var delegate: ImagesListCellDelegate?
    
    override func layoutSubviews() {
        backgroundLabel.layer.sublayers = nil
        setupGradient()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundLabel.layer.sublayers = nil
        cellImage?.kf.cancelDownloadTask()
    }
}

extension ImagesListCell {
    func configure(with photo: Photo, completion: @escaping (Result<Void, Error>) -> Void) {
        selectionStyle = .none
        configurateCellImage(with: photo, completion: completion)
        configurePhotoLikeButton(photo)
        configureDateLabel(with: photo)
    }
    
    func updateLikeImage() {
        likeButton.setImage(getLikeImage(), for: .normal)
    }
}

private extension ImagesListCell {
    func configurePhotoLikeButton(_ photo: Photo) {
        self.isLiked = photo.isLiked
        likeButton.setImage(getLikeImage(), for: .normal)
    }
    
    func configureDateLabel(with photo: Photo) {
        dateLabel.text = photo.createdAt ?? ""
    }
    
    func configurateCellImage(with photo: Photo, completion: @escaping (Result<Void, Error>) -> Void) {
        let placeholder = UIImage(named: "image_list_cell_stub") ?? UIImage()
        
        cellImage?.kf.indicatorType = .activity
        cellImage?.layer.cornerRadius = 16
        cellImage?.layer.masksToBounds = true
        cellImage?.image = placeholder
        
        guard let url = URL(string: photo.thumbImageURL) else {
            print("🔴 ERROR configure list cell")
            return
        }
        cellImage?.kf.setImage(with: url, placeholder: placeholder, completionHandler: (
            { result in
                switch result {
                case .success(_):
                    completion(.success(()))
                case.failure(let error):
                    completion(.failure(error))
                }
            }))
    }
    
    func setupGradient() {
        let height = backgroundLabel.bounds.height
        let width = backgroundLabel.bounds.width
        
        let colorTop = UIColor.black.withAlphaComponent(0.0).cgColor
        let colorBottom = UIColor.black.withAlphaComponent(0.4).cgColor
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x:0, y:0, width: width, height: height)
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        backgroundLabel.layer.addSublayer(gradient)
    }
    
    func getLikeImage() -> UIImage? {
        return isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
    }
}
