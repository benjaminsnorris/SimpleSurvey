//
//  SurveyViewActions.swift
//  SimpleSurvey
//
//  Created by Ben Norris on 5/18/16.
//  Copyright © 2016 BSN Design. All rights reserved.
//

import UIKit
import SettingsActions

// MARK: - Public API

public extension SurveyView {
    
}


// MARK: - Internal API

extension SurveyView {
    
    func positiveButtonTouched() {
        switch currentState {
        case .Initial:
            transition(to: settingsActionService.canRateApp() && preferToRate ? .Rate : .Share)
        case .Rate:
            guard let viewController = viewController, iTunesItemIdentifier = iTunesItemIdentifier else { fatalError() }
            settingsActionService.rateApp(fromViewController: viewController, iTunesItemIdentifier: iTunesItemIdentifier)
            currentState = .Initial
            delegate?.hideSurveyView()
        case .Share:
            guard let viewController = viewController, iTunesItemIdentifier = iTunesItemIdentifier, appStorePath = appStorePath else { fatalError() }
            settingsActionService.shareApp(fromViewController: viewController, appStoreAppPath: appStorePath)
            currentState = .Initial
            delegate?.hideSurveyView()
        case .Feedback:
            print("feedback")
            currentState = .Initial
            delegate?.hideSurveyView()
        }
    }
    
    func negativeButtonTouched() {
        switch currentState {
        case .Initial:
            transition(to: .Feedback)
        case .Rate, .Share, .Feedback:
            delegate?.hideSurveyView()
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
                switch state {
                case .Rate:
                    self.titleLabel.text = self.rateTitle()
                case .Feedback:
                    self.titleLabel.text = self.feedbackTitle()
                case .Share:
                    self.titleLabel.text = self.shareTitle()
                case .Initial:
                    self.titleLabel.text = self.initialTitle()
                }
                self.titleLabel.hidden = false
                self.internalStackView.hidden = false
            }) { complete in
                self.buttonOne.setTitle(self.negativeButtonTitle(), forState: .Normal)
                self.buttonTwo.setTitle(self.positiveButtonTitle(), forState: .Normal)
            }
        }
        currentState = state
    }
    
    func initialTitle() -> String {
        return "Are you happy with this app?"
    }
    
    func rateTitle() -> String {
        return "Sweet! Can you leave us a quick review?"
    }
    
    func feedbackTitle() -> String {
        return "Yikes, sorry! Will you tell us what could be better?"
    }
    
    func shareTitle() -> String {
        return "Great! Would you like to share the app with your friends?"
    }
    
    func positiveButtonTitle() -> String {
        return "YES"
    }
    
    func negativeButtonTitle() -> String {
        return "NO"
    }
    
}
