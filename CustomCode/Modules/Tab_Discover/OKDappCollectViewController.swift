//
//  OKDappCollectViewController.swift
//  OneKey
//
//  Created by xuxiwen on 2021/3/27.
//  Copyright © 2021 Onekey. All rights reserved.
//

import UIKit
import Reusable

class OKDappCollectViewController: ViewController {

    @IBOutlet weak var navView: OKModalNavView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var emptyTip: UILabel!

    private var dataSource: [OKDappItem] = []

    static func present() {
        let page = OKDappCollectViewController.instantiate()
        OKTools.ok_TopViewController().present(page, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navView.setNavTitle(string: "My Favorites".localized)
        navView.setNavPop { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        tableView.rowHeight = 92
        tableView.separatorStyle = .none
        tableView.register(cellType: OKDAppCollectTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        emptyTip.text = "No content".localized

        tableView.headerRefresh { [weak self] in
            guard let self = self else { return }
            self.fetchData()
        }

        fetchData()
    }

    private func fetchData() {
        DAppFavoriteManage.getAllFavorites { [weak self] items in
            guard let self = self else { return }
            self.dataSource = items
            self.emptyTip.isHidden = !items.isEmpty
            if (self.loading.isAnimating) {
                self.loading.stopAnimating()
            }
            self.tableView.reloadData()
            self.tableView.endMJRefresh()
        }
    }

    private func dAppUnFavorite(item: OKDappItem, callBack: @escaping ((Bool) -> Void)) {
        let alert = UIAlertController(title: "Confirm delete".localized, message: nil,  preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel,  handler: { _ in
            callBack(false)
        }))
        alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive,  handler: { _ in
            DAppFavoriteManage.removeFavorite(item: item) {
                callBack(true)
            }
        }))
        present(alert, animated: true, completion: nil)
    }

}

extension OKDappCollectViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: OKDAppCollectTableViewCell.self)
        cell.selectionStyle = .none
        let model = dataSource[indexPath.row]
        cell.setModel(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete".localized) {
            [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let model = self.dataSource[indexPath.row]
            self.dAppUnFavorite(item: model) { (flag) in
                if (flag) {
                    self.dataSource.removeAll(model)
                    self.tableView.reloadData()
                }
            }
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.row]
        DAppWebManage.handleOpenDApp(model: model) {

        }
    }

}

extension OKDappCollectViewController: StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "Tab_Discover", bundle: nil)
    static var sceneIdentifier = "OKDappCollectViewController"
}
