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
        case .initial:
            transition(to: settingsActionService.canRateApp() && preferToRate ? .rate : .share)
        case .rate:
            guard let viewController = viewController, let iTunesItemIdentifier = iTunesItemIdentifier else { fatalError() }
            settingsActionService.rateApp(fromViewController: viewController, iTunesItemIdentifier: iTunesItemIdentifier)
            currentState = .initial
            delegate?.didRateApp()
        case .share:
            guard let viewController = viewController, let appStorePath = appStorePath else { fatalError() }
            settingsActionService.shareApp(fromViewController: viewController, appStoreAppPath: appStorePath)
            currentState = .initial
            delegate?.didShareApp()
        case .feedback:
            guard let viewController = viewController, let feedbackEmail = feedbackEmail else { fatalError() }
            settingsActionService.sendFeedback(fromViewController: viewController, emailAddresses: [feedbackEmail], mailComposeDelegate: self)
            currentState = .initial
            delegate?.didSendFeedback()
        }
    }
    
    func negativeButtonTouched() {
        switch currentState {
        case .initial:
            transition(to: .feedback)
        case .rate, .share, .feedback:
            delegate?.didDeclineSurvey()
            currentState = .initial
        }
    }
    
    func transition(to state: State) {
        currentState = state
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
            self.titleLabel.isHidden = true
            self.internalStackView.isHidden = true
            self.buttonOne.setTitle(nil, for: UIControlState())
            self.buttonTwo.setTitle(nil, for: UIControlState())
        }) { complete in
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
                switch state {
                case .rate:
                    self.titleLabel.text = self.rateTitle()
                case .feedback:
                    self.titleLabel.text = self.feedbackTitle()
                case .share:
                    self.titleLabel.text = self.shareTitle()
                case .initial:
                    self.titleLabel.text = self.initialTitle()
                }
                self.titleLabel.isHidden = false
                self.internalStackView.isHidden = false
            }) { complete in
                self.buttonOne.setTitle(self.negativeButtonTitle(), for: UIControlState())
                self.buttonTwo.setTitle(self.positiveButtonTitle(), for: UIControlState())
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
        case .initial:
            return "NO"
        default:
            return "NOT NOW"
        }
    }
    
}


// MARK: - Mail compose delegate

extension SurveyView: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        guard let viewController = viewController else { fatalError() }
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
