//
//  ScriptMessageProxy.swift
//  OneKey
//
//  Created by xuxiwen on 2021/3/28.
//  Copyright © 2021 Onekey. All rights reserved.
//

import Foundation
import WebKit

///Reason for this class: https://stackoverflow.com/questions/26383031/wkwebview-causes-my-view-controller-to-leak
final class ScriptMessageProxy: NSObject, WKScriptMessageHandler {

    private weak var delegate: WKScriptMessageHandler?

    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }

    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        delegate?.userContentController(
            userContentController, didReceive: message)
    }
}
