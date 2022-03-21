//
//  PicOfTheDayViewModel.swift
//  PicOfTheDay
//
//  Created by Anjaneyulu Battula on 18/03/22.
//

import Foundation

enum PicOfTheDayDeatilsUpdateStatus {
    case success
    case failure(msg: String)
}

class PicOfTheDayViewModel {
    typealias PicOfTheDayDetailsUpdate = (PicOfTheDayDeatilsUpdateStatus) -> Void
    var picOfTheDayDetailsUpdate: PicOfTheDayDetailsUpdate!
    var picOfTheDay: PicOfTheDay!
    var isFromFavouriteList: Bool!
    var apiManager: APIManager!
    var isPicOfTheDayDataAvailable = false
    var selectDateLabelValue: String {
        return isFromFavouriteList ? "Pic of the day" : "Select Date"
    }
    var enableUserIntDatePick: Bool {
        return isFromFavouriteList ? false : true
    }
    var datePickerOpacity: Float {
        return isFromFavouriteList ? 0.5 : 1.0
    }

    init(picOfTheDay: PicOfTheDay,
         isFromFavouriteList: Bool = false,
         apiManager: APIManager = APIManager.shared) {
        self.picOfTheDay = picOfTheDay
        self.isFromFavouriteList = isFromFavouriteList
        self.apiManager = apiManager
    }

    func updateFavouritePicDetails() {
        if picOfTheDay.isFavourite {
            picOfTheDay.isFavourite = false
        } else {
            picOfTheDay.isFavourite = true
        }
        if isPicOfTheDayDataAvailable {
            picOfTheDay.favouritedDate = Date()
            DBManager.shared.updatePicOfTheDay(potd: picOfTheDay) { result in
                switch result {
                case .success():
                    break
                case .failure(let errorDetails):
                    picOfTheDayDetailsUpdate(.failure(msg: errorDetails.msg))
                }
            }
        }
    }

    func getPicOfTheDayWith(dateStr: String) {

        isPicOfTheDayDataAvailable = false

        // Getting details from DB
        DBManager.shared.getPicOfTheDayWith(dateStr: dateStr) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let picOfTheDayDB):
                if let picOfTheDayDB = picOfTheDayDB {
                    weakSelf.picOfTheDay = PicOfTheDay(date: picOfTheDayDB.potdDate,
                                                       explanation: picOfTheDayDB.explanation,
                                                       title: picOfTheDayDB.title,
                                                       fileName: picOfTheDayDB.fileName,
                                                       favouritedDate: picOfTheDayDB.favouritedDate ?? Date(),
                                                       isFavourite: picOfTheDayDB.isFavourite)
                    isPicOfTheDayDataAvailable = true
                    weakSelf.picOfTheDayDetailsUpdate(.success)
                } else {
                    weakSelf.getPicOfTheDayDataAPIWith(dateStr: dateStr)
                }
            case .failure(let errorDetails):
                picOfTheDayDetailsUpdate(.failure(msg: errorDetails.msg))
            }
        }


    }

    func getPicOfTheDayDataAPIWith(dateStr: String) {
        apiManager.getPicOfTheDayDataWith(dateStr: dateStr) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let picOfTheDayAPIModel):
                weakSelf.picOfTheDay = PicOfTheDay(date: picOfTheDayAPIModel.poctdDate,
                                          explanation: picOfTheDayAPIModel.explanation,
                                                   title: picOfTheDayAPIModel.title, favouritedDate: nil)

                guard let imageURL = URL(string: (picOfTheDayAPIModel.mediaType == .image) ? picOfTheDayAPIModel.url : picOfTheDayAPIModel.thumbnailURL ?? "") else {
                    return
                }
                weakSelf.downloadPic(picOfTheDayAPIModel: picOfTheDayAPIModel,
                                     imageURL: imageURL,
                                     selectedDate: dateStr)
            case .failure(let errorDetails):
                weakSelf.picOfTheDayDetailsUpdate(.failure(msg: errorDetails.msg))
            }
        }
    }

    func downloadPic(picOfTheDayAPIModel: PicOfTheDayAPIModel, imageURL: URL, selectedDate: String) {
        apiManager.downloadPic(imageURL: imageURL, selectedDate: selectedDate) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
                case .success(let downloadLocation):
                weakSelf.saveImageToDisk(picOfTheDayAPIModel: picOfTheDayAPIModel,
                                         imageURL: imageURL,
                                         selectedDate: selectedDate,
                                         downloadLocation: downloadLocation)
                case .failure(let errorDetails):
                weakSelf.picOfTheDayDetailsUpdate(.failure(msg: errorDetails.msg))
            }
        }
    }

    func saveImageToDisk(picOfTheDayAPIModel: PicOfTheDayAPIModel,
                         imageURL: URL,
                         selectedDate: String,
                         downloadLocation: URL) {
        // move the downloaded file from the temporary location url to your app documents directory
         let filename: NSString = imageURL.lastPathComponent as NSString
        APIManager.shared.saveImage(imageName: "\(selectedDate).\(filename.pathExtension)",
                                    location: downloadLocation) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let fileName):
                isPicOfTheDayDataAvailable = true
                weakSelf.savePicDetailsToDB(picOfTheDayAPIModel: picOfTheDayAPIModel, fileName: fileName)
            case .failure(let errorDetails):
                picOfTheDayDetailsUpdate(.failure(msg: errorDetails.msg))
            }
        }
    }

    func savePicDetailsToDB(picOfTheDayAPIModel: PicOfTheDayAPIModel, fileName: String) {

        DBManager.shared.insertPicOfTheDay(potd: picOfTheDayAPIModel,
                                           fileName: fileName,
                                           isFavourite: picOfTheDay.isFavourite,
                                           favouritedDate: picOfTheDay.favouritedDate) { result in
            switch result {
            case .success():
                picOfTheDay.fileName = fileName
                isPicOfTheDayDataAvailable = true
                picOfTheDayDetailsUpdate(.success)
            case .failure(let errorDetails):
                picOfTheDayDetailsUpdate(.failure(msg: errorDetails.msg))
            }
        }

    }
}
