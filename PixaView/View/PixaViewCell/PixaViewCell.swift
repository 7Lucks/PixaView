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
    //MARK: - end of Properties
    
    
    
        //FIXME: - Перенести методы в другой файл!
    
    //MARK:  Methods-
    
    func cellPixaConfig(){
        pixaImageOutlet.clipsToBounds = true              // clip to bounds
        pixaImageOutlet.contentMode = .scaleAspectFill   // aspect fill
        pixaImageOutlet.layer.cornerRadius = 15
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
    }
    
    func configure(with urlString: String){
//        guard let url = URL(string: urlString) else{
//            return
//        }
//        let taskSetImage = URLSession.shared.dataTask(with: url){data, _, error in
//            guard let data = data, error == nil else{
//                return
//            }
//            DispatchQueue.main.async {
//                let image = UIImage(data: data)
//                self.pixaImageOutlet.image = image
//                self.activityIndicator.stopAnimating()
//            }
//        }
//        taskSetImage.resume()
    }
    //MARK: - end of Methods
}//end of PixaViewCell
