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
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = FavouriteListViewModel()

        favouriteListTableView.dataSource = self
        favouriteListTableView.delegate = self
        favouriteListTableView.rowHeight = 100

        viewModel.loadFavouriteList()
        favouriteListTableView.reloadData()

        // Do any additional setup after loading the view.
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
        return viewModel.favouriteList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: favouriteListTableCellIdent) as? FavouriteListTableCell else {
            return UITableViewCell()
        }
        cell.configureCell(potd: viewModel.favouriteList[indexPath.row])
        return cell
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
