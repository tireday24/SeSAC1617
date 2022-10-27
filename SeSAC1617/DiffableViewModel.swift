//
//  DiffableViewModel.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/20.
//

import Foundation
import RxSwift

enum SearchError: Error {
    case noPhoto
    case serverError
}

class DiffableViewModel {
    
    //var photoList: CObservable<SearchPhoto> = CObservable(SearchPhoto(total: 0, totalPages: 0, results: []))
    
    var photoList = PublishSubject<SearchPhoto>()
    
    
    func requestSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { [weak self] photo, statusCode, error in
            
            //error complete 끝나면 바로 dispose 됨 (구독 해제가됨) 네트워크가 잘되는 환경에 다시 와도 구독하기가 어렵다
            //구독을 원하는 시점에 다시 구독 시키거나
            //디스포즈 되지 않게 네트워크에 맞는 특성을 활용을 하거나(Trait)
            guard let statusCode = statusCode, statusCode == 200 else {
                self?.photoList.onError(SearchError.serverError)
                return
            }
            
            guard let photo = photo else {
                self?.photoList.onError(SearchError.noPhoto)
                return
                
            }
            
            //self.photoList.value = photo
            self?.photoList.onNext(photo)
            //self?.photoList.onCompleted()
        }
    }
    
    
}
