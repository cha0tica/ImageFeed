//
//  FormattedString.swift
//  ImageFeed
//
//  Created by Agata on 31.10.2023.
//

import Foundation

extension String {
    public func formatISODateString() -> String? {
        var formatDate = self
        let isoDateFormatter = ISO8601DateFormatter()
        if let date = isoDateFormatter.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            formatDate = dateFormatter.string(from: date)
        }
        return formatDate
    }
}
