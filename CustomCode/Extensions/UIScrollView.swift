//
//  UIscrollView.swift
//  OneKey
//
//  Created by xuxiwen on 2021/3/28.
//  Copyright © 2021 Onekey. All rights reserved.
//

import Foundation

// MARK: - MJRefresh

extension UIScrollView {

    @discardableResult
    func headerRefresh(_ refreshingBlock: (() -> Void)? = nil) -> MJRefreshNormalHeader {
        let header = MJRefreshNormalHeader()
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        header.stateLabel?.font = .systemFont(ofSize: 12)
        header.stateLabel?.textColor = .fg_B03()
        self.mj_header = header
        if let refreshingBlock = refreshingBlock { header.refreshingBlock = refreshingBlock }
        return header
    }

    @discardableResult
    func footerRefresh(_ refreshingBlock: (() -> Void)? = nil) -> MJRefreshAutoNormalFooter {
        let footer = MJRefreshAutoNormalFooter()
        footer.stateLabel?.font = .systemFont(ofSize: 12)
        footer.stateLabel?.textColor = .fg_B03()
        footer.setTitle("No content".localized, for: .noMoreData)
        footer.setTitle("", for: .idle)
        footer.setTitle("", for: .idle)
        footer.setTitle("", for: .refreshing)
        self.mj_footer = footer
        if let refreshingBlock = refreshingBlock { footer.refreshingBlock = refreshingBlock }
        return footer
    }

    func isHeaderRefreshing() -> Bool {
        if let header = mj_header {
            return header.isRefreshing
        } else {
            return false
        }
    }

    func isFooterRefreshing() -> Bool {
        if let footer = mj_footer {
            return footer.isRefreshing
        } else {
            return false
        }
    }

    func beginHeaderRefresh() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            if let header = self.mj_header, !header.isRefreshing {
                header.beginRefreshing()
            }
        }
    }

    func beginFooterRefresh() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            if let footer = self.mj_footer, !footer.isRefreshing {
                footer.beginRefreshing()
            }
        }
    }

    func clearHeaderRefresh() {
        mj_header?.isHidden = true
        mj_header = nil
    }

    func clearFooterRefresh() {
        mj_footer = nil
    }

    func endMJRefresh() {
        endHeaderRefresh()
        endFooterRefresh()
    }

    func endHeaderRefresh() {
        mj_header?.endRefreshing()
    }

    func endFooterRefresh() {
        mj_footer?.endRefreshing()
    }

    func noMoreData() {
        mj_footer?.endRefreshingWithNoMoreData()
    }

    func resetNoMoreData() {
        mj_footer?.resetNoMoreData()
    }

    func hidenHeader(_ isHidden: Bool) {
        mj_header?.isHidden = isHidden
    }

    func hidenFooter(_ isHidden: Bool) {
        mj_footer?.isHidden = isHidden
    }

}
