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
    var categogies: [Categories] = [.computer]
    var viewPage = 1
    var total = 0
    
    var collectionViewFlowLayout = UICollectionViewFlowLayout()
    //MARK: - end of Properties
    
    
    
    //MARK:  viewDidLoad -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sortButton = navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.circle"), style: .plain, target: self, action: #selector(pixaSortButton))
        setupCollectionView()
        // setupCollectionViewItemSize()
        // setupCollectionViewLayout()
//        landscapeLayoutCollectionView()
        
        fetch(order: order, currentPage: viewPage, filterCategory: categogies)
    }
    //MARK: - End of viewDidLoad
    
    
    
    
    //MARK: - view will layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice.current.orientation.isLandscape {
            landscapeLayoutCollectionView()
        }else if UIDevice.current.orientation.isPortrait{
            portaitCollectionView()
        }
    }
    
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//    }
//
//
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
        
    } //end of filterButtonDidTap
    
    
    //MARK: <Methods>
    
    // collection view setup
    private func setupCollectionView(){
        self.collectionView.register(UINib(nibName: PixaViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PixaViewCell.cellIdentifier) //assign to cell the Xib file
        self.collectionView.dataSource = self //the cell need to understand where to get the filling from. add protocol to extension - UICollectionViewDataSource
        self.collectionView.delegate = self //delegate with collectionView. Subscribe to UICollectionViewDelegate as delegate
    }
    
    
    //MARK: - fetch data
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
                self.alertError(title: "Error", message: "Connection lost, please try again - \(error)")
                }
            } // end of fetchPics
        }
    }
    
    //MARK: - End of <Methods>
} // end of PixaViewController class

//MARK: Extensions -
extension PixaViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TableFilterViewControllerDelegate, SortImageProtocol {
    
    
    //MARK: delegates for filter / sort -
    //filter delegate
    func filterButtonDidTap(filterCategory: [Categories]) {
        hitsRESULT.removeAll()
        viewPage = 1
        fetch(order: order, currentPage: viewPage , filterCategory: filterCategory)
        categogies = filterCategory
        print(filterCategory)
    }
    
    // когда  передаем енам в метод, передаем переменную которая создаеся в методе в этом случае sort !!
    //sort image delegate
    func sortInTableDidTap(sortButtodDidTap sort: Order) {
        hitsRESULT.removeAll()
        viewPage = 1
        fetch(order: sort, currentPage: viewPage, filterCategory: categogies)
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
    
    //MARK: image size default -
    // cell cizes  // as diasplay // vertical
    //collectionViewLayout
    //            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //                return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width )
    //            }// end of collectionViewLayout
    //
    
    //MARK: - new image size and rotation
    // https://stackoverflow.com/questions/38894031/swift-how-to-detect-orientation-changes
    //    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //        coordinator.animate(alongsideTransition: { (_) in
    //            self.horisontalLayoutCollectionView()
    //        }, completion: nil)
    //
    //        super.viewWillTransition(to: size, with: coordinator)
    //    }
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
        
//        if UIDevice.current.orientation.isLandscape {
//          //  print("Landscape")
//            landscapeLayoutCollectionView()
//
//        } else {
//         //   print("Portrait")
//            portaitCollectionView()
//        }
    }
    
    //https://stackoverflow.com/questions/38894031/swift-how-to-detect-orientation-changes
    private func portaitCollectionView(){
        //collectionViewFlowLayout = UICollectionViewFlowLayout()
        
        //        let layout = UICollectionViewFlowLayout()
        //        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        
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
    
    
    
    private func landscapeLayoutCollectionView(){
        
        //if collectionViewFlowLayout == nil{
        let numberOfItemsInRow: CGFloat = 2
        let lineSpacing: CGFloat = 2
        let interItemSpacing: CGFloat = 2
        collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = lineSpacing
        collectionViewFlowLayout .sectionInsetReference = .fromSafeArea
        collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
        
        let width = ( collectionView.frame.width - CGFloat((numberOfItemsInRow - 1)) * interItemSpacing) / numberOfItemsInRow
//        let width = 300
        let height = width
        
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
        collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        //  }
        
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
        // print("index path is \(indexPath.row)")
    
        if indexPath.row == hitsRESULT.count-1 && hitsRESULT.count != total{
            viewPage = viewPage + 1
            fetch(order: order, currentPage: viewPage, filterCategory: categogies)
            //  print("view page is \(viewPage)")
            //  print("called paggination")
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            //                self.fetch(order: order, currentPage: viewPage, filterCategory: categogies)
            //            }
        }
    } //end of  willDisplay cell
    
}// end of Extensions



