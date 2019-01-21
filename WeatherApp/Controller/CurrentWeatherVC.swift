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
        
        apiService.getData(from: weatherURL) { [unowned self] (data, response, error) in
            loadingViewController.remove()
            if let error = error {
                self.handleClientError(error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                self.handleServerError(httpResponse)
                return
            }
            if let data = data {
                self.weatherModel.updateWithData(data)
                self.updateViewsFromModel()
            }
        }

    }
    
    func updateViewsFromModel() {
        currentView.configure(temperature: weatherModel.temperature, condition: weatherModel.condition)
    }

}

extension CurrentWeatherVC {
    func handleClientError(_ error: Error) {
        
    }
    
    func handleServerError(_ response: HTTPURLResponse) {
        
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
