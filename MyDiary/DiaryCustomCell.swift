//
//  DiaryCustomCell.swift
//  MyDiary
//
//  Created by Taylor Smith on 1/31/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import UIKit

class DiaryCustomCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellImage.layer.cornerRadius = cellImage.bounds.height/2
        cellImage.clipsToBounds = true
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
