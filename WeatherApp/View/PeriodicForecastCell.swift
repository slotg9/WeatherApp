import UIKit

class PeriodicForecastCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setUpViews()
    }
    
    func configureCell (time: String, iconName: String, temperature: String) {
        timeLabel.text = time
        conditionImgView.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        temperatureLabel.text = temperature
    }
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 0)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let conditionImgView: UIImageView = {
        let view = UIImageView()
        view.tintColor = #colorLiteral(red: 0.1960784314, green: 0.6784313725, blue: 0.7137254902, alpha: 1)
        return view
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 0)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private func setUpViews() {
        addSubview(temperatureLabel)
        addSubview(timeLabel)
        addSubview(conditionImgView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: temperatureLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: timeLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: conditionImgView)
        addConstraintsWithFormat(format: "V:|-10-[v0(20)][v1][v2(20)]-10-|", views: timeLabel, conditionImgView, temperatureLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
