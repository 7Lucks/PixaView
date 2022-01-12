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
    
    
    //MARK:  Properties -
    var hitsRESULT: [Hits] = [] //array from json
    var enumValue = ""
    var order: Order = .popular
    var category: [Categories] = [.computer]
    var currentPage = 1
    var total = 0
    var collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    //MARK:  viewDidLoad -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sortButton = navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.circle"), style: .plain, target: self, action: #selector(pixaSortButton))
        setupCollectionView()
        fetch(order: order, currentPage: currentPage, filterCategory: category)
    }
    
    //MARK: - view will layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.current.orientation.isLandscape {
            landscapeLayoutCollectionView()
        }else if UIDevice.current.orientation.isPortrait{
            portaitCollectionView()
        }
    }

    // pixa sort button
    @objc private func pixaSortButton(){
        dismiss(animated: true, completion: nil)
        
        let sortButtonVC = SortButtonVC()
        sortButtonVC.sortImageDelegate = self
        self.present(sortButtonVC, animated: true)
    }
    
    //MARK: - actions
    //filterButtonDidTap
    @IBAction func filterButtonDidTap(_ sender: UIButton) {
        
        guard let filterVC = storyboard?.instantiateViewController(withIdentifier: "FilterViewControllerID") else{return}
        let filterViewController = filterVC as? TableFilterVC
        filterViewController?.holder = self
        filterViewController?.tableViewFilterSelectedDelegate = self
        
        let navVC = UINavigationController(rootViewController: filterVC)
        self.present(navVC, animated: true, completion: nil)
        filterViewController?.selectedCategories = category
    } //end of filterButtonDidTap
    
    //MARK: <Methods>-
    
    // collection view setup
    private func setupCollectionView(){
        self.collectionView.register(UINib(nibName: PixaViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PixaViewCell.cellIdentifier) //assign to cell the Xib file
        self.collectionView.dataSource = self //the cell need to understand where to get the filling from. add protocol to extension - UICollectionViewDataSource
        self.collectionView.delegate = self //delegate with collectionView. Subscribe to UICollectionViewDelegate as delegate
    }
    
    //MARK: - Fetch data
    func fetch(order: Order, currentPage: Int, filterCategory: [Categories]){
        let URLSession = URLSession.shared
        let service: HTTPService = HTTPService(with: URLSessionHttpClient(session: URLSession))
        //            service.fetchPics(order: order, filterCategory: filterCategory, currentPage: currentPage) { fetchedHits, total in
        service.fetchPics(order: order, filterCategory: filterCategory, currentPage: currentPage) {result in
            
            switch result{
            case .success(( let hitsRESULT, let total )):
                DispatchQueue.main.async {
                    self.total = total
                    self.hitsRESULT.append(contentsOf: hitsRESULT)
                    self.collectionView.reloadData()
                } // dispatch
                
            case .failure(let error):
                DispatchQueue.main.async {
                    let error = error.localizedDescription
                    let alert = UIAlertController(title: "Алярм", message: error, preferredStyle: .alert)
                    let  retry = UIAlertAction.init(title: "понял принял", style: .default) { _ in
                        self.fetch(order: order, currentPage: currentPage, filterCategory: filterCategory)
                    }
                    //alert.addAction(okButton)
                    alert.addAction(retry)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            } // end of fetchPics
        }
    }
//End of <Methods>
} // end of PixaViewController class

//MARK: Extensions -
extension PixaViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TableFilterViewControllerDelegate, SortImageProtocol {
    
    //MARK: delegates for filter / sort -
    //filter delegate
    func filterButtonDidTap(filterCategory: [Categories]) {
        hitsRESULT.removeAll()
        currentPage = 1
        fetch(order: order, currentPage: currentPage , filterCategory: filterCategory)
        category = filterCategory
        print(filterCategory)
    }
    
    //sort image delegate
    func sortInTableDidTap(sortButtodDidTap sort: Order) {
        hitsRESULT.removeAll()
        currentPage = 1
        fetch(order: sort, currentPage: currentPage, filterCategory: category)
        order = sort
        print(sort)
    }
    //MARK: - end of sort/filter delegates
    
    
    
    //MARK: - collection view setup -
    // number of cells numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hitsRESULT.count
    }// end of numberOfItemsInSection
    
    // type of the cells
    //cellForItemAt indexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PixaViewCell.cellIdentifier, for: indexPath) as? PixaViewCell else{
            return PixaViewCell()
        }
        
        //tags
        let hitsTags = hitsRESULT[indexPath.item].tags
        //url
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

    //MARK: - new image size and rotation
    // https://stackoverflow.com/questions/38894031/swift-how-to-detect-orientation-changes
    //view Will Transition
    //https://stackoverflow.com/questions/37152071/landscape-orientation-for-collection-view-in-swift
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            coordinator.animate (alongsideTransition: { (_) in
                self.landscapeLayoutCollectionView()
            }, completion: nil )
        case .portrait, .portraitUpsideDown:
            coordinator.animate (alongsideTransition: { (_) in
                self.portaitCollectionView()
            }, completion: nil )
        default:
            print("error")
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    //https://stackoverflow.com/questions/38894031/swift-how-to-detect-orientation-changes
    
    // Portrait orientation
    private func portaitCollectionView(){
        let numberOfItemsPerRow : CGFloat = 1
        let lineSpacing:CGFloat = 5
        let interItemSpacing :CGFloat = 5
        let width = ( collectionView.frame.width - CGFloat((numberOfItemsPerRow)) * interItemSpacing) / numberOfItemsPerRow
        let height = width
        
        collectionViewFlowLayout .sectionInsetReference = .fromSafeArea
        collectionViewFlowLayout.collectionView?.contentMode = .scaleAspectFit
        collectionViewFlowLayout.itemSize = CGSize (width: width, height: height)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = lineSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
        collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
    }
    
    // Landscape orientation
    private func landscapeLayoutCollectionView(){
       
        let numberOfItemsInRow: CGFloat = 2
        let lineSpacing: CGFloat = 2
        let interItemSpacing: CGFloat = 2
        
        collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = lineSpacing
        collectionViewFlowLayout .sectionInsetReference = .fromSafeArea
        collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
        
        let width = ( collectionView.frame.width - CGFloat((numberOfItemsInRow - 1)) * interItemSpacing) / numberOfItemsInRow
        let height = width
        
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
        collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
    }
    
    // didSelectItemAt indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //какие данные хотим передать
        let cellImage = (collectionView.cellForItem(at: indexPath) as? PixaViewCell)?.pixaImageOutlet.image
        let cellTags = (collectionView.cellForItem(at: indexPath) as? PixaViewCell)?.tagsLabelOutlet.text
        
        let vc = (storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as? DetailedViewController)!
        
        vc.tags = hitsRESULT[indexPath.row].tags
        vc.detailedPictures = cellImage
        vc.tags = cellTags ?? "No tags"
        
        self.navigationController?.pushViewController(vc, animated: true)
    } //end of didSelectItemAt indexPath
    
    
    // willDisplay cell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == hitsRESULT.count-1 && hitsRESULT.count != total{
            currentPage = currentPage + 1
            fetch(order: order, currentPage: currentPage, filterCategory: category)
        }
    } //end of  willDisplay cell
    
}// end of Extensions



