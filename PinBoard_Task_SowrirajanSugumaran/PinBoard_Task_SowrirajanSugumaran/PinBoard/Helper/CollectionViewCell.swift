//
//  CollectionViewCell.swift
//  PinBoard_Task_SowrirajanSugumaran
//
//  Created by user on 13/05/19.
//  Copyright © 2019 ssowr1. All rights reserved.
//
import UIKit
class SPCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imagev: UIImageView!
    /// Function for tableview cell will appear
    override func awakeFromNib() {
        imagev.layer.cornerRadius = 25
        imagev.layer.masksToBounds = true
    }
    func cellDisplayAnimation() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: CGFloat(10), height: CGFloat(10))
        self.layer.transform = CATransform3DMakeScale(0.85, 0.85, 0.85)
        UIView.beginAnimations("scaleTableViewCellAnimationID", context: nil)
        UIView.setAnimationDuration(0.5)
        self.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0))
        self.alpha = 1
        self.layer.transform = CATransform3DIdentity
        UIView.commitAnimations()
    }
}
