//
//  DCSystemAlertTool.swift
//  pavodoctor
//
//  Created by 曲超 on 2020/5/9.
//  Copyright © 2020 导医通. All rights reserved.
//

import UIKit

@objc(DCSystemAlertTool)
open class DCSystemAlertTool: NSObject {
    static let sharedInstance = DCSystemAlertTool()
    override init() {}
    @objc open class func shared() -> DCSystemAlertTool {
        return DCSystemAlertTool.sharedInstance
    }
    typealias TextAlertBlock = (_ text:String)->()
    typealias AlertSystemBlock = (_ text:String,_ index:Int)->()

    @objc open func showAlert(title titleStr:String ,
                   message messageStr: String,
                   leftTitle leftTitleStr:String,
                   rightTitles rightTitleStr:[String],
                   corner cornerNum: CGFloat = 8,
                   block alertBlock:@escaping AlertViewBlock) {
        
        _ = showNomalAlert(title: titleStr, message: messageStr, leftTitle: leftTitleStr, rightTitles: rightTitleStr, corner: cornerNum){( _ ,index)  in
            alertBlock(index)
        }
    }
    
    private func showNomalAlert(title titleStr:String ,
                     message messageStr: String,
                     leftTitle leftTitleStr:String,
                     rightTitles rightTitleStr:[String],
                     corner cornerNum: CGFloat,
                     block alertBlock: @escaping AlertSystemBlock) -> AlertController {
          let alert = AlertController(title: titleStr, message: messageStr, style: .alert,frame: CGRect(x: 0, y: 0, width: KScreen_Width, height: KScreen_Height), connerNum: cornerNum)
          
          if rightTitleStr.count > 0 {
              for (i, value) in rightTitleStr.enumerated() {
                  let btn = NewYorkButton(title: value, style: .default) { _ in
                    
                    if let textV = alert.textView_P {
                        
                        alertBlock(textV.text, i+1)

                    }else {
                        if alert.textFields.count <= 0 {
                                            alertBlock("", i+1)
                                        }else {
                                            alert.textFields.forEach { tf in
                                                let text = tf.text ?? ""
                                                switch tf.tag {
                                                case 1:
                                                    alertBlock(text, i+1)
                                                default:
                                                    break
                                                }
                                            }
                                        }
                    }
                    
                  }
                  alert.addButton(btn)
              }
          }
        let cancel = NewYorkButton(title: leftTitleStr, style: .cancel) { _ in
            alertBlock("", 0)
        }
        if rightTitleStr.count == 0 {
            cancel.setTitleColor(UIColor(hex: 0x007AFF), for: .normal)
            cancel.titleLabel?.font = APPFont.regular(size: 17)
        }
          alert.addButton(cancel)
          alert.alertView.addButtons(alert.buttons, cancelButton: alert.cancelButton)
          let kw = UIApplication.shared.keyWindow
          kw?.addSubview(alert)
          return alert
      }
    
    /// 展示带输入框的弹窗
    func showAlertTextField(title titleStr:String ,
                            message messageStr: String,
                            leftTitle leftTitleStr:String,
                            rightTitles rightTitleStr:[String],
                            corner cornerNum: CGFloat,
                            backColor:UIColor = UIColor(hex: 0xEEEEEE),
                            placeHolderStr:String = "1-16个字符",
                            textLimit:Int = 16,
                            block alertBlock:@escaping AlertSystemBlock) {
        
        let alert = showNomalAlert(title: titleStr, message: messageStr, leftTitle: leftTitleStr, rightTitles: rightTitleStr, corner: cornerNum,block:alertBlock)
        alert.textLimit = textLimit
        alert.setBackColor(backColor)
        alert.addTextField { tf in
            tf.placeholder = placeHolderStr
            tf.tag = 1
        }
    }
    
    /// 展示 多行输入的 弹框
    func showAlertTextView(title titleStr:String ,
                            message messageStr: String,
                            textViewPlaceholder:String,
                            leftTitle leftTitleStr:String,
                            rightTitles rightTitleStr:[String],
                            corner cornerNum: CGFloat,
                            block alertBlock:@escaping AlertSystemBlock) {
        
        let alert = AlertController(title:titleStr , message:messageStr, style: .alert,frame: CGRect(x: 0, y: 0, width: KScreen_Width, height: KScreen_Height), connerNum: cornerNum)
        
        alert.addTextView { (textV) in
            textV.placeholder = textViewPlaceholder
        }
        
        if rightTitleStr.count > 0 {
             for (i, value) in rightTitleStr.enumerated() {
                 let btn = NewYorkButton(title: value, style: .default) { _ in
                    if let textV = alert.textView_P {
                       alertBlock(textV.text, i)
                    }
                 }
                 alert.addButton(btn)
             }
         }
    
         let cancel = NewYorkButton(title: leftTitleStr, style: .cancel)
         alert.addButton(cancel)
         alert.alertView.addButtons(alert.buttons, cancelButton: alert.cancelButton)
         let kw = UIApplication.shared.keyWindow
         kw?.addSubview(alert)

    }
    
    func showAlertWithTextField(block alertBlock:@escaping TextAlertBlock){
        showAlertTextField(title: "检查部位", message: "", leftTitle: "取消", rightTitles: ["确认"], corner: 8.0) { (text, _) in
            alertBlock(text)
        }
    }
    
    /// 结束问诊 时的 弹窗
    func showStopVisitsAlert(title titleStr:String ,
                   message messageStr: String,
                   leftTitle leftTitleStr:String,
                   rightTitles rightTitleStr:[String],
                   corner cornerNum: CGFloat = 8,
                   messageColor:UIColor?,
                   block alertBlock:@escaping AlertViewBlock) {
        
       let alert = showNomalAlert(title: titleStr, message: messageStr, leftTitle: leftTitleStr, rightTitles: rightTitleStr, corner: cornerNum){( _ ,index)  in
            alertBlock(index)
        }
        alert.messageColor = messageColor
    }
}
