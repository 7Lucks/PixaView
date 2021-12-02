//
//  DetailedCell.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 02.12.2021.
//

import UIKit

class DetailedCell: UICollectionViewCell {

    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailedLabel: UILabel!
    
    static let detailIdent = "DetailedCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    func configureDetailedCell(with urlString: String){
//        guard let url = URL(string: urlString) else{
//            return
//        }
//        let taskSetImage = URLSession.shared.dataTask(with: url){data, _, error in
//            guard let data = data, error == nil else{
//                return
//            }
//            DispatchQueue.main.async {
//                let image = UIImage(data: data)
//                self.detailImage.image = image
//
//            }
//        }
//        taskSetImage.resume()
//    }
    
    
    
    
}
