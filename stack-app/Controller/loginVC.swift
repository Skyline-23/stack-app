//
//  ViewController.swift
//  stack-app
//
//  Created by 김부성 on 2/4/21.
//

import UIKit

import Alamofire
import Then

class loginVC: UIViewController, UITextFieldDelegate {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var serverMessage: String = ""
    
    lazy var alert = UIAlertController(title: nil, message: serverMessage, preferredStyle: .alert).then {
        $0.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
    }
    
    lazy var reRequset = UIAlertController(title: nil, message: serverMessage, preferredStyle: .alert).then {
        $0.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
//        $0.addAction(UIAlertAction(title: "재시도", style: .default) {_ in self.submit() })
    }
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var Idtextfield: UITextField!
    @IBOutlet weak var PWtextfield: UITextField!
    @IBOutlet weak var autoLoginCheckBox: UIView!
    @IBOutlet var autoLoginTouch: UITapGestureRecognizer!
    @IBOutlet weak var checkMark: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edittextfield(textfieldname: Idtextfield)
        edittextfield(textfieldname: PWtextfield)
        checkMark.isHidden = true
        
        // on Background, alert will disappear
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(dismissFunc), name: UIApplication.willResignActiveNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissFunc(){
        self.alert.dismiss(animated: true, completion: nil)
        self.reRequset.dismiss(animated: true, completion: nil)
    }
    
    func edittextfield(textfieldname: UITextField) {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textfieldname.delegate = self
        textfieldname.leftView = paddingView
        textfieldname.leftViewMode = .always
        textfieldname.layer.cornerRadius = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == Idtextfield {
            PWtextfield.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
//            submit()
        }
        return true
    }
    
    @IBAction func autoLoginTouch(_ sender: UITapGestureRecognizer) {
        if checkMark.isHidden == true {
            checkMark.isHidden = false
        }
        else {
            checkMark.isHidden = true
        }
    }
    
    //터치가 시작됬을 경우, 키보드를 닫음
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitTouch(_ sender: Any) {
//        submit()
    }
}
