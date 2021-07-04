//
//  notice2VC.swift
//  stack-app
//
//  Created by 김부성 on 2/8/21.
//

import UIKit

class NoticeDetailVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var viewlayout: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var pointLabel: UILabel!
    
    var data: BoardData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = data?.title
        userLabel.text = data?.userId
        contentLabel.text = data?.content
        
        viewlayout.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
