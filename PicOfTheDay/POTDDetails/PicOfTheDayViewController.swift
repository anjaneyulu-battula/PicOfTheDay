//
//  PicOfTheDayViewController.swift
//  PicOfTheDay
//
//  Created by Anjaneyulu Battula on 17/03/22.
//

import Foundation
import UIKit

class PicOfTheDayViewController: UIViewController {

    var viewModel: PicOfTheDayViewModel!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favouriteBarButtonItem: UIBarButtonItem!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.isPicOfTheDayDataAvailable {
            dateSelected()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if viewModel == nil {
            viewModel = PicOfTheDayViewModel(picOfTheDay: PicOfTheDay(favouritedDate: nil))
        }
        registerPicOfTheDayDetailsUpdate()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let someDateTime = formatter.date(from: "1995-06-16")

        datePicker.locale = .current
        datePicker.date = Date()
        datePicker.maximumDate = Date() // Today date - 1
        datePicker.minimumDate = someDateTime
        datePicker.addTarget(self, action: #selector(dateSelected), for: .valueChanged)
        descLabel.text = "--"


        if viewModel.isFromFavouriteList {
            datePicker.date = formatter.date(from: viewModel.picOfTheDay.date) ?? Date()
            viewModel.isPicOfTheDayDataAvailable = true
            loadUIWithDetails()
        }
    }

    @IBAction func favouriteBarButtonAction(_ sender: Any) {
        if viewModel.picOfTheDay.isFavourite {
            favouriteBarButtonItem.tintColor = UIColor.lightGray
        } else {
            favouriteBarButtonItem.tintColor = UIColor.systemBlue
        }
        viewModel.updateFavouritePicDetails()
    }


    @objc
    func dateSelected() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: datePicker.date)
        self.dismiss(animated: false) { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                Utility.shared.showLoader(viewController: weakSelf)
            }
            weakSelf.viewModel.getPicOfTheDayWith(dateStr: dateStr)
        }
    }

    func registerPicOfTheDayDetailsUpdate() {
        viewModel.picOfTheDayDetailsUpdate = { [weak self] status in
            guard let weakSelf = self else { return }
            switch status {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    weakSelf.loadUIWithDetails()
                    Utility.shared.hideLoader(viewController: weakSelf)
                }
            case .failure(let msg):
                print("Errro Msg: \(msg)")
            }

        }
    }

    func loadUIWithDetails() {
        self.titleLabel.text = viewModel.picOfTheDay.title
        self.descLabel.text = viewModel.picOfTheDay.explanation
        self.imageView.image = viewModel.apiManager.loadImageFromDiskWith(fileName: viewModel.picOfTheDay.fileName)
        self.datePicker.isUserInteractionEnabled = viewModel.enableUserIntDatePick
        self.datePicker.layer.opacity = viewModel.datePickerOpacity
        favouriteBarButtonItem.tintColor = viewModel.picOfTheDay.isFavourite ? UIColor.systemBlue : UIColor.lightGray
    }
}
