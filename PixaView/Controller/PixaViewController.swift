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
    
    //MARK:  Properties -
    let urlStr = "https://pixabay.com/api/?key=16834549-9bf1a2a9f7bfa54e36404be81&q=apple&per_page=100&image_type=photo"  // https://pixabay.com/api/
    var hitsRESULT: [Hits] = [] //array from json
    
    //MARK: - end of Properties
    
    //MARK:  viewDidLoad -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: PixaViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PixaViewCell.cellIdentifier) //assign to cell the Xib file
        self.collectionView.dataSource = self //the cell need to understand where to get the filling from. add protocol to extension - UICollectionViewDataSource
        self.collectionView.delegate = self //delegate with collectionView. Subscribe to UICollectionViewDelegate as delegate
        fetchPics()
    }
    //MARK: - End of viewDidLoad
    
    //MARK: Methods -
    func fetchPics(){
        guard let url = URL(string: urlStr) else{return}
        
        let task = URLSession.shared.dataTask(with: url){[weak self] data, response, error in
            guard let data = data, let response = response, error == nil else {
                //let image = UIImage(data: data!)
                return
            }
            // print("have some data")
            
            //do catch for JSON decoder
            do{
                let jsonResults = try JSONDecoder().decode(ImageAPIResponse.self, from: data)
                
                //                               print(jsonResults.hits.count)  //by default is 20
                //                              print(response)
                
                DispatchQueue.main.async {
                    self?.hitsRESULT = jsonResults.hits
                    self?.collectionView.reloadData() // reload data to cell
                    //self?.indicator.activityIndicator.stopAnimating()  // stop animating of activity indicator when image is ready
                }// to main que
                
            }catch{
                print("Here is some ERR - \(error)")
            }
        }
        task.resume()
    } // end of fetchPics
    
    //MARK: - End of Methods
    
} // end of PixaViewController class

//MARK: Extensions -
extension PixaViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    // number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hitsRESULT.count
    }
    
    // type of the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageURLString = hitsRESULT[indexPath.item].webformatURL  //image from json to cell
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PixaViewCell.cellIdentifier, for: indexPath) as? PixaViewCell else{
            return PixaViewCell()
        }
       // cell.backgroundColor = .systemGray
        cell.imgNameLabel.text = hitsRESULT[indexPath.row].tags
        cell.configure(with: imageURLString)
        cell.cellPixaConfig()
        return cell
    } // end of collectionView
    
    
    
    // MARK: QUESTION : при перевороте устройства варианты указать чере свитч?
    // cell cizes  // as diasplay // vertical
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width )  // need to check
    }
    // set cell indent(отступ) by 0 px
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //return 0
        return 10
    }
    //
    //    // when use "paging" shoud use this method insetForSectionAt
    //
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedVC = (storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as? DetailedViewController)!
        self.navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    
    
}// end of Extensions



