//
//  DetailViewController.swift
//  EPS
//
//  Created by Hemraj on 10/07/18.
//  Copyright © 2018 Hemraj. All rights reserved.
//
import CoreData
import UIKit
import SVProgressHUD
protocol UserInfoDelegate {
    // Classes that adopt this protocol MUST define
    // this method -- and hopefully do something in
    // that definition.
    func passData(_ Data: NSDictionary)
    func clearData()
}
class DetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
var delegate: UserInfoDelegate?
    
@IBOutlet weak var tableView: UITableView!
    var userInfoData = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        //SVProgressHUD.show()
        self.navigationItem.setHidesBackButton(true, animated:true);
        tableView.register(UINib(nibName: "DetailViewTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailViewTableViewCell
        let list = userInfoData[indexPath.row] as! NSDictionary
       // print(list)
        cell.setData(array:list)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = userInfoData[indexPath.row] as! NSDictionary
        //print(data)
        delegate?.passData(data)
        navigationController?.popViewController(animated: true)

    }
    @IBAction func tapAdd(_ sender: Any) {
        delegate?.clearData()
        navigationController?.popViewController(animated: true)
    }
}

