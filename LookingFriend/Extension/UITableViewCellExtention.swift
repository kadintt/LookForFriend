//
//  UITableViewCellExtention.swift
//  pavodoctor
//
//  Created by 曲超 on 2020/4/26.
//  Copyright © 2020 导医通. All rights reserved.
//

import Foundation


extension UITableViewCell {
    // 卡片式Cell
    @objc func cornerCard(radius: CGFloat = 8, margin: CGFloat = 16, indexPath: IndexPath) {

        var corner = UIRectCorner.allCorners
        ///防止 一组多个cell 出现缝隙问题
        var bottomGap:CGFloat = 0
        var topGap:CGFloat = 0
        // 拿到Cell的TableView
        var view: UIView? = superview
        while view != nil && !(view is UITableView) {
            view = view!.superview
        }
        guard let tableView = view as? UITableView else { return }
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            // 1.只有一行
            corner = .allCorners
            setCellRetractDYT()
        } else if indexPath.row == 0 {
            // 2.每组第一行
            corner = [.topLeft, .topRight]
            
//            UIView.addShadow(to: self, withOpacity: 1, shadowRadius: 14, andCornerRadius: 0, shadowOffset: CGSize(width: -4, height: -4), color: UIColor.shadowColor_DYT())
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            // 3.每组最后一行
            corner = [.bottomLeft, .bottomRight]
//            addShadow()
            bottomGap = 1
            topGap = -1
        } else {
            topGap = -1
            bottomGap = 1
            corner = []
        }
        
        let contentBounds = CGRect(origin: CGPoint(x: margin, y: topGap), size: CGSize(width: frame.width - 2 * margin, height: frame.height + bottomGap))
        let layer = CAShapeLayer()
        layer.bounds = contentBounds
        layer.position = CGPoint(x: contentBounds.midX, y: contentBounds.midY)
        layer.path = UIBezierPath(roundedRect: contentBounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = layer
    }
}
