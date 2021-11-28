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
    let urlStr = "https://pixabay.com/api/?key=16834549-9bf1a2a9f7bfa54e36404be81&q=yellow+flowers&image_type=photo"  // https://pixabay.com/api/
    var hitsRESULT: [Hits] = []
    
    //MARK: - end of Properties
    
    //MARK:  viewDidLoad -
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "PixaViewCell", bundle: nil), forCellWithReuseIdentifier: "PixaViewCell") //assign to cell the Xib file
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
                return
            }
            // print("have some data") +
            //do catch for JSON decoder
            do{
                let jsonResults = try JSONDecoder().decode(ImageAPIResponse.self, from: data)
                //                print(jsonResults.hits.count)  //by default is 20
                //                print(response)
                DispatchQueue.main.async {
                    self?.hitsRESULT = jsonResults.hits
                    self?.collectionView.reloadData() // reload data to cell
                }// to main que
                
            }catch{
                print("Here is some ERR - \(error)")
            }
        }
        task.resume()
    }
    
    //MARK: - End of Methods
    
    
} // end of PixaViewController class


//MARK: Extensions -
extension PixaViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    // number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hitsRESULT.count
    }
    // what type of the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageURLString = hitsRESULT[indexPath.item].imageURL
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PixaViewCell", for: indexPath) as! PixaViewCell
        cell.backgroundColor = .cyan
      //  cell.pixaImage
        
        
        return cell
    }
}



