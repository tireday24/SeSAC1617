//
//  APIService.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/20.
//

import Foundation
import Alamofire

class APIService {
    
    //서치바에 들어온 텍스트가 나오게 구조
    static func searchPhoto(query: String, completion: @escaping (SearchPhoto?, Int?, Error?) -> Void) {
        let url = "\(APIKey.searchURL)\(query)"
        let header: HTTPHeaders = ["Authorization": APIKey.authorization]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchPhoto.self) { response in
            
            let statusCode = response.response?.statusCode //상태코드 조건문
            
            switch response.result {
            case .success(let value): completion(value, statusCode, nil)
            case .failure(let error): completion(nil, statusCode, error)
            }
            
        }
    }
    
    static func photoPractice(id: String, completion: @escaping (PhotoPractice?, Int?, Error?) -> Void) {
        
        let url = "\(APIKey.baseURL)/photos\(id)"
        let header: HTTPHeaders = ["Authorization": APIKey.authorization]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: PhotoPractice.self) { response in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value): completion(value, statusCode, nil)
            case .failure(let error): completion(nil, statusCode, error)
            }
        }
        
    }
    
    private init() {}
    
}
