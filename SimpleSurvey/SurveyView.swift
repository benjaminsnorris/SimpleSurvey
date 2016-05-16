/*
 |  _   ____   ____   _
 | ⎛ |‾|  ⚈ |-| ⚈  |‾| ⎞
 | ⎝ |  ‾‾‾‾| |‾‾‾‾  | ⎠
 |  ‾        ‾        ‾
 */

import UIKit

@IBDesignable public class SurveyView: UIView {
    
    // MARK: - Public properties
    
    public var viewController: UIViewController?
    
    
    // MARK: - Inspectable properties
    
    /// Text color for title label
    @IBInspectable public var titleTextColor: UIColor = .blackColor() {
        didSet {
            updateColors()
        }
    }
    
    /// Text color for buttons
    @IBInspectable public var buttonTextColor: UIColor = .whiteColor() {
        didSet {
            updateColors()
        }
    }
    
    
    @IBInspectable public var lightBackground: Bool = true {
        didSet {
            updateColors()
        }
    }
    
    
    // MARK: - Internal properties
    
    var titleLabel = UILabel()
    var buttonOne = UIButton(type: .System)
    var buttonTwo = UIButton(type: .System)
    
    
    // MARK: - Private properties
    
    private let mainStackView = UIStackView()
    private let internalStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private var blurredBackground: UIVisualEffectView!
    
    
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
        updateButtonColors(buttonOne)
        updateButtonColors(buttonTwo)
        blurredBackground.effect = UIBlurEffect(style: lightBackground ? .Light : .Dark)
    }
    
    private func updateButtonColors(button: UIButton) {
        button.backgroundColor = tintColor
        button.setTitleColor(buttonTextColor, forState: .Normal)
    }
    
    private func setupViews() {
        backgroundColor = .clearColor()
        translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffect = UIBlurEffect(style: lightBackground ? .Light : .Dark)
        blurredBackground = UIVisualEffectView(effect: blurEffect)
        addSubview(blurredBackground)
        blurredBackground.translatesAutoresizingMaskIntoConstraints = false
        blurredBackground.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        blurredBackground.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        blurredBackground.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        blurredBackground.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        blurredBackground.contentView.addSubview(mainStackView)
        let mainLeading = mainStackView.leadingAnchor.constraintEqualToAnchor(blurredBackground.leadingAnchor, constant: outerMargin)
        mainLeading.priority = UILayoutPriorityDefaultHigh
        mainLeading.active = true
        let mainTrailing = mainStackView.trailingAnchor.constraintEqualToAnchor(blurredBackground.trailingAnchor, constant: -outerMargin)
        mainTrailing.priority = UILayoutPriorityDefaultHigh
        mainTrailing.active = true
        mainStackView.topAnchor.constraintEqualToAnchor(blurredBackground.topAnchor, constant: outerMargin).active = true
        mainStackView.bottomAnchor.constraintEqualToAnchor(blurredBackground.bottomAnchor, constant: -outerMargin).active = true
        mainStackView.widthAnchor.constraintLessThanOrEqualToConstant(maxWidth).active = true
        mainStackView.spacing = internalMargin
        mainStackView.axis = .Vertical
        
        mainStackView.addArrangedSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.text = "Are you happy with this app?"
        
        mainStackView.addArrangedSubview(internalStackView)
        internalStackView.axis = .Horizontal
        internalStackView.distribution = .FillEqually
        internalStackView.spacing = internalMargin
        internalStackView.heightAnchor.constraintEqualToConstant(buttonHeight).active = true
        
        internalStackView.addArrangedSubview(buttonOne)
        buttonOne.setTitle("No", forState: .Normal)
        
        internalStackView.addArrangedSubview(buttonTwo)
        buttonTwo.setTitle("Yes", forState: .Normal)
        
        updateColors()
    }
    
}
