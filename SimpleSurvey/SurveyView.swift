/*
 |  _   ____   ____   _
 | ⎛ |‾|  ⚈ |-| ⚈  |‾| ⎞
 | ⎝ |  ‾‾‾‾| |‾‾‾‾  | ⎠
 |  ‾        ‾        ‾
 */

import UIKit
import SettingsActions

public protocol SurveyViewDelegate {
    func didDeclineSurvey()
    func didSendFeedback()
    func didRateApp()
    func didShareApp()
}

@IBDesignable public class SurveyView: UIView {
    
    // MARK: - Public properties
    
    public var viewController: UIViewController?
    public var delegate: SurveyViewDelegate?
    public var iTunesItemIdentifier: Int?
    public var appStorePath: String?
    public var feedbackEmail: String?
    public var preferToRate = true
    
    
    // MARK: - Inspectable properties
    
    /// Text color for title label
    @IBInspectable public var titleTextColor: UIColor = .black {
        didSet {
            updateColors()
        }
    }
    
    /// Text color for buttons
    @IBInspectable public var buttonTextColor: UIColor = .white {
        didSet {
            updateColors()
        }
    }
    
    
    @IBInspectable public var lightBackground: Bool = true {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 4.0 {
        didSet {
            updateCorners()
        }
    }
    
    @IBInspectable public var titleFont: UIFont = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightMedium) {
        didSet {
            updateFonts()
        }
    }
    
    @IBInspectable public var buttonFont: UIFont = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBold) {
        didSet {
            updateFonts()
        }
    }
    
    
    // MARK: - Internal properties
    
    var settingsActionService = SettingsActionService()
    var titleLabel = UILabel()
    var buttonOne = UIButton(type: .system)
    var buttonTwo = UIButton(type: .system)
    var currentState = State.initial
    var internalStackView = UIStackView()

    enum State {
        case initial
        case rate
        case feedback
        case share
    }
    
    
    // MARK: - Private properties
    
    fileprivate let mainStackView = UIStackView()
    fileprivate let buttonStackView = UIStackView()
    fileprivate var blurredBackground: UIVisualEffectView!
    fileprivate var vibrancyView: UIVisualEffectView!
    
    
    // MARK: - Constants
    
    static fileprivate let maxWidth: CGFloat = 350.0
    static fileprivate let outerMargin: CGFloat = 6.0
    static fileprivate let internalMargin: CGFloat = 6.0
    static fileprivate let buttonHeight: CGFloat = 44.0
    
    
    // MARK: - Lifecycle overrides
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    public override func tintColorDidChange() {
        updateColors()
    }

}


// MARK: - Private functions

fileprivate extension SurveyView {
    
    fileprivate func updateColors() {
        titleLabel.textColor = titleTextColor
        updateColors(buttonOne)
        updateColors(buttonTwo)
        let newBlur = UIBlurEffect(style: lightBackground ? .light : .dark)
        blurredBackground.effect = newBlur
        vibrancyView.effect = UIVibrancyEffect(blurEffect: newBlur)
    }
    
    fileprivate func updateColors(_ button: UIButton) {
        button.backgroundColor = tintColor
        button.setTitleColor(buttonTextColor, for: UIControlState())
    }
    
    fileprivate func updateCorners() {
        updateCorners(buttonOne)
        updateCorners(buttonTwo)
    }
    
    fileprivate func updateCorners(_ button: UIButton) {
        button.layer.cornerRadius = cornerRadius
    }
    
    fileprivate func updateFonts() {
        updateFont(buttonOne)
        updateFont(buttonTwo)
        titleLabel.font = titleFont
    }
    
    fileprivate func updateFont(_ button: UIButton) {
        button.titleLabel?.font = buttonFont
    }
    
    fileprivate func setupViews() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffect = UIBlurEffect(style: lightBackground ? .light : .dark)
        blurredBackground = UIVisualEffectView(effect: blurEffect)
        addSubview(blurredBackground)
        blurredBackground.translatesAutoresizingMaskIntoConstraints = false
        blurredBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        blurredBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurredBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        blurredBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        blurredBackground.contentView.addSubview(mainStackView)
        let mainLeading = mainStackView.leadingAnchor.constraint(equalTo: blurredBackground.leadingAnchor, constant: SurveyView.outerMargin)
        mainLeading.priority = UILayoutPriorityDefaultHigh
        mainLeading.isActive = true
        let mainTrailing = mainStackView.trailingAnchor.constraint(equalTo: blurredBackground.trailingAnchor, constant: -SurveyView.outerMargin)
        mainTrailing.priority = UILayoutPriorityDefaultHigh
        mainTrailing.isActive = true
        mainStackView.topAnchor.constraint(equalTo: blurredBackground.topAnchor, constant: SurveyView.outerMargin).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: blurredBackground.bottomAnchor, constant: -SurveyView.outerMargin).isActive = true
        mainStackView.widthAnchor.constraint(lessThanOrEqualToConstant: SurveyView.maxWidth).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: blurredBackground.centerXAnchor).isActive = true
        
        mainStackView.spacing = SurveyView.internalMargin
        mainStackView.axis = .vertical
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        mainStackView.addArrangedSubview(vibrancyView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.contentView.addSubview(titleLabel)

        titleLabel.leadingAnchor.constraint(equalTo: vibrancyView.contentView.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: vibrancyView.contentView.topAnchor, constant: SurveyView.internalMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: vibrancyView.contentView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: vibrancyView.contentView.bottomAnchor, constant: -SurveyView.internalMargin).isActive = true
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        titleLabel.text = initialTitle()
        
        mainStackView.addArrangedSubview(internalStackView)
        internalStackView.axis = .horizontal
        internalStackView.distribution = .fillEqually
        internalStackView.spacing = SurveyView.internalMargin
        internalStackView.heightAnchor.constraint(equalToConstant: SurveyView.buttonHeight).isActive = true
        
        internalStackView.addArrangedSubview(buttonOne)
        buttonOne.setTitle(negativeButtonTitle(), for: UIControlState())
        buttonOne.addTarget(self, action: #selector(negativeButtonTouched), for: .touchUpInside)
        
        internalStackView.addArrangedSubview(buttonTwo)
        buttonTwo.setTitle(positiveButtonTitle(), for: UIControlState())
        buttonTwo.addTarget(self, action: #selector(positiveButtonTouched), for: .touchUpInside)
        
        updateColors()
        updateCorners()
        updateFonts()
    }
    
}
