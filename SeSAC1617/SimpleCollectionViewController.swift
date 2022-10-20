//
//  SimpleCollectionViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/18.
//

import UIKit

//1.hashable 타입 선언
struct User: Hashable {
    //uuid만 선언해도 똑같은 데이터 들어오게 할 수 있다
    //3개 다 동일하면 안되지만 3개 모두가 고유한 상황(hashable)에서 id는 계속 바뀌어서 값이 들어오기 때문에 동일한 데이터가 들어와도 절대로 겹치지 않는다
    let id = UUID().uuidString
    let name: String
    let age: Int
}

class SimpleCollectionViewController: UICollectionViewController {
    
    //var list = ["닭곰탕", "삼계탕", "들기름김", "3분카레", "콘소메 치킨"]
    
    var list = [
        User(name: "뽀로로", age: 3),
        User(name: "에디", age: 13),
        User(name: "해리포터", age: 33),
        User(name: "도라에몽", age: 5)
    ]
    
    //https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration
    //cellForItemAt 전에 생성되어야 한다 => cellRegister 코드와 유사한 역할(collectionView.register(UicollectionView.self, forCellWithReuseIdentifier:"")
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    //var hello: (() -> Void)!
    
//    func welcome() {
//        print("hello")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(hello)
//
        //hello = welcome // welcome vs welcome() 실행은 안돼고 함수의 내용만 넣어줌 타입 자체를 넣어준거임
//
//        hello = {
//            print("hello")
//        }
//
//        print(hello)//함수 타입 그 자체를 부름
//
//        hello()
        
        //let a = welcome
        //a()
        
        
        
        //layout 사용
        collectionView.collectionViewLayout = createLayout()
        
        //collectionView.register(UICollectionView.self, forCellWithReuseIdentifier: "asd")
        
        //초기화 변수에 다가 넣어 줌 거의 모든 내용을 처리 셀 등록, 데이터처리
        //cellRegistration = 구조체지만 메서드 시작할 때 handler(초기화 구문에 들어가 있음 얘가 클로저 구문)
        //장점 identifier 없는 것 -> 어떻게 고유한 값을 탐지하나
        //구조체 단위로 cell에 대한 등록이 이루어짐
        //클래스 구조에서는 셀 재사용 시 오류가 있다
        //구조체 구조에서는 셀 재사용 시 오류가 없다 각각 셀 마다 복사하기 때문에
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            //이미 디자인 된 형태 일일이 레이아웃을 잡을 필요가 없었던 이유다
            var content = UIListContentConfiguration.valueCell() //cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .blue
            
            content.secondaryText = "\(itemIdentifier.age)살"
            //아래쪽으로 배치
            content.prefersSideBySideTextAndSecondaryText = false
            //둘 사이 간격 띄우기
            content.textToSecondaryTextVerticalPadding = 20
            
            //content.image = indexPath.item < 3 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.image = itemIdentifier.age < 8 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.imageProperties.tintColor = .red
            
            if indexPath.item < 3 {
                content.imageProperties.tintColor = .brown
            }
            
            //셀 하나당 각각 호출
            print("setUp")
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .lightGray
            backgroundConfig.cornerRadius = 10
            backgroundConfig.strokeWidth = 2
            backgroundConfig.strokeColor = .red
            cell.backgroundConfiguration = backgroundConfig
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)
        
    }
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return list.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let item = list[indexPath.item]
//
//        //cell과 아이템을 받고 있다
//        //베열 넣게 되면 요소가 타입으로 들어가게 된다
//        //cellRegistration에 코드를 담아 놓고 실행을 나중에 하는 구조
//        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
//
//        return cell
//    }
}

extension SimpleCollectionViewController {
    
    //위에 collectionViewLayout 정하는 Layout 코드가 UICollectionViewLayout 타입
    private func createLayout() -> UICollectionViewLayout {
        //14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능(List Configuration)
        //컬렉션뷰 스타일 (컬렉션뷰 셀X)
        //plain으로 표현하면 각각 셀마다 속성을 줄 수 있다
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.backgroundColor = .systemBrown
        
        //위의 타입과 같아서 사용 가능
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
}
