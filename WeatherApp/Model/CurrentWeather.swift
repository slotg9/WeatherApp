import Foundation


struct CurrentWeatherFromOpenWeatherAPI: CurrentWeatherProtocol {
    var temperature: String = ""
    var condition: String = ""
    
    mutating func updateWithData(_ data: Data){
        if let weather = data.decodeJSON(with: JSONDecodable.self) {
            // TODO: redo temperature scale logic to add button to change it
            temperature = (weather.main.temp).getTemperatureString(from: .Kelvin)
            condition = weather.weather[0].description.capitalized
        }
    }
    struct JSONDecodable: Decodable {
        var name: String
        var weather: [Weather]
        var main: Main
        
        struct Weather: Decodable {
            var id: Int
            var description: String
        }
        
        struct Main: Decodable {
            var temp: Double
        }
    }
}



