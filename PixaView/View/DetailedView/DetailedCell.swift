//
//  DetailedCell.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 02.12.2021.
//

import UIKit

class DetailedCell: UICollectionViewCell {

    //MARK:  Outlets-
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailedTextLabel: UILabel!
   //MARK: - end of Outlets
    
    
    static let detailCellIdentifier = "DetailedCell"
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.detailImage.image = nil
    }
        func detailedCellConfig() -> UIImageView{
            detailImage.clipsToBounds = true              // clip to bounds
            detailImage.contentMode = .scaleAspectFill   // aspect fill
            detailImage.layer.cornerRadius = 15
            return detailImage
        }
    }
