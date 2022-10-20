//
//  PracticeView.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/20.
//

import UIKit
import SnapKit

class PracticeModel: UIView {
    
    var id = ""
    let idLable = UILabel()
    let descriptionLable = UILabel()
    let likesLable = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
        descriptionLable.numberOfLines = 0
        backgroundColor = .white
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [idLable, descriptionLable, likesLable].forEach {
            self.addSubview($0)
        }
    }
    
    func setConstraints() {
    
        idLable.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        
        descriptionLable.snp.makeConstraints { make in
            make.top.equalTo(idLable.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(idLable)
        }
        
        likesLable.snp.makeConstraints { make in
            make.top.equalTo(descriptionLable.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(idLable)
        }
    }
}
