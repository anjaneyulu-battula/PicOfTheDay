//
//  FavouriteListViewModel.swift
//  PicOfTheDay
//
//  Created by Anjaneyulu Battula on 18/03/22.
//

import Foundation

class FavouriteListViewModel {

    var favouriteList = [PicOfTheDay]()

    func loadFavouriteList() {
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
            case .failure(let errorDetails):
                break
            }
        }
    }

}


