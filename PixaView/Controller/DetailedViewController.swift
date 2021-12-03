//
//  DetailedViewController.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 02.12.2021.
//

import UIKit

class DetailedViewController: UIViewController{
    
    
    //MARK: Outlets-
  
    @IBOutlet weak var detailedCollectionView: UICollectionView!
    
   //MARK: Properties-
    var detailedPictures: UIImage?
    var tags = ""
    
    
    //MARK: viewDidLoad-
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.detailedCollectionView.register(UINib(nibName: DetailedCell.detailCellIdentifier, bundle: nil), forCellWithReuseIdentifier: DetailedCell.detailCellIdentifier)
        self.detailedCollectionView.dataSource = self
        self.detailedCollectionView.delegate = self

    }
    
} // end of DetailedViewController


//MARK:  Extensions-
extension DetailedViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let detCell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedCell.detailCellIdentifier, for: indexPath) as? DetailedCell else{
            fatalError()
        }
        detCell.detailImage.image = detailedPictures
        detCell.detailedTextLabel.text = tags
        return detCell
    }
}
