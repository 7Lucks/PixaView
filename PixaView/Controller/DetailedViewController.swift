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
//let testShared = DetailedViewController()
    //MARK: viewDidLoad-
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.detailedCollectionView.register(UINib(nibName: DetailedCell.detailCellIdentifier, bundle: nil), forCellWithReuseIdentifier: DetailedCell.detailCellIdentifier)
        self.detailedCollectionView.dataSource = self
        self.detailedCollectionView.delegate = self
    }
    //MARK:  Actions-
//share button
    @IBAction func shareButton(_ sender: UIButton) {
    
        let item:[Any] = [detailedPictures!]
        let  activity = UIActivityViewController(activityItems: item, applicationActivities: nil)
        
        self.present(activity, animated: true, completion: nil)
        
    }
    //    //MARK: - end of Actions
    
    
} // end of DetailedViewController

//MARK:  Extensions-
extension DetailedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height )}

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let detCell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedCell.detailCellIdentifier, for: indexPath) as? DetailedCell else{
            fatalError()
        }
        detCell.detailImageOutlet.image = detailedPictures
        detCell.detailedTextLabel.text = tags
       // detCell.detailedCellConfig()
        return detCell
    }
}
