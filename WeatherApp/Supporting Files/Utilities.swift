import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String : UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension Data {
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

extension Date {
    func formatForCurrentLocale(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}













