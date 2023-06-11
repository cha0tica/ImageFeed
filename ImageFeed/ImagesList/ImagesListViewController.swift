//
//  ViewController.swift
//  ImageFeed
//
//  Created by Agata on 31.05.2023.
//

import UIKit

class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    
    //для форматирования даты
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    //создаем массив чисел от 0 до 19 и возвращает массив строк - это имена картинок
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let notLiked = indexPath.row % 2 != 0 //вычисляем нечетные картинки и говорим, что они не полайканы
        let likeImage = notLiked ? UIImage(named: "No_Like") : UIImage(named: "Like") //если нечетный, то сердечко не активно, иначе активно
        cell.likeButton.setImage(likeImage, for: .normal) //устанавливаем на иконку то, что вычислили выше
    }
}

extension ImagesListViewController: UITableViewDelegate {
    //в ответе за тапы по ячейке
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //в ответе за высоту ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    //количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count //ячеек столько, сколько картинок
    }
    
    //возвращаем ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //включаем переиспользование ячеек
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
                
                guard let imageListCell = cell as? ImagesListCell else {
                    return UITableViewCell()
                }
                
        configCell(for: imageListCell, with: indexPath)
                return imageListCell
    }
    

    
}
