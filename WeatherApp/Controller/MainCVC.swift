import UIKit
import CoreLocation

private let reuseIdentifier = "Cell"

class MainCVC: UICollectionViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    
    // MARK: - Initialization
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLocationManager()
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.contentInset.top = -UIApplication.shared.statusBarFrame.height
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func setUpLocationManager() {
        // TODO: link to settings on second launch witout permission
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse: self.collectionView?.reloadData()
        // TODO: other cases
        default: break
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MainCVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        var currentLocation: CLLocation
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            currentLocation = locationManager.location ?? CLLocation(latitude: 0, longitude: 0)
        } else {
            // TODO: cell with message about permission?
            return cell
        }
        
        let cityVC = CityVC(currentWeatherAPI: API.openWeather,
                            hourlyForecastAPI: API.openWeather,
                            dailyForecastAPI: API.openWeather,
                            coordinates: (Int(currentLocation.coordinate.latitude), Int(currentLocation.coordinate.longitude)) )
        self.addChildViewController(cityVC)
        cell.contentView.addSubview(cityVC.view)
        cityVC.view.frame = cell.contentView.frame
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainCVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
