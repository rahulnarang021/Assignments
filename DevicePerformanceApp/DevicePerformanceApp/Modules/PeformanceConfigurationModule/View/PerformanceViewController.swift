//
//  ViewController.swift
//  DevicePerformanceApp
//
//  Created by RN on 12/05/21.
//

import UIKit

class PerformanceViewController: UIViewController, Storyboardable {

    class func instantiateView(withPresenter presenter: PerformancePresenter) -> UIViewController {
        let viewController = self.instantiate()
        viewController.presenter = presenter
        return viewController
    }

    var presenter: PerformancePresenter! // Not taking this optional as if it's not passed then that means setup is incorrect

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = presenter.title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(didClickAlert)) // using default image of folder as do not have alert/notification icon here
        
    }

    @objc func didClickAlert() {
        presenter.didClickAlert()
    }
}

extension PerformanceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.controllers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let controller = presenter.controllers[indexPath.row]
        return controller.getCell(for: tableView)
    }
}
