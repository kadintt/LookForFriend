//
//  XLFormRowDescriptorExtention.swift
//  pavodoctor
//
//  Created by 曲超 on 2020/4/26.
//  Copyright © 2020 导医通. All rights reserved.
//

import Foundation
import XLForm

extension XLFormRowDescriptor {
    
//  /// 病历详情row
//  @objc class func DiseaseDetailRow(rowtag tag: String,
//                          rowtype rowType: String,
//                          rowtitle title: String,
//                          rowvalue value: String,
//                          supVC controller:XLFormViewController,
//                          hideBottom isHide: Bool = false
//                            ) ->XLFormRowDescriptor {
//
//        let  row = XLFormRowDescriptor(tag: tag, rowType: rowType, title: title)
//
//        let t = NSString(format: "%@",value)
//        let detailMaxWidth = KScreen_Width  - 32 - 32 - 80;
//        let detailHeight = t.jq_size(with: APPFont.regular(size: 16), limitWidth: detailMaxWidth)
//        row.value = value
//        row.height = detailHeight.height + 32
//        row.cellClass = DCDiseaseDetailCell.self
//        let cell = row.cell(forForm: controller) as! DCDiseaseDetailCell
//        cell.isBottom = isHide
//        return row
//    }
//    /// 检查申请单row
//    @objc class func InspectionFormRow(rowtag tag: String,
//                            rowtype rowType: String,
//                            rowtitle title: String,
//                            rowvalue value: String,
//                            supVC controller:XLFormViewController,
//                            hideBottom isHide: Bool = false
//                              ) ->XLFormRowDescriptor {
//
//          let  row = XLFormRowDescriptor(tag: tag, rowType: rowType, title: title)
//          let t = NSString(format: "%@",value)
//          let detailMaxWidth = KScreen_Width  - 32 - 32 - 104;
//          let detailHeight = t.jq_size(with: APPFont.regular(size: 16), limitWidth: detailMaxWidth)
//          row.value = value
//          row.height = detailHeight.height + 28
//          row.cellClass = DCInspectionFormCell.self
//          let cell = row.cell(forForm: controller) as! DCInspectionFormCell
//          cell.isBottom = isHide
//          return row
//      }
    
}

