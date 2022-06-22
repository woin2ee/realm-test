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
    
    private var realmStorage: RealmStorage = RealmStorage()
    private var token: NotificationToken?
    
    private var items: [Item] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindItems()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        invalidateToken()
    }
    
    // MARK: - Private
    
    private func bindItems() {
        self.token = realmStorage.bindTo(behavior: reloadTable(to:))
    }
    
    private func reloadTable(to items: Results<Item>) {
        self.items = items.map { $0 }
        tableView.reloadData()
    }
    
    private func invalidateToken() {
        self.token?.invalidate()
    }
    
    // MARK: - User Interaction
    
    @IBAction private func clickAddButton(_ sender: Any) {
        realmStorage.save(item: Item(content: "Content"))
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

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
