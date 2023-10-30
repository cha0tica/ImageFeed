//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Agata on 16.08.2023.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: .none
        )
        
        present(share, animated: true)
    }
    
    private var image: UIImage?
    private var alertPresenter: AlertPresenterProtocol?
    
    var fullScreenImageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showFullScreenImage()
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
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
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showFullScreenImage() {
        guard let url = URL(string: fullScreenImageURL ?? "") else { return }
        UIBlockingProgressHUD.show()
        imageView?.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                UIBlockingProgressHUD.dismiss()
                self.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

private extension SingleImageViewController {
    func showAlert() {
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Попробовать еще раз?",
            firstButtonText: "Повторить",
            secondButtonText: "Не надо",
            firstButtonCompletion: {
                self.showFullScreenImage()
            },
            secondButtonCompletion: {})
        self.alertPresenter?.showAlert(alertModel)
    }
}
