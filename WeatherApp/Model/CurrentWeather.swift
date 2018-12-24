import Foundation


struct CurrentWeatherFromOpenWeatherAPI: CurrentWeatherProtocol {
    var temp: Temperature?
    var temperature: String {
        guard let temp = temp else {return ""}
        return String.init(describing: temp)
    }
    var condition: String = ""
    
    mutating func updateWithData(_ data: Data){
        if let weather = data.decodeJSON(with: JSONDecodable.self) {
            // TODO: redo temperature scale logic to add button to change it
            temp = Temperature(weather.main.temp, in: .kelvin)
            condition = weather.weather[0].description.capitalized
        }
    }
    private struct JSONDecodable: Decodable {
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



