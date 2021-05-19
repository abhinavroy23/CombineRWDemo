
import Combine
import Foundation
import UIKit

enum ImageDownloader {
  static func download(url: String) -> AnyPublisher<UIImage, GameError> {
    guard let url = URL(string: url) else {
      return Fail(error: GameError.invalidURL)
        .eraseToAnyPublisher()
    }
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { response -> Data in
        guard
          let httpURLResponse = response.response as? HTTPURLResponse,
          httpURLResponse.statusCode == 200
        else {
          throw GameError.statusCode
        }
        
        return response.data
      }.tryMap { data in
        guard let image = UIImage(data: data) else {
          throw GameError.invalidImage
        }
        return image
      }
      .mapError { GameError.map($0) }
      .eraseToAnyPublisher()
  }
}
