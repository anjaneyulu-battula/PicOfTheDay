//
//  FavouriteListViewController.swift
//  PicOfTheDay
//
//  Created by Anjaneyulu Battula on 18/03/22.
//

import UIKit

fileprivate let favouriteListTableCellIdent = "FavouriteListTableCell"

class FavouriteListViewController: UIViewController {

    var viewModel : FavouriteListViewModel!

    @IBOutlet weak var favouriteListTableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavouriteList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = FavouriteListViewModel()
        registerFavouriteListUpdate()

        favouriteListTableView.allowsMultipleSelectionDuringEditing = false
        favouriteListTableView.dataSource = self
        favouriteListTableView.delegate = self
        favouriteListTableView.rowHeight = 100


//        viewModel.loadFavouriteList()
//        favouriteListTableView.reloadData()

        // Do any additional setup after loading the view.
    }

    func registerFavouriteListUpdate() {
        viewModel.favouriteListUpdate = { [weak self] status in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                switch status {
                case .success:
                    weakSelf.favouriteListTableView.reloadData()
                case .failure(let msg):
                    Utility.shared.showAlert(viewController: weakSelf, msg: msg)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDataSource
extension FavouriteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.favouriteList.count == 0 {
            tableView.setEmptyMessage("No Data Available")
        } else {
            tableView.restore()
        }
        return viewModel.favouriteList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: favouriteListTableCellIdent) as? FavouriteListTableCell else {
            return UITableViewCell()
        }
        cell.configureCell(potd: viewModel.favouriteList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            viewModel.updateFavouritePicDetails(row: indexPath.row)
            let rowNumber : Int = indexPath.row
            viewModel.favouriteList.remove(at: rowNumber)
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }
}

// MARK: - UITableViewDelegate
extension FavouriteListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let picOfTheDayViewController = storyBoard.instantiateViewController(withIdentifier: "PicOfTheDayViewController") as! PicOfTheDayViewController
        picOfTheDayViewController.viewModel = PicOfTheDayViewModel(picOfTheDay: viewModel.favouriteList[indexPath.row], isFromFavouriteList: true)
        self.navigationController?.pushViewController(picOfTheDayViewController, animated: true)

    }
}


extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor(named: "noDataColor")
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
