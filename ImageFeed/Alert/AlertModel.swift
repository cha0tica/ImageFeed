//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Agata on 27.09.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let firstButtonText: String
    let secondButtonText: String?
    let firstButtonCompletion: () -> Void
    let secondButtonCompletion: () -> Void?
}
