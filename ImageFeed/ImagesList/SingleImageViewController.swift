//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Agata on 16.08.2023.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertPresenter = AlertPresenter(delagate: self)
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        UIBlockingProgressHUD.show()
        downloadImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let image = imageView.image {
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        present(activityController, animated: true, completion: nil)
    }
    
    var largeImageURL: URL?
    private var alertPresenter: AlertPresenter?
    private var activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
  
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            
            guard let self = self,
                  let image = self.imageView.image  else {
                return
            }
            
            self.rescaleAndCenterImageInScrollView(image: image)
        }
    }
}

private extension SingleImageViewController {
    
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let halfWidth = (scrollView.bounds.size.width - imageView.frame.size.width) / 2
        let halfHeight = (scrollView.bounds.size.height - imageView.frame.size.height) / 2
        scrollView.contentInset = .init(top: halfHeight, left: halfWidth, bottom: 0, right: 0)
    }
    
    func downloadImage() {
        imageView.kf.setImage(with: largeImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
                case .success(let imageResult):
                    self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                    activityController = UIActivityViewController(
                        activityItems: [imageResult.image as Any],
                        applicationActivities: nil
                    )
                case .failure:
                    self.showError()
            }
        }
    }
    
    func showError() {
        let alert = AlertModel(title: "Что-то пошло не так.",
                               message: "Попробовать ещё раз?",
                               buttonText: "Не надо",
                               firstcompletion: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        },
                               secondButtonText: "Повторить",
                               secondCompletion: { [weak self] in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.show()
            downloadImage()
        })
    
        alertPresenter?.show(alert)
    }
}

extension SingleImageViewController: AlertPresentableDelagate {
    func present(alert: UIAlertController, animated flag: Bool) {
        self.present(alert, animated: flag)
    }
}
