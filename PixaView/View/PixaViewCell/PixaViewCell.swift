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
    @IBOutlet weak var imgNameLabel: UILabel!
    //MARK: - end of Outlets
    
    //MARK: Properties_
    static let cellIdentifier = "PixaViewCell"
    private let imageView: UIImageView = {
        let imageView = UIImageView()
       // imageView.clipsToBounds = true              // clip to bounds
        imageView.contentMode = .scaleAspectFill    // aspect fill
        return imageView
    }()
    
    //MARK: - end of Properties
    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
    }
    
    //MARK:  Methods-
    func configure(with urlString: String){
        guard let url = URL(string: urlString) else{
            return
        }
        let taskSetImage = URLSession.shared.dataTask(with: url){data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.pixaImage.image = image
            }
        }
        taskSetImage.resume()
    }
    //MARK: - end of Methods
}//end of PixaViewCell
