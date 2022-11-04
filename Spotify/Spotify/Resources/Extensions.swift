//
//  Extensions.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/11/22.
//

import Foundation
import UIKit

extension UIView {
    
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var bottom: CGFloat {
        return top + height
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
}

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}

extension String {
    static func formattedDate(string: String) -> String {
        guard let date = DateFormatter.dateFormatter.date(from: string) else {
            print("Date Formatter Failed!")
            return string
        }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
    
}

extension Notification.Name {
    static let savedAlbumNotification = Notification.Name("savedAlbumNotification")
}
