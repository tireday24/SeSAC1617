//
//  PracticeViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/20.
//

import UIKit

class PracticeViewController: UIViewController {
    
    let practiceView = PracticeView()
    let viewModel = PracticeViewModel()
    
    override func loadView() {
        self.view = practiceView
    }
    
    override func viewDidLoad() {
        practiceBindData()
        viewModel.requestPhoto(id: practiceView.id)
    }
    
    func practiceBindData() {
        viewModel.practice.bind { practice in
            self.practiceView.idLable.text = practice.id
            self.practiceView.descriptionLable.text = practice.description
            self.practiceView.likesLable.text = "\(practice.likes ?? 0)"
        }
    }
    
    
    
}
