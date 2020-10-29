//
//  PhotosListViewController.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import UIKit
import NVActivityIndicatorView


class PhotosListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var photosListViewModel:PhotosListViewModelProtocol?
    
    private var isPullingUp = false
    private var loadingData = false
    private let preloadCount = 10
    private var _noFurtherData = false
    private var _page = -1
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
    var searchView:SearchUtil?
    
    var window: UIWindow?
    var loading:NVActivityIndicatorView!
    var coverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photosListViewModel = PhotosListViewModel()
        NetworkService.get.afSessionManager = AFSessionManager()
        photosListViewModel.networkService = NetworkService.get
        self.photosListViewModel = photosListViewModel as PhotosListViewModelProtocol
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCellId")
        
        self.collectionView?.register(PhotosListCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.hideKeyboardWhenTappedAround()
                
        computeSizes()
        loadNextPage()
        
        addSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePage()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func computeSizes() {
        screenWidth = UIScreen.main.bounds.width
        photoCellSize = (screenWidth - 50.0) / 2.0
        photoCellSizeStyle1_width = screenWidth - 25.0
        photoCellSizeStyle1_height = (screenWidth - 50.0) / 2.0
        loadingCellSize = screenWidth - 40.0
    }

    func loadNextPage(reset:Bool = false) {
        if loadingData || _noFurtherData {
            return
        }
        if reset {
            _page = -1
        }
        _page += 1
        loadingData = true
        let previousCount = isSearching ? photosListViewModel?.filteredPhotosList.count ?? 0 : photosListViewModel?.photosList.count ?? 0
        
        photosListViewModel?.getPhotos(page: _page) { [weak self] (result) in
            self?.isPullingUp = false
            self?.loadingData = false
            switch result {
            case .Success(_, _):
                self?.collectionView?.reloadData()
                let count = self?.isSearching ?? false ? self?.photosListViewModel?.filteredPhotosList.count ?? 0 : self?.photosListViewModel?.photosList.count ?? 0
                                
                if count == previousCount {
                    self?._noFurtherData = true
                }
            case .Error(let message, let statusCode):
                print("Error \(message) \(statusCode ?? 0)")
            }
        }
    }
    
    func updatePage() {
        photosListViewModel?.updatePhotos(complete: {_ in
            self.collectionView?.reloadData()
        })
        
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

extension PhotosListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching{
            return photosListViewModel?.filteredPhotosList.count ?? 0
        }
        return (photosListViewModel?.photosList.count ?? 0)
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let listCount = isSearching ? photosListViewModel?.filteredPhotosList.count ?? 0 : photosListViewModel?.photosList.count ?? 0
        
        if (indexPath.row >= (listCount) - preloadCount) && !loadingData { loadNextPage() }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotosListCollectionViewCell
        let viewModelItem = isSearching ? photosListViewModel!.filteredPhotosList[indexPath.row] : photosListViewModel!.photosList[indexPath.row]
        
        cell.width = photoCellSizeStyle1_width
        cell.height = photoCellSizeStyle1_height
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.setData(photo:viewModelItem, viewModel: photosListViewModel as! PhotosListViewModel)
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCellId", for: indexPath)
        return header
    }
    
}

extension PhotosListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoDetailViewController.instantiateFromXIB() as PhotoDetailViewController
        if let dataItem = photosListViewModel?.photosList[indexPath.row] {
            self.presentWithStyle1(vcFrom: self, vcTo: vc)
            vc.photo = dataItem
            vc.originFav = false
        }
    }
}

extension PhotosListViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = photoCellSize
        currentCellWidth = size
        currentCellHeight = size + 50
        
        if indexPath.row == 0 {
            currentCellWidth = photoCellSizeStyle1_width
            currentCellHeight = photoCellSizeStyle1_height
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isPullingUp {
            return
        }
        let scrollThreshold:CGFloat = 10
        let scrollDelta = (scrollView.contentOffset.y + scrollView.frame.size.height) - scrollView.contentSize.height
        if  scrollDelta > scrollThreshold {
            isPullingUp = true
            loadNextPage()
        }
    }
    
}

extension PhotosListViewController : UISearchBarDelegate{
    
    func addSearch(){
        searchView = SearchUtil.init(frame: CGRect(x: 0, y: 0, width: Int(view.frame.size.width), height: searchBarHeight))
        searchView = searchView?.getSearchBar(delegate: self as UISearchBarDelegate) as? SearchUtil
        searchView?.resignFirstResponder()
        view.addSubview(searchView!)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {}
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isEditing = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isEditing = false
        searchBar.text = ""
        loadNextPage(reset: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isEditing = false
        isSearching = true
        photosListViewModel?.filteredPhotosList.removeAll(keepingCapacity: false)
        let predicateString = searchBar.text!.lowercased()
        let newList = (self.photosListViewModel?.photosList.filter({($0.user?.username.lowercased().contains(predicateString) ?? false) || ($0.user?.name.lowercased().contains(predicateString) ?? false) }))
        self.photosListViewModel?.filteredPhotosList = newList ?? []
        self.photosListViewModel?.filteredPhotosList.sort {$0.user?.username ?? "" < $1.user?.username ?? ""}

        self.isSearching = (self.photosListViewModel?.filteredPhotosList.count == 0) ? false: true
        self.collectionView.reloadData()
        
        if photosListViewModel?.filteredPhotosList.count == 0 {
            self.searchView?.setNoResultsMessageSearch(viewController: self)
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == ""{
            isSearching = false
            loadingData = false
            _noFurtherData = false
            loadNextPage(reset: true)
        }
        
    }
    
}

