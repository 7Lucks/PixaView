//
//  DetailedCell.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 02.12.2021.
//

import UIKit
import TestFramework

class DetailedCell: UICollectionViewCell {

    //MARK:  Outlets-
    @IBOutlet weak var detailImageOutlet: UIImageView!
    @IBOutlet weak var detailedTextLabel: UILabel!
   //MARK: - end of Outlets
    
    
    static let detailCellIdentifier = "DetailedCell"
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        detailedCellConfig()
        detailImageOutlet.layoutIfNeeded()
        detailImageOutlet.layer.cornerRadius = 15
        detailImageOutlet.clipsToBounds = true
        detailImageOutlet.contentMode = .scaleAspectFill
        }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.detailImageOutlet.image = nil
    }
//        func detailedCellConfig(){
//           // detailImageOutlet.clipsToBounds = true              // clip to bounds
//            detailImageOutlet.contentMode = .scaleAspectFill   // aspect fill
//            detailImageOutlet.layer.cornerRadius = 15
//
//        }
    }
