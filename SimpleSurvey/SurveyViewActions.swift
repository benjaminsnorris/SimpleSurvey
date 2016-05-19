//
//  SurveyViewActions.swift
//  SimpleSurvey
//
//  Created by Ben Norris on 5/18/16.
//  Copyright © 2016 BSN Design. All rights reserved.
//

import UIKit
import SettingsActions
import MessageUI

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
            delegate?.didRateApp()
        case .Share:
            guard let viewController = viewController, iTunesItemIdentifier = iTunesItemIdentifier, appStorePath = appStorePath else { fatalError() }
            settingsActionService.shareApp(fromViewController: viewController, appStoreAppPath: appStorePath)
            currentState = .Initial
            delegate?.didShareApp()
        case .Feedback:
            guard let viewController = viewController, feedbackEmail = feedbackEmail else { fatalError() }
            settingsActionService.sendFeedback(fromViewController: viewController, emailAddresses: [feedbackEmail], mailComposeDelegate: self)
            currentState = .Initial
            delegate?.didSendFeedback()
        }
    }
    
    func negativeButtonTouched() {
        switch currentState {
        case .Initial:
            transition(to: .Feedback)
        case .Rate, .Share, .Feedback:
            delegate?.didDeclineSurvey()
            currentState = .Initial
        }
    }
    
    func transition(to state: State) {
        currentState = state
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
    }
    
    func initialTitle() -> String {
        return "Are you happy with this app?"
    }
    
    func rateTitle() -> String {
        return "Sweet! Will you kindly leave us a review?"
    }
    
    func feedbackTitle() -> String {
        return "Uh oh! Could you tell us what’s going on?"
    }
    
    func shareTitle() -> String {
        return "Great! Would you share the app with your friends?"
    }
    
    func positiveButtonTitle() -> String {
        return "YES"
    }
    
    func negativeButtonTitle() -> String {
        switch currentState {
        case .Initial:
            return "NO"
        default:
            return "NOT NOW"
        }
    }
    
}


// MARK: - Mail compose delegate

extension SurveyView: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        guard let viewController = viewController else { fatalError() }
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
