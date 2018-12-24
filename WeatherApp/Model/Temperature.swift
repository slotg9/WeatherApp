import Foundation

struct Temperature {
    
    static private var appScaleSetting = Scale.celsius
    
    var value: Double {
        switch scale {
        case .celsius:
            return celsius
        case .kelvin:
            return kelvin
        case .fahrenheit:
            return fahrenheit
        }
    }
    private var scale: Scale = Temperature.appScaleSetting
    
    private var celsius: Double = 0
    private var kelvin: Double {
        get {
            return celsius + 273.15
        }
        set {
            celsius = newValue - 273.15
        }
    }
    private var fahrenheit: Double {
        get {
            return celsius*(9/5) + 32
        }
        set {
            celsius = (newValue - 32)*(5/9)
        }
    }
    
    init(_ value: Double, in scale: Scale) {
        switch scale {
        case .celsius:
            celsius = value
        case .kelvin:
            kelvin = value
        case .fahrenheit:
            fahrenheit = value
        }
    }
}

extension Temperature {
    enum Scale {
        case celsius
        case kelvin
        case fahrenheit
    }
}

extension Temperature: CustomStringConvertible {
    var description: String {
        return "\(String(format:"%.0f", value))°"
    }
}
