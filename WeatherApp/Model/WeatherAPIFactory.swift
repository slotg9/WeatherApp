import Foundation

enum API {
    case openWeather
}

enum Period {
    case hourly
    case daily
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
        // TODO: abstract API keys
        case .openWeather: return URL(string: "https://api.openweathermap.org/data/2.5/" + "weather?lat=\(coord.0)&lon=\(coord.1)&appid=" + "219e59da27c670ea49ebd68d4ad2539f")!
        }
    }
    
    static func createModel(for API: API) -> CurrentWeatherProtocol {
        switch API {
        case .openWeather: return CurrentWeatherFromOpenWeatherAPI()
        }
    }
}

struct PeriodicForecastServiceFactory: PeriodicWeatherFactory {
    static func createURL(for API: API, period: Period, with coord: (Int, Int)) -> URL {
        switch API {
        case .openWeather:
            switch period {
            case .hourly: return URL(string: "https://api.openweathermap.org/data/2.5/" + "forecast?lat=\(coord.0)&lon=\(coord.1)&appid=" + "219e59da27c670ea49ebd68d4ad2539f")!
            case .daily: return URL(string: "https://api.openweathermap.org/data/2.5/" + "forecast?lat=\(coord.0)&lon=\(coord.1)&appid=" + "219e59da27c670ea49ebd68d4ad2539f")!
            }
        }
    }
    
    static func createModel(for API: API, period: Period) -> PeriodicForecastProtocol {
        switch API {
        case .openWeather:
            switch period {
            case .hourly: return HourlyForecastFromOpenWeatherAPI()
            case .daily: return DailyForecastFromOpenWeatherAPI()
            }
        }
    }
    

}
