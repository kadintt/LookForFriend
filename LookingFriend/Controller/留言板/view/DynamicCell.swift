//
//  DynamicCell.swift
//  LookingFriend
//
//  Created by 曲超 on 2021/10/27.
//

import UIKit

class DynamicCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        contentView.backgroundColor = .random
    }
}

struct FModel {
    let h: CGFloat
    let w: CGFloat
    
    static func loadData() -> [FModel] {
        return [
            FModel(h: 10, w: 20),
            FModel(h: 20, w: 20),
            FModel(h: 30, w: 20),
            FModel(h: 10, w: 30),
            FModel(h: 20, w: 20),
            FModel(h: 30, w: 40),
            FModel(h: 60, w: 50),
            FModel(h: 20, w: 30),
            FModel(h: 10, w: 20),
        ]
    }
}
