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
    func isAdjustingHeight()
}

@IBDesignable open class SurveyView: UIView {
    
    // MARK: - Public properties
    
    open var viewController: UIViewController?
    open var delegate: SurveyViewDelegate?
    open var iTunesItemIdentifier: Int?
    open var appStorePath: String?
    open var feedbackEmail: String?
    open var preferToRate = true
    open var alreadyRated = false
    
    
    // MARK: - Inspectable properties
    
    /// Text color for title label
    @IBInspectable open var titleTextColor: UIColor = .black {
        didSet {
            updateColors()
        }
    }
    
    /// Text color for buttons
    @IBInspectable open var buttonTextColor: UIColor = .white {
        didSet {
            updateColors()
        }
    }
    
    
    @IBInspectable open var lightBackground: Bool = true {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var cornerRadius: CGFloat = 4.0 {
        didSet {
            updateCorners()
        }
    }
    
    @IBInspectable open var titleFont: UIFont = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightMedium) {
        didSet {
            updateFonts()
        }
    }
    
    @IBInspectable open var buttonFont: UIFont = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBold) {
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
    
    fileprivate let maxWidth: CGFloat = 350.0
    fileprivate let outerMargin: CGFloat = 6.0
    fileprivate let internalMargin: CGFloat = 6.0
    fileprivate let buttonHeight: CGFloat = 44.0
    
    
    // MARK: - Lifecycle overrides
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    open override func tintColorDidChange() {
        updateColors()
    }

}


// MARK: - Private functions

private extension SurveyView {
    
    func updateColors() {
        titleLabel.textColor = titleTextColor
        updateColors(buttonOne)
        updateColors(buttonTwo)
        let newBlur = UIBlurEffect(style: lightBackground ? .light : .dark)
        blurredBackground.effect = newBlur
        vibrancyView.effect = UIVibrancyEffect(blurEffect: newBlur)
    }
    
    func updateColors(_ button: UIButton) {
        button.backgroundColor = tintColor
        button.setTitleColor(buttonTextColor, for: UIControlState())
    }
    
    func updateCorners() {
        updateCorners(buttonOne)
        updateCorners(buttonTwo)
    }
    
    func updateCorners(_ button: UIButton) {
        button.layer.cornerRadius = cornerRadius
    }
    
    func updateFonts() {
        updateFont(buttonOne)
        updateFont(buttonTwo)
        titleLabel.font = titleFont
    }
    
    func updateFont(_ button: UIButton) {
        button.titleLabel?.font = buttonFont
    }
    
    func setupViews() {
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
        let mainLeading = mainStackView.leadingAnchor.constraint(equalTo: blurredBackground.leadingAnchor, constant: outerMargin)
        mainLeading.priority = UILayoutPriorityDefaultHigh
        mainLeading.isActive = true
        let mainTrailing = mainStackView.trailingAnchor.constraint(equalTo: blurredBackground.trailingAnchor, constant: -outerMargin)
        mainTrailing.priority = UILayoutPriorityDefaultHigh
        mainTrailing.isActive = true
        mainStackView.topAnchor.constraint(equalTo: blurredBackground.topAnchor, constant: outerMargin).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: blurredBackground.bottomAnchor, constant: -outerMargin).isActive = true
        mainStackView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: blurredBackground.centerXAnchor).isActive = true
        
        mainStackView.spacing = internalMargin
        mainStackView.axis = .vertical
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        mainStackView.addArrangedSubview(vibrancyView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.contentView.addSubview(titleLabel)

        titleLabel.leadingAnchor.constraint(equalTo: vibrancyView.contentView.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: vibrancyView.contentView.topAnchor, constant: internalMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: vibrancyView.contentView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: vibrancyView.contentView.bottomAnchor, constant: -internalMargin).isActive = true
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        titleLabel.text = initialTitle()
        
        mainStackView.addArrangedSubview(internalStackView)
        internalStackView.axis = .horizontal
        internalStackView.distribution = .fillEqually
        internalStackView.spacing = internalMargin
        internalStackView.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
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
