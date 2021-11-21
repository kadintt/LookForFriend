//
//  MessageCell.swift
//  LookingFriend
//
//  Created by 曲超 on 2021/10/27.
//

import UIKit

enum ActionType:Int {
    case refused = 0
    case agree = 1
}

class MessageCell: UITableViewCell {
    
    let headImgV = UIImageView()
    
    let messageT = UILabel.quickLabel("官方通知", font: APPFont.regular(size: 15), textAlignment: .left, color: UIColor.dyt_title)
    
    let messageDes = UILabel.quickLabel("防诈骗，防欺骗，防诈骗，防欺骗", font: APPFont.regular(size: 12), textAlignment: .left, color: UIColor.dyt_des)
    
    let messageTime = UILabel.quickLabel("昨天", font: APPFont.regular(size: 11), textAlignment: .right, color: UIColor.dyt_time)
    
    lazy var refusedBtn:UIButton = {
        let v = UIButton(type: .custom)
        v.setTitle("拒绝", for: .normal)
        v.titleLabel?.font = APPFont.regular(size: 12)
        v.setTitleColor(UIColor.white, for: .normal)
        v.setBackgroundImage(gImage("refused_icon"), for: .normal)
        v.addTarget(self, action: #selector(actionBtnClick(sender:)), for: .touchUpInside)
        v.tag = 0
        return v
    }()
    
    lazy var agreeBtn:UIButton = {
        let v = UIButton(type: .custom)
        v.setTitle("同意", for: .normal)
        v.titleLabel?.font = APPFont.regular(size: 12)
        v.setTitleColor(UIColor.white, for: .normal)
        v.setBackgroundImage(gImage("agree_icon"), for: .normal)
        v.addTarget(self, action: #selector(actionBtnClick(sender:)), for: .touchUpInside)
        v.tag = 1
        return v
    }()
    
    let actionView = UIView()
    
    let readFlag:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.dyt_point
        v.cornerRadius = gScale(8)/2
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUpUI()
    }
    
    private func setUpUI() {
        
        contentView.sd_addSubviews([headImgV, messageT, messageDes, messageTime, readFlag, actionView])
        
        actionView.sd_addSubviews([refusedBtn, agreeBtn])
        
        headImgV.sd.topSpace(contentView, gScale(15)).heightIs(gScale(50)).widthIs(gScale(50)).leftSpace(contentView, 13.5)
        
        messageTime.sd.topSpace(contentView, gScale(23.5)).rightSpace(contentView, gScale(14)).heightIs(gScale(10)).widthIs(gScale(40))
        
        messageT.sd.topEqual(headImgV).offset(gScale(7.5)).heightIs(14.5).leftSpace(headImgV, gScale(7.5)).rightSpace(messageTime, gScale(10))
        messageDes.sd.leftEqual(messageT).topSpace(messageT, gScale(11)).heightIs(gScale(11.5)).rightSpace(contentView, gScale(13.5))
        
        readFlag.sd.topSpace(messageTime, gScale(20.5)).heightIs(gScale(8)).widthIs(gScale(8)).rightEqual(messageTime)
        
        actionView.sd.topSpace(contentView, gScale(26)).heightIs(gScale(30)).rightSpace(contentView, gScale(14)).widthIs(gScale(130))
        
        refusedBtn.sd.topEqual(actionView).leftEqual(actionView).widthIs(gScale(55)).heightIs(gScale(30))
        agreeBtn.sd.topEqual(actionView).rightEqual(actionView).widthIs(gScale(55)).heightIs(gScale(30))
        
    }
    
    @objc func actionBtnClick(sender:UIButton) {
        print(ActionType(rawValue: sender.tag) ?? .agree)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
