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

    var msg: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .decodeError:
            return "decodeError"
        case .imageDownloadError:
            return "imageDownloadError"
        case .failedRequest:
            return "failedRequest"
        case .requestTimedOut:
            return "requestTimedOut"
        case .saveImageDiskError:
            return "saveImageDiskError"
        case .removeImageError:
            return "removeImageError"
        case .saveOrUpdateDBError:
            return "saveOrUpdateDBError"
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
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                do {
                    guard let weakSelf = self else { return }
                    let jsonDecoder = JSONDecoder()
                    if let data = data {
                        let picOfTheDayAPIModel = try jsonDecoder.decode(PicOfTheDayAPIModel.self, from: data)
                        completion(.success(picOfTheDayAPIModel))

                        guard let imageURL = URL(string: (picOfTheDayAPIModel.mediaType == .image) ? picOfTheDayAPIModel.url : picOfTheDayAPIModel.thumbnailURL ?? "") else {
                            completion(.failure(.invalidUrl))
                            return
                        }
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
