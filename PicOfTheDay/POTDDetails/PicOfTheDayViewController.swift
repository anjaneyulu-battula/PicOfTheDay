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


    @IBOutlet weak var selectDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favouriteBarButtonItem: UIBarButtonItem!

    // MARK: - View Life Cycle
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

        selectDateLabel.text = viewModel.selectDateLabelValue
        datePicker.locale = .current
        datePicker.date = Date()
        datePicker.minimumDate = viewModel.minDate
        datePicker.maximumDate = viewModel.maxDate
        datePicker.addTarget(self, action: #selector(dateSelected), for: .valueChanged)
        descLabel.text = "--"

        if viewModel.isFromFavouriteList {
            datePicker.date = Utility.shared.dateFormatter.date(from: viewModel.picOfTheDay.date) ?? Date()
            viewModel.isPicOfTheDayDataAvailable = true
            loadUIWithDetails()
        }
    }

    // MARK: - Actions
    @IBAction func favouriteBarButtonAction(_ sender: Any) {
        favouriteBarButtonItem.tintColor = viewModel.favBarButtonTintColor
        viewModel.updateFavouritePicDetails()
    }


    @objc
    func dateSelected() {
        self.dismiss(animated: false) { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                Utility.shared.showLoader(viewController: weakSelf)
            }
            weakSelf.viewModel.getPicOfTheDayWith(dateStr: Utility.shared.getDateStrWith(date: weakSelf.datePicker.date))
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

    func registerPicOfTheDayDetailsUpdate() {
        viewModel.picOfTheDayDetailsUpdate = { [weak self] status in
            guard let weakSelf = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                Utility.shared.hideLoader(viewController: weakSelf)
                switch status {
                case .success:
                    weakSelf.loadUIWithDetails()
                case .failure(let msg):
                    Utility.shared.showAlert(viewController: weakSelf, msg: msg)
                }
            }
        }
    }
}
