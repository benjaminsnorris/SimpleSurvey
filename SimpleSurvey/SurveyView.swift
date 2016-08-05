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
    @IBInspectable public var titleTextColor: UIColor = .black() {
        didSet {
            updateColors()
        }
    }
    
    /// Text color for buttons
    @IBInspectable public var buttonTextColor: UIColor = .white() {
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
    
    private let mainStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private var blurredBackground: UIVisualEffectView!
    private var vibrancyView: UIVisualEffectView!
    
    
    // MARK: - Constants
    
    private let maxWidth: CGFloat = 350.0
    private let outerMargin: CGFloat = 6.0
    private let internalMargin: CGFloat = 6.0
    private let buttonHeight: CGFloat = 44.0
    
    
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

private extension SurveyView {
    
    private func updateColors() {
        titleLabel.textColor = titleTextColor
        updateColors(buttonOne)
        updateColors(buttonTwo)
        let newBlur = UIBlurEffect(style: lightBackground ? .light : .dark)
        blurredBackground.effect = newBlur
        vibrancyView.effect = UIVibrancyEffect(blurEffect: newBlur)
    }
    
    private func updateColors(_ button: UIButton) {
        button.backgroundColor = tintColor
        button.setTitleColor(buttonTextColor, for: UIControlState())
    }
    
    private func updateCorners() {
        updateCorners(buttonOne)
        updateCorners(buttonTwo)
    }
    
    private func updateCorners(_ button: UIButton) {
        button.layer.cornerRadius = cornerRadius
    }
    
    private func updateFonts() {
        updateFont(buttonOne)
        updateFont(buttonTwo)
        titleLabel.font = titleFont
    }
    
    private func updateFont(_ button: UIButton) {
        button.titleLabel?.font = buttonFont
    }
    
    private func setupViews() {
        backgroundColor = .clear()
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
