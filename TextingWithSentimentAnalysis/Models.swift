//
//  Models.swift
//  TextingWithSentimentAnalysis
//
//  Created by Prudhvi Gadiraju on 7/24/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import Foundation

enum Models:Int, CustomStringConvertible, CaseIterable {
    case SentimentPolarity
    case SentimentFromReviews
    case SentimentTF
    
    var description: String {
        switch self {
        case .SentimentPolarity: return "Sentiment Polarity"
        case .SentimentFromReviews: return "Sentiment from Reviews"
        case .SentimentTF: return "SentimentTF"
        }
    }
}
