import UIKit

class PeriodSelector: UIView {
    var delegate: PeriodSelectorDelegate?
    var constraintsSetUp = false
    var selectedStateIndicatorLeftConstraint: NSLayoutConstraint? = nil
    var leftButtonTitle: String
    var rightButtonTitle: String
    
    
    init (leftButtonTitle: String, rightButtonTitle: String) {
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        super .init(frame: CGRect.zero)
        clipsToBounds = true
        backgroundColor = ColorScheme.backgrondColor
    }

    override func layoutSubviews() {
        if !constraintsSetUp {
            setUpViews()
            constraintsSetUp = true
        }
        super.layoutSubviews()
    }
    
    private let leftPeriodButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0)
        button.setTitleColor(ColorScheme.selectedFontColor, for: .normal)
        button.addTarget(self, action: #selector(leftButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let rightPeriodButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 0)
        button.setTitleColor(ColorScheme.notSelectedFontColot, for: .normal)
        button.addTarget(self, action: #selector(rightButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let selectedStateIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorScheme.selectorColor
        return view
    }()
    
    @objc func leftButtonTapped(_ sender : UIButton) {
        // TODO: enum on buttons?
        self.leftPeriodButton.setTitleColor(ColorScheme.selectedFontColor, for: .normal)
        leftPeriodButton.isUserInteractionEnabled = false
        self.rightPeriodButton.setTitleColor(ColorScheme.notSelectedFontColot, for: .normal)
        rightPeriodButton.isUserInteractionEnabled = true
        
        selectedStateIndicatorLeftConstraint?.constant = selectedStateIndicatorIndent
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
        
        delegate?.leftPeriodTapped()
    }
    
    @objc func rightButtonTapped(_ sender : UIButton) {
        self.leftPeriodButton.setTitleColor(ColorScheme.notSelectedFontColot, for: .normal)
        leftPeriodButton.isUserInteractionEnabled = true
        self.rightPeriodButton.setTitleColor(ColorScheme.selectedFontColor, for: .normal)
        rightPeriodButton.isUserInteractionEnabled = false
        
        selectedStateIndicatorLeftConstraint?.constant = selectedStateIndicatorIndent * 3 + selectedStateIndicatorWidth
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
        
        delegate?.rightPeriodTapped()
    }

    func setUpViews() {
        addSubview(selectedStateIndicator)
        addConstrainsWithFormat(format: "H:[v0(\(selectedStateIndicatorWidth))]", views: selectedStateIndicator)
        addConstrainsWithFormat(format: "V:|-\(selectedStateIndicatorIndent)-[v0]-\(selectedStateIndicatorIndent)-|", views: selectedStateIndicator)
        selectedStateIndicatorLeftConstraint = selectedStateIndicator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: selectedStateIndicatorIndent)
        addConstraints([selectedStateIndicatorLeftConstraint!])

        addSubview(leftPeriodButton)
        addSubview(rightPeriodButton)
        addConstrainsWithFormat(format: "V:|[v0]|", views: leftPeriodButton)
        addConstrainsWithFormat(format: "V:|[v0]|", views: rightPeriodButton)
        addConstrainsWithFormat(format: "H:|[v0][v1(v0)]|", views: leftPeriodButton, rightPeriodButton)
        
        layer.cornerRadius = cornerRadius
        selectedStateIndicator.layer.cornerRadius = selectedStateIndicatorCornerRadius
        
        leftPeriodButton.setTitle(leftButtonTitle, for: .normal)
        rightPeriodButton.setTitle(rightButtonTitle, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PeriodSelector {
    private struct ColorScheme {
        static let backgrondColor: UIColor = #colorLiteral(red: 0.1960784314, green: 0.6784313725, blue: 0.7137254902, alpha: 1)
        static let selectorColor: UIColor = #colorLiteral(red: 0.8996000886, green: 0.9719153047, blue: 0.9728509784, alpha: 1)
        static let selectedFontColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static let notSelectedFontColot: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}

extension PeriodSelector {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.4
        static let selectedStateIndicatorIndentToBoundsHeight: CGFloat = 0.12
    }
    private var cornerRadius: CGFloat {
        return bounds.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var selectedStateIndicatorCornerRadius: CGFloat {
        return (bounds.height - selectedStateIndicatorIndent * 2) * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var selectedStateIndicatorIndent: CGFloat {
        return bounds.height * SizeRatio.selectedStateIndicatorIndentToBoundsHeight
    }
    private var selectedStateIndicatorWidth: CGFloat {
        return bounds.width/2 - selectedStateIndicatorIndent * 2
    }
}


protocol PeriodSelectorDelegate {
    func leftPeriodTapped () -> ()
    func rightPeriodTapped () -> ()
}
