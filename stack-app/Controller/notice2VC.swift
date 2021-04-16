//
//  notice2VC.swift
//  stack-app
//
//  Created by 김부성 on 2/8/21.
//

import UIKit

class notice2VC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var viewlayout: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var pointLabel: UILabel!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewlayout.layer.cornerRadius = 10
        
        let data = delegate.board![delegate.boardnum!] as! NSDictionary
        
        titleLabel.text = data["title"] as? String
        contentLabel.text = data["content"] as? String
        userLabel.text = data["userId"] as? String
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
