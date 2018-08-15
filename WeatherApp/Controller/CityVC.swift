import UIKit

class CityVC: UIViewController {
    
    let currentWeatherVC: CurrentWeatherVC
    let dailyForecastVC: PeriodicForecastCVC
    let hourlyForecastVC: PeriodicForecastCVC
    let periodControl = PeriodSelector(leftButtonTitle: "Hourly", rightButtonTitle: "Daily")
    
    let currentWeatherAPI: API
    let hourlyForecastAPI: API
    let dailyForecastAPI: API
    
    init(currentWeatherAPI: API, hourlyForecastAPI: API, dailyForecastAPI: API, coordinates: (Int, Int)) {
        self.currentWeatherAPI = currentWeatherAPI
        self.hourlyForecastAPI = hourlyForecastAPI
        self.dailyForecastAPI = dailyForecastAPI

        currentWeatherVC = CurrentWeatherVC(for: currentWeatherAPI, withCoordinates: coordinates)
        hourlyForecastVC = PeriodicForecastCVC(for: hourlyForecastAPI, period: .Hourly, withCoordinates: coordinates, collectionViewLayout: UICollectionViewFlowLayout())
        dailyForecastVC = PeriodicForecastCVC(for: dailyForecastAPI, period: .Daily, withCoordinates: coordinates, collectionViewLayout: UICollectionViewFlowLayout())
        
        super.init(nibName:nil, bundle:nil)
        periodControl.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(dailyForecastVC)
        addChildViewController(hourlyForecastVC)
        addChildViewController(currentWeatherVC)
        
        hourlyForecastVC.collectionView?.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0)
        dailyForecastVC.view.isHidden = true
        dailyForecastVC.collectionView?.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 0)
        setUpViews()
    }

    let periodicForecastBlock: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    private func setUpViews() {
        view.addSubview(currentWeatherVC.view)
        view.addSubview(periodicForecastBlock)
        view.addConstrainsWithFormat(format: "V:|[v0][v1(\(periodicForecastBlockHeight))]|", views: currentWeatherVC.view, periodicForecastBlock)
        view.addConstrainsWithFormat(format: "H:|[v0]|", views: periodicForecastBlock)
        view.addConstrainsWithFormat(format: "H:|[v0]|", views: currentWeatherVC.view)
        
        periodicForecastBlock.addSubview(periodControl)
        periodicForecastBlock.addSubview(dailyForecastVC.view)
        periodicForecastBlock.addSubview(hourlyForecastVC.view)
        // TODO: abstract layout
        view.addConstrainsWithFormat(format: "V:|-15-[v0(40)]-15-[v1]-25-|", views: periodControl, dailyForecastVC.view)
        view.addConstrainsWithFormat(format: "V:|-15-[v0(40)]-15-[v1]-25-|", views: periodControl, hourlyForecastVC.view)
        view.addConstrainsWithFormat(format: "H:|-80-[v0]-80-|", views: periodControl)
        view.addConstrainsWithFormat(format: "H:|[v0]|", views: dailyForecastVC.view)
        view.addConstrainsWithFormat(format: "H:|[v0]|", views: hourlyForecastVC.view)
    }
}

extension CityVC: PeriodSelectorDelegate {
    func leftPeriodTapped() {
        hourlyForecastVC.view.isHidden = false
        dailyForecastVC.view.isHidden = true
    }
    
    func rightPeriodTapped() {
        hourlyForecastVC.view.isHidden = true
        dailyForecastVC.view.isHidden = false
    }
}

extension CityVC {
    private struct SizeRatio {
        static let periodicForecastBlockHeightToBoundsHeight: CGFloat = 0.35
    }
    
    private var periodicForecastBlockHeight: CGFloat {
        return view.bounds.height * SizeRatio.periodicForecastBlockHeightToBoundsHeight
    }
}
