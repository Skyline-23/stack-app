//
//  notice2VC.swift
//  stack-app
//
//  Created by 김부성 on 2/8/21.
//

import UIKit

class notice2VC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var viewlayout: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewlayout.layer.cornerRadius = 10
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
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
