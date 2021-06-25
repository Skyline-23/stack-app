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
    
    var data: Board?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noticetable.isHidden = true
        self.noticetable.layer.cornerRadius = 10
        // Do any additional setup after loading the view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let uri = "/board"
        
        if delegate.board != nil {
            noticetable.isHidden = false
        }
        else {
            noticetable.isHidden = true
        }
        
        NetworkingMock.Postget(uri: uri, param: nil, header: nil) { error, data in
            let decoder: JSONDecoder = JSONDecoder()
            self.data = try? decoder.decode(Board.self, from: data!)
            print(self.data)
            self.noticetable.reloadData()
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
