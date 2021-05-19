
import Combine
import Foundation

enum UnsplashAPI {
  static let accessToken = "EdE1sBz8alENMW4DtUWQF7sv5WGebLCGN3BBEokgBtw"

  static func randomImage() -> AnyPublisher<RandomImageResponse, GameError> {
    let url = URL(string: "https://api.unsplash.com/photos/random/?client_id=\(accessToken)")!

    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.urlCache = nil
    let session = URLSession(configuration: config)

    var urlRequest = URLRequest(url: url)
    urlRequest.addValue("Accept-Version", forHTTPHeaderField: "v1")

    // 1
    return session.dataTaskPublisher(for: urlRequest)
      // 2
      .tryMap { response in
        guard
          // 3
          let httpURLResponse = response.response as? HTTPURLResponse,
          httpURLResponse.statusCode == 200
          else {
            // 4
            throw GameError.statusCode
        }
        // 5
        return response.data
      }
      // 6
      .decode(type: RandomImageResponse.self, decoder: JSONDecoder())
      // 7
      .mapError { GameError.map($0) }
      // 8
      .eraseToAnyPublisher()
  }
}
