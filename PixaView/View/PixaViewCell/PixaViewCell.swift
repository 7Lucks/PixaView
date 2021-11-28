//
//  PixaViewCell.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 27.11.2021.
//

import UIKit

class PixaViewCell: UICollectionViewCell {
    //MARK:  Outlets -
    @IBOutlet weak var pixaImage: UIImageView!
    //MARK: - end of Outlets
    
    
  //static let cellIdentifier = "PixaViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:  Methods-
    func setupCell(imageResponse: ImageAPIResponse){
//        self.pixaImage.image = imageResponse
        
    }
    //MARK: - end of Methods
    
}//end of PixaViewCell
