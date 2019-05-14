//
//  ViewController.swift
//  PinBoard_Task_SowrirajanSugumaran
//
//  Created by user on 14/05/19.
//  Copyright © 2019 ssowr1. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    /// CollectionView outlet
    @IBOutlet weak var collectionView: UICollectionView!
    /// Collection view data source
    @IBOutlet weak var collectionViewDataSource: SPCollectioViewDataSource!
    /// User details array
    var userDetails = [UserDetails]()
    //MARK:- View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
    }
    //MARK:- Custom methods
    private func allocateColletionView() {
        let cellSize = CGSize(width: SIZE.width/2-10, height: SIZE.width/2-10)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.minimumLineSpacing = 3.0
        layout.minimumInteritemSpacing = 3.0
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionViewDataSource.userDetails = userDetails
        collectionView.reloadData()
    }
    fileprivate func apiCall(){
        ApiManager.getPinBoardImages(url: PINBOARD) { (response, error) in
            self.userDetails = (response ?? nil)!
            if self.userDetails.count != 0 {
                DispatchQueue.main.async {
                    self.allocateColletionView()
                }
            }
        }
    }
}
