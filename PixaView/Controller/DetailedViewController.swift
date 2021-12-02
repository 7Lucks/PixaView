//
//  DetailedViewController.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 02.12.2021.
//

import UIKit

class DetailedViewController: UIViewController {
    

    @IBOutlet weak var detailedCollectionView: UICollectionView!
    
    let detailedPictures = [Hits]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.detailedCollectionView.delegate = self
//        self.detailedCollectionView.dataSource = self
//        self.detailedCollectionView.register(UINib(nibName: DetailedCell.detailIdent, bundle: nil), forCellWithReuseIdentifier: DetailedCell.detailIdent)
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return detailedPictures.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let imageURLString = detailedPictures[indexPath.item].webformatURL  //image from json to cell
//
//        guard let detailedCell = collectionView.dequeueReusableCell(withReuseIdentifier: PixaViewCell.cellIdentifier, for: indexPath) as? PixaViewCell else{
//            return PixaViewCell()
//        }
//        detailedCell.
//        return detailedCell
//    }

}
