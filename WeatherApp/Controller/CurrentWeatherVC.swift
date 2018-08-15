import UIKit
class CurrentWeatherVC: UIViewController {

    let apiService = APIService()
    let weatherURL: URL
    var weatherModel: CurrentWeatherProtocol
    
    init(for API: API, withCoordinates coord: (Int, Int)) {
        weatherURL = CurrentWeatherServiceFactory.createURL(for: API, with: coord)
        weatherModel = CurrentWeatherServiceFactory.createModel(for: API)
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewsFromModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let loadingViewController = LoadingViewController()
        addWithFrame(loadingViewController)
        
        apiService.getData(from: weatherURL) { [unowned self] (data, errorMessage) in
            loadingViewController.remove()
            self.weatherModel.updateWithData(data)
            self.updateViewsFromModel()
            if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
        }

    }
    
    func updateViewsFromModel() {
        currentView.configure(temperature: weatherModel.temperature, condition: weatherModel.condition)
    }

}

extension CurrentWeatherVC {
    override func loadView() {
        view = CurrentWeatherView()
    }

    var currentView: CurrentWeatherView {
        return view as! CurrentWeatherView
    }
}
