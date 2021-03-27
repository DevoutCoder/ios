//
//  OKDAppCollectTableViewCell.swift
//  OneKey
//
//  Created by xuxiwen on 2021/3/27.
//  Copyright © 2021 Onekey. All rights reserved.
//

import UIKit
import Reusable

class OKDAppCollectTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!

    func setModel(model: OKDappItem) {
        let url = model.dappIconURLString()
        if url.isEmpty {
            icon.image = "logo_square".toUIImage
        } else {
            icon.setNetImage(url: url)
        }
        title.text = model.dappName()
        subTitle.text = model.dappDescription()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
