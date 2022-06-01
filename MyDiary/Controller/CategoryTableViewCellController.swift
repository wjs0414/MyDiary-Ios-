//
//  CategoryTableViewCellController.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2022/02/01.
//

import UIKit

class CategoryTableViewCellController: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cateImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
