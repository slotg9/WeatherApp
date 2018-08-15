import UIKit

class CurrentWeatherView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        temperatureLabel.font = UIFont(name: "Heiti TC", size: temperatureLabelFontSize)
        conditionLabel.font = UIFont(name: "Heiti TC", size: conditionLabelFontSize)
    }
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 0)
        label.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 0)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    func setUpViews() {
        addSubview(temperatureLabel)
        addSubview(conditionLabel)
        addConstrainsWithFormat(format: "H:|[v0]|", views: temperatureLabel)
        addConstrainsWithFormat(format: "H:|[v0]|", views: conditionLabel)
        addConstrainsWithFormat(format: "V:|-115-[v0][v1]-(>=10)-|", views: temperatureLabel, conditionLabel)
    }
    
    func configure(temperature: String, condition: String) {
        temperatureLabel.text = temperature
        conditionLabel.text = condition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CurrentWeatherView {
    private struct SizeRatio {
        static let temperatureLabelFontSizeToBoundsHeight: CGFloat = 0.275
        static let conditionLabelFontSizeToBoundsHeight: CGFloat = 0.1
    }
    
    private var temperatureLabelFontSize: CGFloat {
        return bounds.height * SizeRatio.temperatureLabelFontSizeToBoundsHeight
    }
    private var conditionLabelFontSize: CGFloat {
        return bounds.height * SizeRatio.conditionLabelFontSizeToBoundsHeight
    }
}
