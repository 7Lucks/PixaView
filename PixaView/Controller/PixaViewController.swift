//
//  PixaViewController.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 27.11.2021.
//

import UIKit
import TestFramework

class PixaViewController: UIViewController{
    
    //MARK: Outlets -
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: - end of Outlets
    
    //MARK:  Properties -
    var hitsRESULT: [Hits] = [] //array from json
    var enumValue = ""
    var order: Order = .popular
    var categogies: [Categories] = [.backgrounds]
    var viewPage = 1
    //var orderSelected
    //MARK: - end of Properties
    
    //MARK:  viewDidLoad -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: PixaViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PixaViewCell.cellIdentifier) //assign to cell the Xib file
        self.collectionView.dataSource = self //the cell need to understand where to get the filling from. add protocol to extension - UICollectionViewDataSource
        self.collectionView.delegate = self //delegate with collectionView. Subscribe to UICollectionViewDelegate as delegate
        
        let sortButton = navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.circle"), style: .plain, target: self, action: #selector(pixaSortButton))
        fetch(order: order, filterCategory: categogies)
    }
    //MARK: - End of viewDidLoad
    
    @objc private func pixaSortButton(){
        dismiss(animated: true, completion: nil)
    
        let sortButtonVC = SortButtonVC()
        sortButtonVC.sortImageDelegate = self
        self.present(sortButtonVC, animated: true)
    }
    
    
    //MARK: - actions
    @IBAction func filterButtonDidTap(_ sender: UIButton) {
        
        guard let filterVC = storyboard?.instantiateViewController(withIdentifier: "FilterViewControllerID") else{return}
        let filterViewController = filterVC as? TableFilterVC
        filterViewController?.holder = self
        filterViewController?.tableViewFilterSelectedDelegate = self
        
        let navVC = UINavigationController(rootViewController: filterVC)
        self.present(navVC, animated: true, completion: nil)
        
    }
    
    //MARK: <Methods>
    
    
    
    //MARK: - fetch data
    func fetch(order: Order,filterCategory: [Categories]){
        let URLSession = URLSession.shared
        let service: HTTPService = HTTPService(with: URLSessionHttpClient(session: URLSession))
        service.fetchPics(order: order, filterCategory: filterCategory, currentPage: 1) { fetchHits  in
            
            DispatchQueue.main.async {
                self.hitsRESULT = fetchHits
                self.collectionView.reloadData()
            } // dispatch
        }
    } // end of fetchPics
    
    
    
    //MARK: - End of <Methods>
} // end of PixaViewController class

//MARK: Extensions -
extension PixaViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TableFilterViewControllerDelegate, SortImageProtocol {
    
    //filter delegate
    func filterButtonDidTap(filterCategory: [Categories]) {
        fetch(order: order , filterCategory: filterCategory)
        
        categogies = filterCategory
        print(filterCategory)
    }
    
    // когда  передаем енам в метод, передаем переменную которая создаеся в методе в этом случае sort !!
    //sort image delegate
    func sortInTableDidTap(sortButtodDidTap sort: Order) {
        fetch(order: sort, filterCategory: categogies)
        order = sort
        print(sort)
    }
    
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
        cell.activityIndicator.startAnimating()
        ImageLoader(with: URLSessionHttpClient(session: URLSession.shared)).loadPics(from: url) { (image) in
            DispatchQueue.main.async {
                guard collectionView.indexPath(for: cell) == indexPath else {return }
                
                cell.pixaImageOutlet.image = image
                cell.tagsLabelOutlet.text = hitsTags
                cell.activityIndicator.stopAnimating()
            }
        }
        return cell
    } // end of cellForItemAt indexPath
    
    // cell cizes  // as diasplay // vertical
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width )  // need to check
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //MARK: какие данные хотим передать
        let cellImage = (collectionView.cellForItem(at: indexPath) as? PixaViewCell)?.pixaImageOutlet.image
        let cellTags = (collectionView.cellForItem(at: indexPath) as? PixaViewCell)?.tagsLabelOutlet.text
        
        let vc = (storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as? DetailedViewController)!
        
        vc.tags = hitsRESULT[indexPath.row].tags
        vc.detailedPictures = cellImage
        vc.tags = cellTags ?? "No tags"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // print("index path is \(indexPath.row)")
        
        
        viewPage = viewPage + 1
        if indexPath.row == hitsRESULT.count-1 {
          
          //  print("called paggination")
           // fetch(order: order, filterCategory: categogies)
        }
    }
}// end of Extensions



