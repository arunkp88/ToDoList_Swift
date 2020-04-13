//
//  ToDoListTableCell.swift
//  ToDoListApp
//
//  Created by Arun Kappattiparambil Parameswaran on 07/04/20.
//  Copyright © 2020 Arun Kappattiparambil Parameswaran. All rights reserved.
//

import UIKit

class ToDoListTableCell: UITableViewCell {

    @IBOutlet weak var itemDate: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String{
        return String(describing: self)
    }
    
    func updateCell(item: ToDoItemModel) {
        self.itemLabel.text = item.itemTitle
        self.itemDate.text = ""
        if let validDate = item.itemCreatedDate {
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = DateFormatter.Style.medium
            let dateStr = timeFormatter.string(from:validDate)
            self.itemDate.text = dateStr
        }
        if let itemCompleted = item.itemCompleted {
            self.itemImage.image = itemCompleted ? UIImage(named: "checked_checkbox") : UIImage(named: "unchecked_checkbox")
        }
    }
    
}
