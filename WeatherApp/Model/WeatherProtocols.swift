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

protocol UpdatableWithData {
    mutating func updateWithData(_ data: Data)
}

protocol CurrentWeatherProtocol: HasTemperature, HasCondition, UpdatableWithData {
    
}

protocol PeriodicForecastInstanceProtocol: HasTime, HasImgForCondition, HasTemperature {
    
}

protocol PeriodicForecastProtocol: UpdatableWithData {
    var priodicForecats: [PeriodicForecastInstanceProtocol] { get }
}
