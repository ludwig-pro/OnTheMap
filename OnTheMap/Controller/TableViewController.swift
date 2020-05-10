//
//  TableViewController.swift
//  OnTheMap
//
//  Created by ludwig vantours on 30/04/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    let navigationBar = navigationController
    navigationBar?.isNavigationBarHidden = false
    NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name.RefreshData, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.RefreshData, object: nil)
  }
  
  @objc func refreshData(){
    tableView.reloadData()
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
    return Students.locations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCellViewCell", for: indexPath)
    let student = Students.locations[indexPath.row]
    
    cell.textLabel?.text = student.title
    cell.detailTextLabel?.text = student.mediaURL
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }
  
  
  
}
