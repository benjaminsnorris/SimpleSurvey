//
//  SurveyViewActions.swift
//  SimpleSurvey
//
//  Created by Ben Norris on 5/18/16.
//  Copyright © 2016 BSN Design. All rights reserved.
//

import UIKit

// MARK: - Public API

public extension SurveyView {
    
}


// MARK: - Internal API

extension SurveyView {
    
    func positiveButtonTouched() {
        switch currentState {
        case .Initial:
            transition(to: .Positive)
        case .Positive:
            print("review")
            currentState = .Initial
        case .Negative:
            print("feedback")
            currentState = .Initial
        }
    }
    
    func negativeButtonTouched() {
        switch currentState {
        case .Initial:
            transition(to: .Negative)
        case .Positive:
            print("hide")
            currentState = .Initial
        case .Negative:
            print("hide")
            currentState = .Initial
        }
    }
    
}
