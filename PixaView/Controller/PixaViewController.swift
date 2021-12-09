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
    @IBOutlet weak var sortButtonOutlet: UIButton!
        //MARK: - end of Outlets
    
    //MARK:  Properties -
//    let urlStr = "https://pixabay.com/api/?key=\(myKeyId)&q=audi&per_page=100&image_type=photo"
//
    let urlStr = "https://pixabay.com/api/?key=16834549-9bf1a2a9f7bfa54e36404be81&q=audi&per_page=100&image_type=photo" // https://pixabay.com/api/
    var hitsRESULT: [Hits] = [] //array from json
    var popularLastetstButton = PopularLastestButton()
    var enumValue = ""
    
    //MARK: - end of Properties
    
    //MARK:  viewDidLoad -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: PixaViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PixaViewCell.cellIdentifier) //assign to cell the Xib file
        self.collectionView.dataSource = self //the cell need to understand where to get the filling from. add protocol to extension - UICollectionViewDataSource
        self.collectionView.delegate = self //delegate with collectionView. Subscribe to UICollectionViewDelegate as delegate
        fetchPics()
        droppedMunu()
    }
    //MARK: - End of viewDidLoad
    
    //MARK:  dropped button-
    
 func droppedMunu(){
    let droppedSortMenu = UIMenu(title:"PixaSort", children: [
        UIAction(title: "Popular", image: UIImage(systemName: "tray.full"), handler: {(_) in
            self.popularLastetstButton.pixaGallerySort(1, order: .popular )
            self.didSelectSortingStrategy(order: .popular)
        }),
        UIAction(title: "Lastest", image: UIImage(systemName: "star.circle"), handler: {(_) in
            self.popularLastetstButton.pixaGallerySort(1, order: .latest)
            self.didSelectSortingStrategy(order: .latest)
        })
        ])
    self.sortButtonOutlet.menu = droppedSortMenu
    self.sortButtonOutlet.showsMenuAsPrimaryAction = true
    
    }

    func didSelectSortingStrategy( order: PopularLastestButton.Order){
        var urlString = ""
        switch order {
        case .latest:
            urlString = "https://pixabay.com/api/?key=\(myKeyId)&editors_choice=true&per_page=150&order=latest"
        case .popular:
            urlString = "https://pixabay.com/api/?key=\(myKeyId)&editors_choice=true&per_page=150&order=popular"
            
        } //end of swith
        changedUrl(newURL: URL(string: urlString)!)
    }
    
    
    func didSelectCategory(category: [Categories]){
    
        
        
    }
    
    
    func changedUrl(newURL: URL){
        
        let task = URLSession.shared.dataTask(with: newURL){[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let jsonResults = try JSONDecoder().decode(ImageAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.hitsRESULT = jsonResults.hits
                    self?.collectionView.reloadData() // reload data to cell
                }// to main que
            }catch{
                print("Here is some ERR - \(error)")
            }
        }
        task.resume()
    } // end of fetchPics

    //MARK: - end of dreopped button
 //MARK: - actions
    @IBAction func filterButtonDidTap(_ sender: UIButton) {
        guard let filterVC = storyboard?.instantiateViewController(withIdentifier: "FilterViewControllerID") else{return}
        present(filterVC, animated: true, completion: nil)
        let filterViewController = filterVC as? FilterViewController
        filterViewController?.holder = self
        
    }
    
    
    //MARK: Methods -
    func fetchPics(){
        guard let url = URL(string: urlStr) else{return}
        
        let task = URLSession.shared.dataTask(with: url){[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            //do catch for JSON decoder
            do{
                let jsonResults = try JSONDecoder().decode(ImageAPIResponse.self, from: data)
                
                //                              print(jsonResults.hits.count)  //by default is 20
                //                              print(response)
                
                DispatchQueue.main.async {
                    self?.hitsRESULT = jsonResults.hits
                    self?.collectionView.reloadData() // reload data to cell
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
        cell.tagsLabelOutlet.text = hitsRESULT[indexPath.row].tags
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
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        //return 0
    //        return 10
    //    }
    
    // when use "paging" shoud use this method insetForSectionAt
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    //    }
    //
    //
    //        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //            let detailedVC = (storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as? DetailedViewController)!
    //            self.navigationController?.pushViewController(detailedVC, animated: true)
    //        }
    //
    //        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    //
    //                print(" selected")
    //            }
    //
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //MARK: - какие данные хотим передать
        let cellImage = (collectionView.cellForItem(at: indexPath) as? PixaViewCell)?.pixaImageOutlet.image
        let cellTags = (collectionView.cellForItem(at: indexPath) as? PixaViewCell)?.tagsLabelOutlet.text
        
        let vc = (storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as? DetailedViewController)!
        
        vc.tags = hitsRESULT[indexPath.row].tags
        vc.detailedPictures = cellImage
        vc.tags = cellTags ?? "No tags"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

}// end of Extensions



