//
//  DifferableCollectionViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/19.
//

import UIKit
import Kingfisher

class DifferableCollectionViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = DiffableViewModel()
    
    //어떤 셀을 쓸지, 데이터 타입이 뭔지
    //private var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, String>!
    
    //Int = 섹션에 대한 항목, String = 모델에 대한 타입 자체
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
        configureDateSource()
        
        searchBar.delegate = self
        
        viewModel.photoList.bind { photo in
            //Initial numberOfItemInSection에 해당
            var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
            snapshot.appendSections([0])
            snapshot.appendItems(photo.results)
            //ui 업뎃 연산 animation 들어가있다
            self.dataSource.apply(snapshot)
        }
    }
}

extension DifferableCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //유저가 검색 버튼 누르면 검색됨
        viewModel.requestSearchPhoto(query: searchBar.text!)
        
        //기존 스냅샷
//        var snapshot = dataSource.snapshot()
//        //searchbar 검색 시
//        snapshot.appendItems([searchBar.text!])
//        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension DifferableCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDateSource() {
        //타입 명시
        let cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult> = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier.likes)"
            // string > url > data > image
            //동작을 하는 동안 앱이 얼지 않게 설정
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)!
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!)
                    //타입을 명시해줘야하는데 안되어 있다 상수로 바꿀 경우
                    cell.contentConfiguration = content
                    
                }
               
            }
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.strokeWidth = 2
            background.strokeColor = .brown
            cell.backgroundConfiguration = background
        })
        
        //어떤 컬렉션 뷰에 해당하는 데이터 소스인가?, collectionView.dataSource = self 대신에 해준다
        //cellForItemAt과 numberOfItemInSection 대체
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            //셀 등록 후 등록 된 셀 사용
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
    }
    
}

extension DifferableCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       // guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
//
//        let alert = UIAlertController(title: item, message: "클릭!", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "확인", style: .cancel)
//        alert.addAction(ok)
//        present(alert, animated: true)
        
    }
}





