//
//  NoticeVC.swift
//  stack-app
//
//  Created by 김부성 on 2/8/21.
//

import UIKit

import Alamofire
import SwiftyJSON

class NoticeVC: UIViewController, UIGestureRecognizerDelegate {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var noticetable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noticetable.isHidden = true
        self.noticetable.layer.cornerRadius = 10
        // Do any additional setup after loading the view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let url = "http://10.80.162.86:3000/v1/board"
        
        if delegate.board != nil {
            noticetable.isHidden = false
        }
        else {
            noticetable.isHidden = true
        }
        
        let alamo = AF.request(url, method: .get, encoding: JSONEncoding.default)
        let configuration = URLSessionConfiguration.default
        // timeout시간 설정
        configuration.timeoutIntervalForRequest = TimeInterval(1)
        alamo.responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.delegate.board = json["data"]["board"].array
                self.noticetable.reloadData()
                self.noticetable.isHidden = false
            case .failure(_):
                let alart = UIAlertController(title: nil, message: "네트워크를 다시 확인해주세요", preferredStyle: .alert)
                alart.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alart, animated: true)
                return
            }
        }
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

extension NoticeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.board?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoticeCell
        let data = delegate.board?[indexPath.row]
        cell.Contentlbl.text = data?["content"].stringValue
        cell.Titlelbl.text = data?["title"].stringValue
        cell.Userlbl.text = data?["userId"].stringValue
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.boardnum = indexPath.row
    }
}
