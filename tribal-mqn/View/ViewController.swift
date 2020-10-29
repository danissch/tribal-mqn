//
//  ViewController.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 24/10/20.
//

import UIKit
//import Kingfisher

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photosListViewModel:PhotosListViewModelProtocol?
    
    private var isPullingUp = false
    private var loadingData = false
    private let preloadCount = 10
    private var _isFirstLoading = true
    private var _noFurtherData = false
    private var _page = -1
    private var photoCellSize: CGFloat = 0
    private var screenWidth: CGFloat = 0
    private var loadingCellSize: CGFloat = 0
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let photosListViewModel = PhotosListViewModel()
        NetworkService.get.afSessionManager = AFSessionManager()
        photosListViewModel.networkService = NetworkService.get
        self.photosListViewModel = photosListViewModel as PhotosListViewModelProtocol

        self.window?.rootViewController = self
        self.window?.makeKeyAndVisible()
        
        computeSizes()
        loadNextPage()
        
    }
    
    private func computeSizes() {
        print("computeSizes CharacterListViewController!!!")
        screenWidth = UIScreen.main.bounds.width
        
        // 2 * 10.0 = 20.0 --> external border
        // 2 * 10.0 = 20.0 --> internal border
        //     10.0 = 10.0 --> border between 2 cells
        // sum      = 50.0
        // divide by 2.0, since there are 2 columns
        photoCellSize = (screenWidth - 50.0) / 2.0
        
        // 2 * 10.0 = 20.0 --> external border
        // 2 * 10.0 = 20.0 --> internal border
        // sum      = 40.0
        loadingCellSize = screenWidth - 40.0
    }

    func loadNextPage() {
            print("loadNextPage!!!")
            if loadingData || _noFurtherData {
                return
            }
            _page += 1
            loadingData = true
            let previousCount = photosListViewModel?.photosList.count ?? 0
            photosListViewModel?.getPhotos(page: _page) { [weak self] (result) in
                self?._isFirstLoading = false
                self?.isPullingUp = false
                self?.loadingData = false
                switch result {
                case .Success(_, _):
                    self?.collectionView?.reloadData()
                    let count = self?.photosListViewModel?.photosList.count ?? 0
                    if count == previousCount {
                        self?._noFurtherData = true
                    }
                case .Error(let message, let statusCode):
                    print("Error \(message) \(statusCode ?? 0)")
                }
            }
        }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            print("numberOfSections CharacterListViewController!!!")
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            print("collectionView CharacterListViewController!!!")
            return _isFirstLoading ? 1 : (photosListViewModel?.photosList.count ?? 0)
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            print("collectionView cellForItemAt CharacterListViewController!!!")
            if _isFirstLoading {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath)
            }
            if (indexPath.row >= (photosListViewModel?.photosList.count ?? 0) - preloadCount) && !loadingData {
                loadNextPage()
            }
            
            return UICollectionViewCell()
        }

    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = _isFirstLoading ? loadingCellSize : photoCellSize
            return CGSize(width: size, height: size)
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: loadingCellSize, height: 32)
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: loadingCellSize, height: 10)
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10.0
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
            let scrollThreshold:CGFloat = 30
            let scrollDelta = (scrollView.contentOffset.y + scrollView.frame.size.height) - scrollView.contentSize.height
            if  scrollDelta > scrollThreshold {
                isPullingUp = true
                loadNextPage()
            }
        }
    
}
