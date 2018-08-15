import Foundation

enum API {
    case OpenWeather
}

enum Period {
    case Hourly
    case Daily
}

protocol CurrentWeatherFactory {
    static func createURL(for API: API, with coord: (Int, Int)) -> URL
    static func createModel(for API: API) -> CurrentWeatherProtocol
}

protocol PeriodicWeatherFactory {
    static func createURL(for API: API, period: Period, with coord: (Int, Int)) -> URL
    static func createModel(for API: API, period: Period) -> PeriodicForecastProtocol
}

struct CurrentWeatherServiceFactory: CurrentWeatherFactory {
    static func createURL(for API: API, with coord: (Int, Int)) -> URL {
        switch API {
        case .OpenWeather: return URL(string: "https://api.openweathermap.org/data/2.5/" + "weather?lat=\(coord.0)&lon=\(coord.1)&appid=" + "219e59da27c670ea49ebd68d4ad2539f")!
        }
    }
    
    static func createModel(for API: API) -> CurrentWeatherProtocol {
        switch API {
        case .OpenWeather: return CurrentWeatherFromOpenWeatherAPI()
        }
    }
}

struct PeriodicForecastServiceFactory: PeriodicWeatherFactory {
    static func createURL(for API: API, period: Period, with coord: (Int, Int)) -> URL {
        switch API {
        case .OpenWeather:
            switch period {
            case .Hourly: return URL(string: "https://api.openweathermap.org/data/2.5/" + "forecast?lat=\(coord.0)&lon=\(coord.1)&appid=" + "219e59da27c670ea49ebd68d4ad2539f")!
            case .Daily: return URL(string: "https://api.openweathermap.org/data/2.5/" + "forecast?lat=\(coord.0)&lon=\(coord.1)&appid=" + "219e59da27c670ea49ebd68d4ad2539f")!
            }
        }
    }
    
    static func createModel(for API: API, period: Period) -> PeriodicForecastProtocol {
        switch API {
        case .OpenWeather:
            switch period {
            case .Hourly: return HourlyForecastFromOpenWeatherAPI()
            case .Daily: return DailyForecastFromOpenWeatherAPI()
            }
        }
    }
    

}
