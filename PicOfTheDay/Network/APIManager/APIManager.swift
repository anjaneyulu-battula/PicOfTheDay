//
//  APIManager.swift
//  PicOfTheDay
//
//  Created by Anjaneyulu Battula on 17/03/22.
//

import Foundation
import UIKit

let apiKey = "Abj7HOh4MrE7obNMBgQTyb6AcuqtbldQSfE8ZyAL"

enum PicOfTheDayError: Error {
    case invalidUrl
    case decodeError
    case imageDownloadError
    case failedRequest
    case requestTimedOut
    case saveImageDiskError
    case removeImageError
    case saveOrUpdateDBError
    case unknownError
    case networkError

    var msg: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .decodeError:
            return "Decode Error"
        case .imageDownloadError:
            return "Image Download Error"
        case .failedRequest:
            return "Failed Request"
        case .requestTimedOut:
            return "Request TimedOut"
        case .saveImageDiskError:
            return "Save image to disk Error"
        case .removeImageError:
            return "Remove Image Error"
        case .saveOrUpdateDBError:
            return "DB related Error"
        case .networkError:
            return "Network Error"
        case .unknownError:
            return "unknownError"
        }
    }
}


final class APIManager {

    let session: URLSession!
    private init() {
        session = URLSession(configuration: .default)
    }
    static let shared = APIManager()

    func getPicOfTheDayDataWith(dateStr: String, completion: @escaping (Result<PicOfTheDayAPIModel, PicOfTheDayError>) -> Void) {
        if let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&date=\(dateStr)&thumbs=true") {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    let jsonDecoder = JSONDecoder()
                    if let _ = error {
                        completion(.failure(.networkError))
                    } else if let data = data {
                        let picOfTheDayAPIModel = try jsonDecoder.decode(PicOfTheDayAPIModel.self, from: data)
                        completion(.success(picOfTheDayAPIModel))
                    }
                } catch {
                    completion(.failure(.decodeError))
                }
            }.resume()
        }
    }

    func downloadPic(imageURL: URL, selectedDate: String, completion: @escaping (Result<URL, PicOfTheDayError>) -> Void) {

        URLSession.shared.downloadTask(with: imageURL) { location, response, error in
               guard let location = location else {
                   completion(.failure(.imageDownloadError))
                   return
               }
                completion(.success(location))
           }.resume()
    }

    func saveImage(imageName: String, location: URL, completion: (Result<String, PicOfTheDayError>) -> Void) {
     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        print("\(fileURL)")
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                completion(.failure(.removeImageError))
            }
        }

        do {
            try FileManager.default.moveItem(at: location, to: fileURL)
            completion(.success(fileName))
        } catch {
            completion(.failure(.saveImageDiskError))
        }
    }

    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }
        return nil
    }

}
