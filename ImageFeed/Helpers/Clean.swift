//
//  Clean.swift
//  ImageFeed
//
//  Created by Agata on 30.10.2023.
//

import Foundation
import WebKit

final class Clean{
    static func cleanCoockies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {}
                )
            }
        }
    }
    
}
