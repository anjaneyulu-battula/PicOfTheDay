//
//  FavouriteListViewModel.swift
//  PicOfTheDay
//
//  Created by Anjaneyulu Battula on 18/03/22.
//

import Foundation

enum FavouriteListUpdateStatus {
    case success
    case failure(msg: String)
}

class FavouriteListViewModel {

    var favouriteList = [PicOfTheDay]()
    
    typealias FavouriteListUpdate = (FavouriteListUpdateStatus) -> Void
    var favouriteListUpdate: FavouriteListUpdate!

    func loadFavouriteList() {
        favouriteList.removeAll()
        DBManager.shared.getFavouriteList { result in
            switch result {
            case .success(let favouriteListDB):
                for favouriteDB in favouriteListDB {
                    let potd = PicOfTheDay(date: favouriteDB.potdDate,
                                           explanation: favouriteDB.explanation,
                                           title: favouriteDB.title,
                                           fileName: favouriteDB.fileName,
                                           favouritedDate: favouriteDB.favouritedDate,
                                           isFavourite: favouriteDB.isFavourite)
                    favouriteList.append(potd)
                }
                favouriteListUpdate(.success)
            case .failure(let errorDetails):
                favouriteListUpdate(.failure(msg: errorDetails.msg))
            }
        }
    }

    func updateFavouritePicDetails(row: Int) {
        var favouritePic = favouriteList[row]
        favouritePic.isFavourite = false
        DBManager.shared.updatePicOfTheDay(potd: favouritePic) { result in
            switch result {
            case .success():
                break
            case .failure(let errorDetails):
                favouriteListUpdate(.failure(msg: errorDetails.msg))
            }
        }
    }

}


