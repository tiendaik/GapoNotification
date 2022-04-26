//
//  NotificationCell.swift
//  Gapo Notification
//
//  Created by Tiennh on 4/26/22.
//

import UIKit
import Kingfisher

class NotificationCell: UITableViewCell {

    @IBOutlet weak var imgNoti: UIImageView!
    @IBOutlet weak var imgNotiType: UIImageView!
    @IBOutlet weak var lblNotiContent: UILabel!
    @IBOutlet weak var lblNotiTime: UILabel!
    @IBOutlet weak var btnNotiOption: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        self.imgNoti.clipsToBounds = true
        self.imgNoti.layer.cornerRadius = self.imgNoti.frame.size.height / 2
        
        self.imgNotiType.clipsToBounds = true
        self.imgNotiType.layer.cornerRadius = self.imgNotiType.frame.size.height / 2
        self.imgNotiType.layer.borderColor = UIColor.white.cgColor
        self.imgNotiType.layer.borderWidth = 1.0
        
        self.lblNotiTime.textColor = UIColor.init(hex: 0x808080)
        self.lblNotiTime.font = .systemFont(ofSize: 12)
        
        self.btnNotiOption.setTitle("", for: .normal)
    }

    func bindData(model: NotificationModel) {
        let imgNotiUrl = URL.init(string: model.image)
        self.imgNoti.kf.setImage(with: imgNotiUrl)
        
        let imgNotiTypeUrl = URL.init(string: model.icon)
        self.imgNotiType.kf.setImage(with: imgNotiTypeUrl)
        
        self.lblNotiTime.text = model.updatedAt.getNotiTimeString(format: "dd/MM/yyyy, hh:mm")
        
        let lblNotiContent = NSMutableAttributedString(string: model.message.text, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.init(hex: 0x1A1A1A),
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
        ])
        for hightlight in model.message.highlights {
            let boldRange = NSMakeRange(hightlight.offset, hightlight.length)
            lblNotiContent.addAttributes([
                NSAttributedString.Key.foregroundColor : UIColor.init(hex: 0x1A1A1A),
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)
            ], range: boldRange)
        }
        self.lblNotiContent.attributedText = lblNotiContent
        
        self.backgroundColor = model.status == .read ? .white : UIColor.init(hex: 0xECF7E7)
    }
    
    @IBAction func optionClicked(_ sender: Any) {
        print("Notification clicked")
    }
}
