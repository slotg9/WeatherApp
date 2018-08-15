import UIKit
import CoreLocation

private let reuseIdentifier = "Cell"

class MainCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // TODO: link to settings on second launch witout permission
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.contentInset.top = -UIApplication.shared.statusBarFrame.height
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse: self.collectionView?.reloadData()
        // TODO: other cases
        default: break
        }
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

}
