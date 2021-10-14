//
//  AlertViewController.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import UIKit

class AlertViewController: UIViewController, Storyboardable {

    var messages: [AlertModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Alerts"
        // Do any additional setup after loading the view.
    }

}

extension AlertViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlertTableViewCell? = tableView.dequeueReusableCell(withIdentifier: AlertTableViewCell.reusableIdentifier) as? AlertTableViewCell
        cell?.configure(messages[indexPath.row])
        if let tableViewCell = cell {
            return tableViewCell
        }
        return UITableViewCell() // should not come here. Implemented to remove warnings and force unwrap
    }
}
