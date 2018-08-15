import Foundation

class APIService {
    private var errorMessage = ""
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    func getData(from url: URL, completion: @escaping (Data, String) -> ()) {
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(data, self.errorMessage)
                }
            }
        }
        dataTask?.resume()
    }
}
