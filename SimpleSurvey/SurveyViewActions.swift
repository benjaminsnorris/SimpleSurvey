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
    
    func transition(to state: State) {
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
            self.titleLabel.hidden = true
            self.internalStackView.hidden = true
            self.buttonOne.setTitle(nil, forState: .Normal)
            self.buttonTwo.setTitle(nil, forState: .Normal)
        }) { complete in
            UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
                self.titleLabel.text = state == .Positive ? self.positiveTitle() : self.negativeTitle()
                self.titleLabel.hidden = false
                self.internalStackView.hidden = false
            }) { complete in
                self.buttonOne.setTitle(self.negativeButtonTitle(), forState: .Normal)
                self.buttonTwo.setTitle(self.positiveButtonTitle(), forState: .Normal)
            }
        }
        currentState = state
    }
    
    func positiveTitle() -> String {
        return "Sweet! Can you leave us a quick review?"
    }
    
    func negativeTitle() -> String {
        return "Yikes, sorry! Will you tell us what could be better?"
    }
    
    func positiveButtonTitle() -> String {
        return "YES"
    }
    
    func negativeButtonTitle() -> String {
        return "NO"
    }
    
}
