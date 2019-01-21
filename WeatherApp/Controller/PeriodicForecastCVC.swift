import UIKit

private let reuseIdentifier = "Cell"

class PeriodicForecastCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let weatherURL: URL
    let apiService = APIService()
    var weatherModel: PeriodicForecastProtocol
    
    init(for API: API, period: Period, withCoordinates coord: (Int, Int), collectionViewLayout: UICollectionViewLayout) {
        weatherURL = PeriodicForecastServiceFactory.createURL(for: API, period: period, with: coord)
        weatherModel = PeriodicForecastServiceFactory.createModel(for: API, period: period)
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = cellSpacing
        }
        collectionView?.contentInset = UIEdgeInsetsMake(0, cellSpacing/2, 0, 0)
        
        self.collectionView?.register(PeriodicForecastCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
                self.collectionView?.reloadData()
            }
        }
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherModel.priodicForecats.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PeriodicForecastCell
        cell.configureCell(time: weatherModel.priodicForecats[indexPath.item].time,
                           iconName: weatherModel.priodicForecats[indexPath.item].conditionImgName,
                           temperature: weatherModel.priodicForecats[indexPath.item].temperature)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }

}

extension PeriodicForecastCVC {
    func handleClientError(_ error: Error) {
        
    }
    
    func handleServerError(_ response: HTTPURLResponse) {
        
    }
}

extension PeriodicForecastCVC {
    private struct SizeRatio {
        static let cellToBoundsWidth: CGFloat = 0.2
    }
    
    private var cellWidth: CGFloat {
        return view.bounds.width * SizeRatio.cellToBoundsWidth
    }
    
    private var cellSpacing: CGFloat {
        // TODO: magic number
        return (view.bounds.width - cellWidth * 4)/4
    }

}
