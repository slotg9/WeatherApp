import Foundation

class APIService {
    private var errorMessage = ""
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }
        dataTask?.resume()
    }
}
