//
//  FavoritesViewController.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import UIKit
import NVActivityIndicatorView

class FavoritesViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var photosListViewModel:PhotosListViewModelProtocol?
    var photosListCollectionViewCell:PhotosListCollectionViewCell?
    private var currentCellWidth:CGFloat = 0
    private var currentCellHeight:CGFloat = 0
    private var photoCellSize: CGFloat = 0
    private var photoCellSizeStyle1_width: CGFloat = 0
    private var photoCellSizeStyle1_height: CGFloat = 0
    private var photoCellSizeStyle2_width: CGFloat = 0
    private var photoCellSizeStyle2_height: CGFloat = 0
    private var screenWidth: CGFloat = 0
    private var loadingCellSize: CGFloat = 0
    
    private let searchBarHeight:Int = 60
    var isSearching : Bool = false
    var searchView: SearchUtil?
    var search:UISearchBar?
    
    var window: UIWindow?
    var loading:NVActivityIndicatorView!
    var coverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let photosListViewModel = PhotosListViewModel()
        NetworkService.get.afSessionManager = AFSessionManager()
        photosListViewModel.networkService = NetworkService.get
        self.photosListViewModel = photosListViewModel as PhotosListViewModelProtocol
        collectionView.register(NoFavoritesFoundCVCell.self,
                forCellWithReuseIdentifier: "noFavoritesFound")
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCellId")
        
        self.collectionView?.register(PhotosListCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.hideKeyboardWhenTappedAround()
        photosListViewModel.delegate = self

        computeSizes()
        addSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photosListViewModel?.getFavoritesPhotosList()
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func computeSizes() {
        screenWidth = UIScreen.main.bounds.width
        photoCellSize = (screenWidth - 50.0) / 2.0
        photoCellSizeStyle1_width = screenWidth - 25.0
        photoCellSizeStyle1_height = (screenWidth - 25.0) / 2.0
        loadingCellSize = screenWidth - 40.0
    }

    func loadNextPage(reset:Bool = false) {
        let previousCount = isSearching ? photosListViewModel?.filteredFavoritesPhotosList.count ?? 0 : photosListViewModel?.favoritesPhotosList.count ?? 0
        self.collectionView?.reloadData()
    }
    
    func setActivityIndicatorConfig(){
        let view = UIView(frame: self.tabBarController?.view.frame ?? self.view.frame)
        coverView = view
        coverView.backgroundColor = .black
        coverView.alpha = 0.0
        loading = NVActivityIndicatorView(frame: coverView.frame, type: .ballSpinFadeLoader, color: .systemGray, padding: self.view.frame.width / 3)
        coverView.addSubview(loading)
        self.tabBarController?.view.addSubview(coverView)

        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.coverView.alpha = 0.8
        }, completion: nil)
        
        coverView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loading.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        loading.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func startActivityIndicator(){
        self.loading.startAnimating()
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
                self.coverView?.alpha = 0.8
        })
    }
    
    func stopActivityIndicator(){
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 3){
            UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.coverView?.alpha = 0
            }) { (_) in
                    self.loading.stopAnimating()
            }
            
        }
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching{
            return photosListViewModel?.filteredFavoritesPhotosList.count ?? 0
        } else
        
        if photosListViewModel?.favoritesPhotosList.count == 0 {
            return 1
        } else { return (photosListViewModel?.favoritesPhotosList.count ?? 0) }
        
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let listCount = isSearching ? photosListViewModel?.filteredFavoritesPhotosList.count ?? 0 : photosListViewModel?.favoritesPhotosList.count ?? 0
        
        let noRowsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "noFavoritesFound", for: indexPath) as! NoFavoritesFoundCVCell
        
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PhotosListCollectionViewCell  else {
            return noRowsCell
        }
        if listCount == 0{
            return noRowsCell
        }else{
            let viewModelItem = isSearching ? photosListViewModel!.filteredFavoritesPhotosList[indexPath.row] : photosListViewModel!.favoritesPhotosList[indexPath.row]
            photoCell.width = photoCellSizeStyle1_width
            photoCell.height = photoCellSizeStyle1_height
            photoCell.contentView.layer.cornerRadius = 10
            photoCell.contentView.layer.borderWidth = 1.0
            photoCell.contentView.layer.borderColor = UIColor.clear.cgColor
            photoCell.contentView.layer.masksToBounds = true
            photoCell.setData(photo:viewModelItem, viewModel: photosListViewModel as! PhotosListViewModel)
            return photoCell
        }
        
    }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCellId", for: indexPath)
        return header
    }
    
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoDetailViewController.instantiateFromXIB() as PhotoDetailViewController
        if let dataItem = photosListViewModel?.favoritesPhotosList[indexPath.row] {
            self.presentWithStyle1(vcFrom: self, vcTo: vc)
            vc.localPhoto = dataItem
            vc.originFav = true
        }
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        currentCellWidth = photoCellSizeStyle1_width
        currentCellHeight = photoCellSizeStyle1_height
       
        if photosListViewModel?.favoritesPhotosList.count == 0 {
            currentCellWidth = self.view.frame.width
            currentCellHeight = self.view.frame.height / 2
        }
        
        return CGSize(width: currentCellWidth, height: currentCellHeight)
            
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: CGFloat(searchBarHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: loadingCellSize, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
        
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 0.0, right: 10.0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
    
}

extension FavoritesViewController:PhotosListViewModelDelegate {
    func onDeleteFavorite() {
        collectionView.reloadData()
        if isSearching {
            self.search?.becomeFirstResponder()
            search?.delegate?.searchBar?(search!, textDidChange: (search?.text)!)
        }
        
    }
    
    func onLoadFavoritesList() {
        collectionView.reloadData()
    }
    
}

extension FavoritesViewController : UISearchBarDelegate{
    
    func addSearch(){
        searchView = SearchUtil.init(frame: CGRect(x: 0, y: 0, width: Int(view.frame.size.width), height: searchBarHeight))
        searchView = searchView?.getSearchBar(delegate: self as UISearchBarDelegate) as! SearchUtil
        searchView?.resignFirstResponder()
        view.addSubview(searchView!)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {}
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isEditing = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isEditing = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isEditing = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == ""{
            isSearching = false
            collectionView.reloadData()
        }else{
            search = searchBar
            isSearching = true
            photosListViewModel?.filteredFavoritesPhotosList.removeAll(keepingCapacity: false)
            let predicateString = searchBar.text!.lowercased()
            let newList = (self.photosListViewModel?.favoritesPhotosList.filter({($0.lu_username?.lowercased().contains(predicateString) ?? false) || ($0.lu_name?.lowercased().contains(predicateString) ?? false) }))
            self.photosListViewModel?.filteredFavoritesPhotosList = newList ?? []
            
            self.photosListViewModel?.filteredFavoritesPhotosList.sort {$0.lu_username ?? "" < $1.lu_username ?? ""}

            self.isSearching = (self.photosListViewModel?.filteredFavoritesPhotosList.count == 0) ? false: true
            self.collectionView.reloadData()
            
            if photosListViewModel?.filteredFavoritesPhotosList.count == 0 {
                self.searchView?.setNoResultsMessageSearch(viewController: self)
                collectionView.reloadData()
            }
        }
        
    }
    
 
}
