//
//  DataService.swift
//  ImageFeed
//
//  Created by Agata on 29.09.2023.
//

import Foundation

class DateService {
    static let shared = DateService()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "d MMMM y"
        return formatter
    }()
    
    private let dateFormatterIso = ISO8601DateFormatter()
    
    //MARK: - Initialization
    private init() { }
    
    func dateFromString(str: String?) -> Date {
        guard let str = str,
              let date = dateFormatterIso.date(from: str) else {
            return Date()
        }
        return date
    }
    
    func stringFromDate(date: Date?) -> String {
        guard let date = date else {
            return dateFormatter.string(from: Date())
        }
        return dateFormatter.string(from: date)
    }
}
