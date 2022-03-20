//
//  FavouriteListTableCell.swift
//  PicOfTheDay
//
//  Created by Anjaneyulu Battula on 18/03/22.
//

import UIKit

class FavouriteListTableCell: UITableViewCell {

    @IBOutlet weak var potdImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(potd: PicOfTheDay) {
        potdImageView.image = APIManager.shared.loadImageFromDiskWith(fileName: potd.fileName)
        titleLable.text = potd.title
        descLabel.text = potd.explanation
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
