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


// MARK: - Private API

private extension SurveyView {

    private func transition(to state: State) {
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: { 
            self.titleLabel.text = state == .Positive ? self.positiveTitle() : self.negativeTitle()
            }, completion: nil)
        currentState = state
    }
    
    private func positiveTitle() -> String {
        return "Sweet! Can you leave us a quick review?"
    }
    
    private func negativeTitle() -> String {
        return "Yikes, sorry! Will you tell us what could be better?"
    }
    
}
