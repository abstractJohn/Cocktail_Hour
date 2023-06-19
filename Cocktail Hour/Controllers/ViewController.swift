//
//  ViewController.swift
//  Cocktail Hour
//
//  Created by John Nelson on 6/12/23.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    
    var collectionView: UICollectionView?
    var titleLabel: PaddingLabel?
    var searchBox: UISearchBar?
    private var pendingRequestWorkItem: DispatchWorkItem?
    var cocktails: [Cocktail] = []
    
    let cellId = "cocktailCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let guide = view.safeAreaLayoutGuide
        titleLabel = PaddingLabel(frame: CGRect(origin: guide.layoutFrame.origin, size: CGSize(width: guide.layoutFrame.width, height: 150)))
        titleLabel?.text = "Search"
        titleLabel?.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(titleLabel ?? UILabel())
        titleLabel?.backgroundColor = .white
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        titleLabel?.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        titleLabel?.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        searchBox = UISearchBar()
        view.addSubview(searchBox ?? UISearchBar())
        searchBox?.placeholder = "Search Cocktail"
        searchBox?.searchBarStyle = .prominent
        searchBox?.delegate = self
        searchBox?.translatesAutoresizingMaskIntoConstraints = false
        searchBox?.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor).isActive = true
        searchBox?.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        searchBox?.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.width, height: 135)
                
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.register(CocktailListCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        view.addSubview(collectionView ?? UICollectionView())
        collectionView?.backgroundColor = .white
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: searchBox!.bottomAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true
        
        searchBox?.becomeFirstResponder()
        
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cocktails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CocktailListCell
        cell.setupView(cocktail: cocktails[indexPath.row])
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            //Open Detail view
        let cocktail = cocktails[indexPath.row]
        print("Open Detail View for \(cocktail.name)")
        var detailView: DetailViewController?
        
        CocktailDetail.load(from: cocktail.id) { cocktail in
            detailView = DetailViewController(cocktail: cocktail)
            if let sheet = detailView?.sheetPresentationController {
                sheet.detents = [.large()]
                
            }
            self.present(detailView!, animated: true, completion: nil)
        }
        
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.loadSearchResults(query: searchText)
        }
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000), execute: requestWorkItem)
    }
    
    func loadSearchResults(query: String) {
        Cocktail.cocktails(matching: query) { cocktails in
            self.cocktails = cocktails
            DispatchQueue.main.async { [weak self] in
                self?.collectionView?.reloadData()
            }
        }
    }
}

