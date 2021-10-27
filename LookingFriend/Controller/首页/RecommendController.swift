//
//  RecommendController.swift
//  LookingFriend
//
//  Created by 曲超 on 2021/10/14.
//

import UIKit

private let reuseIdentifier = "Cell"

class RecommendController: DCViewController {

    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (KScreen_Width - gScale(35))/2, height: gScale(250))
        layout.minimumLineSpacing = gScale(7)
        layout.minimumInteritemSpacing = gScale(7)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.showsVerticalScrollIndicator = false
        v.backgroundColor = .white
        v.dataSource = self
        v.delegate = self
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.left.equalTo(view).offset(gScale(14))
            maker.right.equalTo(view).offset(-gScale(14))
        }
        collectionView.reloadData()
        
    }
    
    
}
extension RecommendController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = RecommendPeopleCell(collectionView: collectionView, indexPath: indexPath, xib: false)!
        
        return cell
    }
}
