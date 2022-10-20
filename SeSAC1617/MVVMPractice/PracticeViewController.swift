//
//  PracticeViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/20.
//

import UIKit

class PracticeViewController: UIViewController {
    
    let practiceModel = PracticeModel()
    let viewModel = PracticeViewModel()
    
    override func loadView() {
        self.view = practiceModel
    }
    
    override func viewDidLoad() {
        practiceBindData()
        viewModel.requestPhoto(id: practiceModel.id)
    }
    
    func practiceBindData() {
        viewModel.practice.bind { practice in
            self.practiceModel.idLable.text = practice.id
            self.practiceModel.descriptionLable.text = practice.description
            self.practiceModel.likesLable.text = "\(practice.likes ?? 0)"
        }
    }
    
    
    
}
