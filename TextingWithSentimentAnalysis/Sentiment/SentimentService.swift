//
//  SentimentService.swift
//  TextingWithSentimentAnalysis
//
//  Created by Prudhvi Gadiraju on 7/23/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import CoreML

final class SentimentService {
    
    private enum Error: Swift.Error {
        case featuresMissing
    }
    
    private let model = SentimentPolarity()
    private let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
    private let tagScheme: [NSLinguisticTagScheme] = NSLinguisticTagger.availableTagSchemes(forLanguage: "en")
    private lazy var tagger: NSLinguisticTagger = .init(tagSchemes: tagScheme, options: Int(self.options.rawValue))
    
    // MARK: - Prediction
    
    func predictSentiment(of text: String) -> Sentiment {
        do {
            let inputFeatures = features(from: text)
            guard inputFeatures.count > 1 else { throw Error.featuresMissing }
            let output = try model.prediction(input: inputFeatures)
            return process(output)
        } catch {
            return .neutral
        }
    }
    
    private func features(from text: String) -> [String: Double] {
        var wordCounts = [String: Double]()
        
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        
        // Tokenize and count the sentence
        tagger.enumerateTags(in: range, scheme: .nameType, options: options) { _, tokenRange, _, _ in
            let token = (text as NSString).substring(with: tokenRange).lowercased()
            // Skip small words
            guard token.count >= 3 else {
                return
            }
            
            if let value = wordCounts[token] {
                wordCounts[token] = value + 1.0
            } else {
                wordCounts[token] = 1.0
            }
        }
        
        return wordCounts
    }
    
    private func process(_ output: SentimentPolarityOutput) -> Sentiment {
        switch output.classLabel {
        case "Pos":
            return .positive
        case "Neg":
            return .negative
        default:
            return .neutral
        }
    }
}
