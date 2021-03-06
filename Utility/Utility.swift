//
//  Utility.swift
//  PicOfTheDay
//
//  Created by Anjaneyulu Battula on 20/03/22.
//

import Foundation
import UIKit

final class Utility {

    static var shared = Utility()

    var dateFormatter = DateFormatter()

    private init() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    func getDateStrWith(date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    func showLoader(viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: "Loading Details...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        viewController.present(alert, animated: true, completion: nil)
    }

    func hideLoader(viewController: UIViewController) {
        viewController.dismiss(animated: false, completion: nil)
    }

    func showAlert(viewController: UIViewController, msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(
               title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        viewController.present(alert, animated: true, completion: nil)
    }

}
