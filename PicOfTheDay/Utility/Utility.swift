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

    private init() { }

    func showLoader(viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: "Loadgin Details...", preferredStyle: .alert)

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

}
