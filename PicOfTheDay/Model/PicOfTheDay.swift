//
//  PicOfTheDay.swift
//  PicOfTheDay
//
//  Created by Anjaneyulu Battula on 18/03/22.
//

import Foundation

struct PicOfTheDay {
    var date: String
    var explanation: String
    var title: String
    var fileName: String
    var favouritedDate: Date?
    var isFavourite: Bool

    init(date: String = "",
         explanation: String = "",
         title: String = "",
         fileName: String = "",
         favouritedDate: Date?,
         isFavourite: Bool = false) {
        self.date = date
        self.explanation = explanation
        self.title = title
        self.fileName = fileName
        self.favouritedDate = favouritedDate
        self.isFavourite = isFavourite
    }
}

