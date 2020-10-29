//
//  PhotosListViewModel.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import Foundation
import UIKit
import CoreData

protocol PhotosListViewModelDelegate {
    func onLoadFavoritesList()
    func onDeleteFavorite()
}

class PhotosListViewModel: PhotosListViewModelProtocol {
    
    var networkService: NetworkServiceProtocol?
    let persistanceContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate:PhotosListViewModelDelegate?
    
    private var privPhotosList = Photos()
    var photosList: Photos {
        get { return privPhotosList }
    }
    
    private var privFilteredPhotosList = Photos()
    var filteredPhotosList: Photos {
        get { return privFilteredPhotosList }
        set { privFilteredPhotosList = newValue}
    }
    
    private var privFavoritesPhotosList = [LocalPhoto]()
    var favoritesPhotosList: [LocalPhoto] {
        get { return privFavoritesPhotosList }
        set { privFavoritesPhotosList = newValue }
    }
    
    private var privFilteredFavoritesPhotosList = [LocalPhoto]()
    var filteredFavoritesPhotosList: [LocalPhoto]{
        get { return privFilteredFavoritesPhotosList }
        set { privFilteredFavoritesPhotosList = newValue }
    }
    
    init() {}
    
    private let pageSize = 10
    
    func getPhotos(page: Int, complete: @escaping (ServiceResult<Photos?>) -> Void) {
        getFavoritesPhotosList()
        
        let offset = page * pageSize
        guard let networkService = networkService else {
            return complete(.Error("Missing network service", 0))
        }
        
        let url = "\(ApiRoutes.photosUrl)?client_id=\(UnsplashConfig.access_key)&page=\(offset)"
        
        networkService.request(
                    url: url,
                    method: .get,
                    parameters: nil
                ) { [weak self] (result) in
                    if page == 0 {
                        self?.privPhotosList.removeAll()
                    }
                    switch result {
                    case .Success(let json, let statusCode):
                        do {
                            if let data = json?.data(using: .utf8) {
                                let decoder = JSONDecoder()
                                let photosResponse = try decoder.decode(Photos.self, from: data)
                                self?.privPhotosList.append(contentsOf: photosResponse)
                                return complete(.Success(self?.privPhotosList, statusCode))
                            }
                            return complete(.Error("Error parsing data", statusCode))
                        } catch {
                            print("error:\(error)")
                            return complete(.Error("Error decoding JSON", statusCode))
                        }
                    case .Error(let message, let statusCode):
                        print("case .Error :: getPhotos")
                        return complete(.Error(message, statusCode))
                    }
                }
        
    }

    func updatePhotos(complete: @escaping (ServiceResult<Photos?>) -> Void) {
        getFavoritesPhotosList()
        return complete(.Success(self.privPhotosList, 200))
    }
    
    func createFavorite(photo: Photo, complete: @escaping (ServiceResult<[LocalPhoto]?>) -> Void) {
        
        let favoritePhoto = LocalPhoto(context: self.persistanceContext)
        favoritePhoto.created_at = Date()
        favoritePhoto.id_image = photo.id
        favoritePhoto.likes_image = Int32(photo.likes ?? 0)
        favoritePhoto.lu_bio = photo.user?.bio
        favoritePhoto.lu_facebook = ""
        favoritePhoto.lu_first_name = photo.user?.firstName
        favoritePhoto.lu_instagram = photo.user?.instagramUsername
        favoritePhoto.lu_last_name = photo.user?.lastName
        favoritePhoto.lu_linkedin = ""
        favoritePhoto.lu_location = photo.user?.location
        favoritePhoto.lu_name = photo.user?.name
        favoritePhoto.lu_total_collections = Int32(photo.user?.totalCollections ?? 0)
        favoritePhoto.lu_total_likes = Int32(photo.user?.totalLikes ?? 0)
        favoritePhoto.lu_total_photos = Int32(photo.user?.totalPhotos ?? 0)
        favoritePhoto.lu_twitter = photo.user?.twitterUsername
        favoritePhoto.lu_user_id = photo.user?.id
        favoritePhoto.lu_user_profile_image = photo.user?.profileImage?.medium
        favoritePhoto.lu_username = photo.user?.username
        favoritePhoto.url_image = photo.urls?.full
        
        do {
            try self.persistanceContext.save()
            getFavoritesPhotosList()
            return complete(.Success(self.privFavoritesPhotosList, 200))
        } catch {
            return complete(.Error("Error: Data not saved", 500))
        }
        
    }
    
    func deleteFavorite(id_image: String, complete: @escaping (ServiceResult<[LocalPhoto]?>) -> Void) {        
        let fetchRequest: NSFetchRequest<LocalPhoto> = LocalPhoto.fetchRequest()
        let predicate = NSPredicate(format: "\(#keyPath(LocalPhoto.id_image)) == %@", id_image)
        fetchRequest.predicate = predicate
        let objects = try! persistanceContext.fetch(fetchRequest)
        if objects.isEmpty {return}
        for object in objects {
            persistanceContext.delete(object)
        }
        
        do {
            try self.persistanceContext.save()
            getFavoritesPhotosList()
            delegate?.onDeleteFavorite()
            return complete(.Success(self.privFavoritesPhotosList, 200))
        } catch _ {
            // error handling
            return complete(.Error("Error Post not deleted", 500))
        }
       
    }

    
    func getFavoritesPhotosList(){
        do {
            self.privFavoritesPhotosList = try persistanceContext.fetch(LocalPhoto.fetchRequest())
            self.delegate?.onLoadFavoritesList()
        }catch{
            print("error:\(error)")
        }
    }
    
    
    
    func isFavorite(id_image:String) -> Bool {
        for localImage in privFavoritesPhotosList {
            if id_image == localImage.id_image{
                return true
            }
        }
        return false
    }
    
    
}
