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
    @IBOutlet weak var iamgeNameLabel: UILabel!
    //MARK: - end of Outlets
    
    //MARK: Properties_
  static let cellIdentifier = "PixaViewCell"
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true              // clip to bounds
        imageView.contentMode = .scaleAspectFill    // aspect fill
        return imageView
    }()
    
    //MARK: - end of Properties
    
// FIXME: - ? -
    override init (frame: CGRect){
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    //MARK:  Methods-
    func configure(with urlString: String){
        guard let url = URL(string: urlString) else{
            return
        }
        let taskImage = URLSession.shared.dataTask(with: url){data, response, error in
            guard let data = data, let response = response, error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.image = image
            }
            
        }
        taskImage.resume()
    }
    //MARK: - end of Methods
    
}//end of PixaViewCell
