//
//  ListUserCollectionViewCell.swift
//  ChatAppDemo
//
//  Created by BeeTech on 20/12/2022.
//

import UIKit

class ListUserCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var img: CustomImage!
    @IBOutlet weak var lbName: UILabel!
    
    func updateUI(_ user: User?) {
        guard let user = user else {return}
        lbName.text = user.name
        ImageService.share.fetchImage(with: user.avatar) { image in
            DispatchQueue.main.async {
                self.img.image = image
            }
        }
    }
}
