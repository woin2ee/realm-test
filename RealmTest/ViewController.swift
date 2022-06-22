//
//  ViewController.swift
//  RealmTest
//
//  Created by Jaewon on 2022/06/22.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    let realm = try! Realm()
    
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(realm.configuration.fileURL!)
        
        fetchItems()
    }
    
    @IBAction func clickAddButton(_ sender: Any) {
        try! realm.write {
            realm.add(Item(content: "Content"))
        }
        fetchItems()
        reloadTable()
    }
    
    func fetchItems() {
        let items = realm.objects(Item.self)
        self.items = items.map { $0 }
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = items[indexPath.row].content
        return cell
    }
}
