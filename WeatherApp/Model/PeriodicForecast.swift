import Foundation

struct HourlyInstanceForecast: PeriodicForecastInstanceProtocol {
    var time: String
    var conditionImgName: String
    var temperature: String
}

struct HourlyForecastFromOpenWeatherAPI: PeriodicForecastProtocol {
    var priodicForecats = [PeriodicForecastInstanceProtocol]()
    
    mutating func updateWithData(_ data: Data){
        //TODO: handle and/or print decoding errors
        if let forecast = data.decodeJSON(with: JSONDecodable.self) {
            for instance in forecast.list {
                let date = Date(timeIntervalSince1970: instance.dt)
                if Calendar.current.isDateInToday(date) || Calendar.current.isDateInTomorrow(date) {
                    let time = date.formatForCurrentLocale(withFormat: "h:mm a")
                    let imageName = getImageName(for: instance.weather[0].id)
                    let temp = (instance.main.temp).getTemperatureString(from: .Kelvin)
                    priodicForecats.append(HourlyInstanceForecast(time: time, conditionImgName: imageName, temperature: temp))
                }
            }
        }
    }
    
    struct JSONDecodable: Decodable {
        var list: [List]
        
        struct List: Decodable {
            var dt: Double
            var main: Main
            var weather: [Weather]
            
            struct Main: Decodable {
                var temp: Double
            }
            
            struct Weather: Decodable {
                var id: Int
            }
        }
    }
}

struct DailyInstanceForecast: PeriodicForecastInstanceProtocol {
    var time: String
    var conditionImgName: String
    var temperature: String
}

struct DailyForecastFromOpenWeatherAPI: PeriodicForecastProtocol {
    var priodicForecats = [PeriodicForecastInstanceProtocol]()
    
    mutating func updateWithData(_ data: Data){
        if let forecast = data.decodeJSON(with: JSONDecodable.self) {
            for instance in forecast.list {
                let date = Date(timeIntervalSince1970: instance.dt)
                if !Calendar.current.isDateInToday(date) && date.formatForCurrentLocale(withFormat: "HH") == "12"{
                    let time = date.formatForCurrentLocale(withFormat: "EEE")
                    let imageName = getImageName(for: instance.weather[0].id)
                    let temp = (instance.main.temp).getTemperatureString(from: .Kelvin)
                    priodicForecats.append(HourlyInstanceForecast(time: time, conditionImgName: imageName, temperature: temp))
                }
            }
        }
    }
    
    struct JSONDecodable: Decodable {
        var list: [List]
        
        struct List: Decodable {
            var dt: Double
            var main: Main
            var weather: [Weather]
            
            struct Main: Decodable {
                var temp: Double
            }
            
            struct Weather: Decodable {
                var id: Int
            }
        }
    }
}

fileprivate func getImageName(for status: Int) -> String {
    switch status {
    case 200...299:
        return "weather-thunderstorm-icon"
    case 300...399:
        return "weather-drizzle-icon"
    case 500, 501:
        return "weather-drizzle-icon"
    case 502...599:
        return "weather-rain-icon"
    case 600...699:
        return "weather-snow-icon"
    case 700...799:
        return "weather-conditions-icon"
    case 800:
        return "weather-clear-icon"
    case 801:
        return "weather-few-clouds-icon"
    case 802:
        return "weather-clouds-icon"
    case 803, 804:
        return "weather-heavy-clouds-icon"
    default:
        return "weather-few-clouds-icon"
    }
}
