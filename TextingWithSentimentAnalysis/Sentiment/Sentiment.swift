//
//  Sentiment.swift
//  TextingWithSentimentAnalysis
//
//  Created by Prudhvi Gadiraju on 7/23/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit

enum Sentiment {
    case neutral
    case positive
    case negative
    
    var emoji: String {
        switch self {
        case .neutral:
            return "😐"
        case .positive:
            return "😃"
        case .negative:
            return "😔"
        }
    }
    
    var color: UIColor? {
        switch self {
        case .neutral:
            return .gray
        case .positive:
            return .blue
        case .negative:
            return .red
        }
    }
}
