//
//  Colors.swift
//  ImageFeed
//
//  Created by Agata on 27.09.2023.
//

import Foundation
import UIKit

extension UIColor {
    static let ypRed: UIColor = {
        if let redColor = UIColor(named: "Colors.YP Red") {
            return redColor
        } else {
            return UIColor.red // Цвет по умолчанию, если цвет с именем "YP Red" не удалось загрузить
        }
    }()
    
    static let ypWhite: UIColor = {
        if let whiteColor = UIColor(named: "Colors.YP White") {
            return whiteColor
        } else {
            return UIColor.white // Цвет по умолчанию, если цвет с именем "YP White" не удалось загрузить
        }
    }()
    
    static let ypGray: UIColor = {
        if let grayColor = UIColor(named: "Colors.YP Gray") {
            return grayColor
        } else {
            return UIColor.gray // Цвет по умолчанию, если цвет с именем "YP Gray" не удалось загрузить
        }
    }()
}
