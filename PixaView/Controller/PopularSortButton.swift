//
//  PopularSortButton.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 05.12.2021.
//

import UIKit
import TestFramework

protocol SortImageProtocol: AnyObject{
    func sortImageDidTap (sortButtodDidTap sort: Order  )
    
}

enum Order: String {
    case latest
    case popular
}

//MARK: -  SortButton VC
class SortButtonViewController: UIViewController{
    
    weak var delegate: SortImageProtocol?
    
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
       return view
    }()
    
    private let sortLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.alpha = 0.6
        label.text = "Popular / Latest Sort"
        label.textAlignment = .center
        label.font = UIFont(name: "GillSans-Bold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: sort buttons -
    private let populatButton:UIButton = {
       let popularButton = UIButton()
        popularButton.backgroundColor = .blue
        popularButton.setTitle("Popular", for: .normal)
        //popularButton.tintColor = .blue
        popularButton.layer.cornerRadius = 15
        popularButton.addTarget(self, action: #selector(popularButtonTaped), for: .touchUpInside)
        popularButton.translatesAutoresizingMaskIntoConstraints = false
        popularButton.alpha = 0.6
        return popularButton
    }()

    private let latestButton:UIButton = {
       let lastestButton = UIButton()
        lastestButton.backgroundColor = .purple
        lastestButton.setTitle("Lastest", for: .normal)
        lastestButton.tintColor = .green
        lastestButton.layer.cornerRadius = 15
        lastestButton.addTarget(self, action: #selector(lastetsButtonTaped), for: .touchUpInside)
        lastestButton.translatesAutoresizingMaskIntoConstraints = false
        lastestButton.alpha = 0.8
        return lastestButton
    }()
    
    
  private  var buttonStackView = UIStackView()
    
    //MARK:  Button methods -
    @objc func popularButtonTaped(){
        delegate?.sortImageDidTap(sortButtodDidTap: .popular)
       // print("tapped")
    }
    
    @objc func lastetsButtonTaped(){
        delegate?.sortImageDidTap(sortButtodDidTap: .latest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSortView()
        setupConstraints()
        
    }

    let viewControllerSmallSortView = UIView(frame: CGRect(x: 100 , y:30 , width: 250, height: 200))

    func setupSortView(){
        title = "Select Sorting strategy"
        viewControllerSmallSortView.backgroundColor = .systemGray
       // viewControllerSmallSortView.alpha = 0.7
        
        buttonStackView = UIStackView(arrangedSubviews: [populatButton, latestButton],
                                      axis: .horizontal,
                                      spacing: 15,
                                      //alignment: .center,
                                      distribution: .fillEqually
        )
        
        self.view.addSubview(viewControllerSmallSortView)
        viewControllerSmallSortView.addSubview(backgroundView)
        backgroundView.addSubview(sortLabel)
        backgroundView.addSubview(buttonStackView)
        
    }
}



    func pixaGallerySort(_ page: Int = 1, order: Order = .popular) {
     
    } // end of method
// end of class

extension SortButtonViewController{
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            backgroundView.centerYAnchor.constraint(equalTo: viewControllerSmallSortView.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: viewControllerSmallSortView.centerXAnchor),
            backgroundView.heightAnchor.constraint(equalTo: viewControllerSmallSortView.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: viewControllerSmallSortView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sortLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            sortLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 15),
          sortLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -15),
            sortLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 15),
            sortLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            populatButton.heightAnchor.constraint(equalToConstant: 20),
            latestButton.heightAnchor.constraint(equalToConstant: 20)
            
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor,constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            buttonStackView.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: 20),
            buttonStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20)
        
        ])
    }
}
//https://proswift.ru/vspomogatelnye-inicializatory-convenience-init/ convinience init
//https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/SwifterSwift/UIKit/UIStackViewExtensions.swift
extension UIStackView{
    
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, /*alignment: UIStackView.Alignment,*/ distribution: UIStackView.Distribution) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
     //   self.alignment = alignment
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
