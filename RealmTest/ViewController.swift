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
    var token: NotificationToken?
    
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(realm.configuration.fileURL!)
        
        observeItems()
    }
    
    @IBAction func clickAddButton(_ sender: Any) {
        try! realm.write {
            realm.add(Item(content: "Content"))
        }
    }
    
    func observeItems() {
        let items = realm.objects(Item.self)
        
        token = items.observe { changes in
            switch changes {
            case .initial(let items):
                self.reloadTable(to: items)
            case .update(let items, let deletions, let insertions, let modifications):
                self.reloadTable(to: items)
                
                print("Deleted indices: ", deletions)
                print("Inserted indices: ", insertions)
                print("Modified modifications: ", modifications)
            case .error(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func reloadTable(to items: Results<Item>) {
        self.items = items.map { $0 }
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
