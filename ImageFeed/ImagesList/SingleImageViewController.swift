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
            SingleImageViewController.image = image
        }
    }
    
    @IBOutlet weak var SingleImageViewController: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SingleImageViewController.image = image
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
