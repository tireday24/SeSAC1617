//
//  PracticeViewModel.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/20.
//

import Foundation

class PracticeViewModel {
    
    var practice: CObservable<PhotoPractice> = CObservable(PhotoPractice(id: "", description: "", likes: nil))
    
    func requestPhoto(id: String) {
        APIService.photoPractice(id: "Dwu85P9SOIk") { practice, statusCode, error in
            guard let practice = practice else { return }
            self.practice.value = practice
        }
    }
    
}
