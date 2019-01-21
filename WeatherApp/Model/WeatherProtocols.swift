import Foundation

// TODO: rethink protocol naming
protocol HasTemperature {
    var temperature: String { get }
}

protocol HasCondition {
    var condition: String { get }
}

protocol HasImgForCondition {
    var conditionImgName: String { get }
}

protocol HasTime {
    var time: String { get }
}

protocol HasTemperatureStruct {
    var temp: Temperature? { get }
}

protocol UpdatableWithData {
    mutating func updateWithData(_ data: Data)
}

protocol CurrentWeatherProtocol: HasTemperature, HasCondition, UpdatableWithData, HasTemperatureStruct {
    
}

protocol PeriodicForecastInstanceProtocol: HasTime, HasImgForCondition, HasTemperature, HasTemperatureStruct {
    
}

protocol PeriodicForecastProtocol: UpdatableWithData {
    var priodicForecats: [PeriodicForecastInstanceProtocol] { get }
}

extension HasTemperature where Self: HasTemperatureStruct {
    var temperature: String {
        guard let temp = temp else {return ""}
        return String.init(describing: temp)
    }
}
