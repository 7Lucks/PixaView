//
//  PixaViewController.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 27.11.2021.
//

import UIKit
import TestFramework

class PixaViewController: UIViewController {
    //MARK: Outlets -
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortButtonOutlet: UIButton!
    //MARK: - end of Outlets
    
    //MARK:  Properties -
    
    //  let urlStr = "https://pixabay.com/api/?key=16834549-9bf1a2a9f7bfa54e36404be81&q=china&per_page=100&image_type=photo" // https://pixabay.com/api/
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
        //fetch(order: .popular, filterCategory: [.backgrounds], currentPage: 1)
        fetch()
        droppedMunu()
        //setImage()
        
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
        //        var urlString = ""
        //        switch order {
        //        case .latest:
        //            urlString = "https://pixabay.com/api/?key=\(myKeyId)&editors_choice=true&per_page=150&order=latest"
        //        case .popular:
        //            urlString = "https://pixabay.com/api/?key=\(myKeyId)&editors_choice=true&per_page=150&order=popular"
        //
        //        } //end of swith
        //        changedUrl(newURL: URL(string: urlString)!)
    }
    
    
    func didSelectCategory(category: [Categories]){
        //
        //        let filtredURL = "https://pixabay.com/api/?key=16834549-9bf1a2a9f7bfa54e36404be81&q=\(enumValue)&per_page=100&image_type=photo"
        //        print("selected \(enumValue) category")
        //        changedUrl(newURL: URL(string: filtredURL)!)
        //
    }
    
    
    //MARK: - end of dreopped button
    //MARK: - actions
    @IBAction func filterButtonDidTap(_ sender: UIButton) {
        guard let filterVC = storyboard?.instantiateViewController(withIdentifier: "FilterViewControllerID") else{return}
        //present(filterVC, animated: true, completion: nil)
        
        let filterViewController = filterVC as? FilterViewController
        filterViewController?.holder = self
        
        let navVC = UINavigationController(rootViewController: filterVC)
        present(navVC, animated: true, completion: nil)
        
    }
    
    
    //MARK: Methods -
    func fetch(){
        let URLSession = URLSession.shared
        let service: HTTPService = HTTPService(with: URLSessionHttpClient(session: URLSession))
        service.fetchPics(order: .popular, filterCategory: [.religion], currentPage: 1) { fetchHits  in
           
            DispatchQueue.main.async {
                self.hitsRESULT = fetchHits
                self.collectionView.reloadData()
//                let pixaViewCell = PixaViewCell()
//                pixaViewCell.activityIndicator.stopAnimating()
            } // dispatch
        }
    } // end of fetchPics
    
    // MARK: QUESTION : setImage to cell -
    func setImage(){
        //guard let url = URL(string: urlString) else{
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
        
        // let fetchedData = fetch(order: .popular, filterCategory: [.backgrounds], currentPage: 1)
        
        DispatchQueue.main.async {
            
            
            //            pixaViewCell.pixaImageOutlet.image =
            //
        }
        
    }
    
    //    func fetchHits(order : PopularLastestButton.Order , filterCategory:[Categories], currentPage:Int) {
    //
    //      HTTPService(with:
    //                self.hits.append(contentsOf:post)
    //                self.totalHits = totalHits
    //            }, order: order, selectedCategory: selectedCategory,currentPage: currentPage)
    //
    //    }
    
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PixaViewCell.cellIdentifier, for: indexPath) as? PixaViewCell else{
            return PixaViewCell()}
        
        let hitsTags = hitsRESULT[indexPath.item].tags
        
        let url = URL(string: hitsRESULT[indexPath.row].webformatURL)!
        ImageLoader(with: URLSessionHttpClient(session: URLSession.shared)).loadPics(from: url) { (image) in
            DispatchQueue.main.async {
                guard collectionView.indexPath(for: cell) == indexPath else {return }
                
                cell.pixaImageOutlet.image = image
                cell.tagsLabelOutlet.text = hitsTags
                print(image)
            }
        }
        return cell
    } // end of collectionView
    
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



