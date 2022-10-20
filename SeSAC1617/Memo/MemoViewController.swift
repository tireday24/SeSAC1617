//
//  MemoViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/20.
//

import UIKit

struct Memo: Hashable {
    let title: String
    let content: String
    let pinned: Bool
}

class MemoViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let list: [Memo] = [

        Memo(title: "1", content: "비고", pinned: true),
        Memo(title: "2", content: "미정", pinned: true),
        Memo(title: "3", content: "모름", pinned: false),
        Memo(title: "4", content: "예정", pinned: false)
    
    ]
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Memo>!
    var dataSource: UICollectionViewDiffableDataSource<UICollectionViewListCell, Memo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white ]
        
        configurationContent()
        configurationCollectionView()
    }
    
    func configurationContent() {
        navigationItem.title = String(list.count) + "개의 메모"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor(named: "gray")
    }
    
    func configurationCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .supplementary
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <MemoHeader>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            supplementaryView.headerLable.text = "메모"
        }
        
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.content
            cell.contentConfiguration = content
            
        }
        
    }
    
}

extension MemoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let pinnedMemoCount = list.filter{$0.pinned == true}.count
        
        return section == 0 ? pinnedMemoCount : list.count - pinnedMemoCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pinnedMemo = list.filter{$0.pinned == true}
        let notPinnedMemo = list.filter{$0.pinned == false}
        
        let content = indexPath.section == 0 ? pinnedMemo[indexPath.item] : notPinnedMemo[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: content)
        
        return cell
    }
}
