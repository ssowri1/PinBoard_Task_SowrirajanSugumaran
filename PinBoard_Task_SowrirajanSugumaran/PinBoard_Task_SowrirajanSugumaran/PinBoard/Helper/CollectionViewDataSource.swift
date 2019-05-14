//
//  CollectionViewDataSource.swift
//  PinBoard_Task_SowrirajanSugumaran
//
//  Created by user on 14/05/19.
//  Copyright © 2019 ssowr1. All rights reserved.
//

import Foundation
import UIKit
class SPCollectioViewDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var userDetails = [UserDetails]()
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userDetails.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SPCollectionViewCell else {
            return UICollectionViewCell()
        }
        let imageUrlString = userDetails[indexPath.row].user.profile_image.large
        let url = URL(string: imageUrlString)!
        let _ = ImageDownloader().downloadImage(fromUrl: url, cachePolicy: .useProtocolCachePolicy) { (result, boolean) in
            switch result {
            case .success(let image, _):
                cell.imagev.image = image
                break
            case .canceled: break
            case .error: break
            }
        }
        cell.cellDisplayAnimation()
        return cell
    }

}
