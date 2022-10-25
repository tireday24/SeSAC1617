//
//  NewsViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/20.
//

import UIKit
import RxCocoa
import RxSwift

class NewsViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel = NewsViewModel()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 변화되 값을 클로저로 전달되어서 그 값을 value로 보여주겠다
        //listner로 보냄
        
        configureHierachy()
        configureDataSource()
        bindData()
        configureViews()
        
    }
    
    func bindData() {
        
//        viewModel.pageNumber.bind { value in
//            print("bind == \(value)")
//            self.numberTextField.text = value
//        }
//
        //뉴스 추가 변경시 스냅샷 찍음
        //초기화 전에 선언되면 안됨 configureDataSource 함수 호출 전 사용x
        viewModel.list.bind { item in
            var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
            snapshot.appendSections([0])
            snapshot.appendItems(item)
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
        
      
        

        
    }
    
    func configureViews() {
//        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
        
        numberTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe { (vc, text ) in
                vc.viewModel.changePageNumberFormat(text: text)
            }
            .disposed(by: disposeBag)
        
        //resetButton.addTarget(self, action: #selector(resetButtonClicked), for: .touchUpInside)
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe{ (vc, _) in
                vc.viewModel.resetSample()
            }
            .disposed(by: disposeBag)
        //loadButton.addTarget(self, action: #selector(loadButtonClicked), for: .touchUpInside)
        loadButton.rx.tap
            .withUnretained(self)
            .subscribe{ (vc, _) in
                vc.viewModel.loadSample()
            }
            .disposed(by: disposeBag)
    }
    
//    @objc func numberTextFieldChanged() {
//        //뷰 모델로 데이터 넘겨서 쉼표 찍게 해야함 데이터 가공 후 결과에 대한 데이터를 다시 뷰컨으로 넘겨주어야 한다
//        //데이터를 매개변수로 전달
//        print(#function)
//        guard let text = numberTextField.text else { return }
//        viewModel.changePageNumberFormat(text: text)
//    }
//
//    @objc func resetButtonClicked() {
//        //뷰모델이 가지고 있는 샘플 데이터를 빈배열로 바꿔줌
//        //새로 apply
//        //기능은 뷰모델에게 맡긴다
//        viewModel.resetSample()
//    }
//
//    @objc func loadButtonClicked() {
//        //데이터를 다시 가지고 올 수 있게 처리
//        viewModel.loadSample()
//    }
    
}

extension NewsViewController {
    func configureHierachy() { //addSubView, init, snapkit
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            cell.contentConfiguration = content
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(News.items)
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
