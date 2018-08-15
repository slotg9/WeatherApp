import UIKit

extension UIView {
    //rename t
    func addConstrainsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String : UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}



extension Data {
    //todo error
    func decodeJSON<T: Decodable>(with type: T.Type) -> T? {
        let JSON = try? JSONDecoder().decode(type, from: self)
        return JSON
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    func addWithFrame(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
        child.view.frame = view.frame
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}

extension Double {
    func kelvinToCelsius() -> Double {
        return self - 273.15
    }
    func kelvinToFahrenheit() -> Double {
        return self*(9/5) - 459.67
    }
    
    func getTemperatureString(from scale: TemperatureScale) -> String {
        switch scale {
        case .Kelvin:
            switch TEMPERATURE_SCALE_SETTING {
            case .Kelvin:
                return "\(String(format:"%.0f", self))°"
            case .Celsius :
                return "\(String(format:"%.0f", self.kelvinToCelsius()))°"
            case .Fahrenheit:
                return "\(String(format:"%.0f", self.kelvinToCelsius()))°"
            }
        default:
            return "functionality not implemented"
        }
    }
}

extension Double {
    func getTimeStringFromUnixDate(withFormat format: String) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format //Specify your format that you want
        return dateFormatter.string(from: date)
    }
}

extension Date {
    func formatForCurrentLocale(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}













