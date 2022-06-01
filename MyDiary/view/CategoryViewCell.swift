//
//  CategoryViewCell.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2022/01/29.
//

import UIKit

class CategoryViewCell: UITableViewCell {

    @IBOutlet weak var cate: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
