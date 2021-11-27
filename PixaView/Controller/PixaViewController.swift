//
//  PixaViewController.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 27.11.2021.
//

import UIKit

class PixaViewController: UIViewController {
    //MARK: Outlets -
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: - end of Outlets
    
    //MARK:  viewDidLoad -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: "PixaViewCell", bundle: nil), forCellWithReuseIdentifier: "PixaViewCell") //assign to cell the Xib file
        self.collectionView.dataSource = self //the cell need to understand where to get the filling from. add protocol to extension - UICollectionViewDataSource
        self.collectionView.delegate = self //delegate with collectionView. Subscribe to UICollectionViewDelegate as delegate
    }
    //MARK: - End of viewDidLoad

    
} // end of PixaViewController class

//MARK: Extensions -
extension PixaViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    // number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
        // what type of the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
}



