//
//  UrlListTableViewController.swift
//  LinkMark
//
//  Created by Woogie on 2021/01/07.
//
import Foundation
import UIKit

class UrlListTableViewController: UITableViewController {
    @IBOutlet var tvListView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //배열을 데이터로 채움
        URLAddress.shared.fetchURL()
        
        //데이터 새로고침
        tableView.reloadData()
        
//        print(#function)
    }
    
    // 옵저버 생성
    var token: NSObjectProtocol?
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    // segue가 연결된 화면을 생성 및 화면 전환 직전에 호출
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailViewController {
                vc.urlDetail = URLAddress.shared.urlList[indexPath.row]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // addViewController에서 url save시 leload
        token = NotificationCenter.default.addObserver(forName: AddViewController.newUrlDidInsert, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            self?.tableView.reloadData()
        }
    }
    @IBAction func editListBtnClicked(_ sender: UIBarButtonItem) {
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return URLAddress.shared.urlList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "linkList", for: indexPath)

        // Configure the cell...
        let target = URLAddress.shared.urlList[indexPath.row]
        cell.textLabel?.text = target.name
        cell.detailTextLabel?.text = target.address

        return cell
    }
    


//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//
//        return true
//    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let alert = UIAlertController(title: "알림", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
            
            let removeAction = UIAlertAction(title: "삭제", style: .destructive, handler: {_ in
                URLAddress.shared.urlList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
            alert.addAction(removeAction)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let urlToMove = URLAddress.shared.urlList[(fromIndexPath as NSIndexPath).row]
        URLAddress.shared.urlList.remove(at: (fromIndexPath as NSIndexPath).row)
        URLAddress.shared.urlList.insert(urlToMove, at: (to as NSIndexPath).row)
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
