//
//  MemoHeader.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/20.
//

import UIKit
import SnapKit

class MemoHeader: UICollectionReusableView {
    
    let headerLable = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubview(headerLable)
        
        headerLable.snp.makeConstraints { make in
            make.center
        }
    }
}
