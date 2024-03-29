//
//  HapticManager.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/11/22.
//

import Foundation
import UIKit

final class hapticManager {
    static let shared = hapticManager()
    
    private init(){}
    public func vibrateForSelection(){
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType){
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
