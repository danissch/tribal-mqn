//
//  PhotosListViewModelProtocol.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import Foundation

protocol PhotosListViewModelProtocol{
    var photosList: Photos { get }
    var filteredPhotosList:Photos { get set }
    
    var favoritesPhotosList:[LocalPhoto] { get set }
    var filteredFavoritesPhotosList:[LocalPhoto] { get set}

//    var localUsers:[LocalUser] {get set}
    
//    func createFavorite(photo:Photo, originFav:Bool,
//                        completeFromFav: @escaping (ServiceResult<[LocalPhoto]?>) -> Void,
//                        completeFromList: @escaping (ServiceResult<Photos?>) -> Void)
//
//    func deleteFavorite(photo:Photo, originFav:Bool,
//                        completeFromFav: @escaping (ServiceResult<[LocalPhoto]?>) -> Void,
//                        completeFromList: @escaping (ServiceResult<Photos?>) -> Void)
    func getFavoritesPhotosList()
    func createFavorite(photo:Photo, complete: @escaping (ServiceResult<[LocalPhoto]?>) -> Void)
    
    func deleteFavorite(id_image:String, complete: @escaping (ServiceResult<[LocalPhoto]?>) -> Void)
    
    func getPhotos(page: Int, complete: @escaping (ServiceResult<Photos?>) -> Void)
    func updatePhotos(complete: @escaping (ServiceResult<Photos?>) -> Void)
    
}
