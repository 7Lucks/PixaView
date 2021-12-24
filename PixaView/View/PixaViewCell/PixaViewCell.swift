//
//  PixaViewCell.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 27.11.2021.
//

import UIKit
import TestFramework


class PixaViewCell: UICollectionViewCell {
    //MARK:  Outlets -
    @IBOutlet weak var pixaImageOutlet: UIImageView!
    @IBOutlet weak var tagsLabelOutlet: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //MARK: - end of Outlets
    
    //MARK: Properties-
    static let cellIdentifier = "PixaViewCell"
    
    //reuse of cell and nill for images
    override func prepareForReuse() {
        super.prepareForReuse()
        self.pixaImageOutlet.image = nil
       
    }

    override func awakeFromNib() {
        super.awakeFromNib()
            pixaImageOutlet.clipsToBounds = true              // clip to bounds
        pixaImageOutlet.contentMode = .scaleAspectFill   // aspect fill
        pixaImageOutlet.layer.cornerRadius = 15      
    }
    //MARK: - end of Properties
}//end of PixaViewCell
