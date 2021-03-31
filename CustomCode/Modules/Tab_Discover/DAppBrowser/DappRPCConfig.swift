//
//  DappRPCConfig.swift
//  OneKey
//
//  Created by xuxiwen on 2021/3/29.
//  Copyright © 2021 Onekey. All rights reserved.
//

import Foundation

enum DappRPCConfig {
    case EthereumMainNetwork
    case RopstenTestNetwork
    case BSCMain
    case BSCTestnet
}

extension DappRPCConfig {

    var rpcUrlInfo: (String, Int) {
        switch self {
        case .EthereumMainNetwork:
            return ("https://mainnet.infura.io/v3/6e822818ec644335be6f0ed231f48310", 1)
        case .RopstenTestNetwork:
            return ("https://ropsten.infura.io/v3/f911e0056b6845e2b71419434c5f08a8", 3)
        case .BSCMain:
        return ("https://bsc-dataseed.binance.org/", 56)
        case .BSCTestnet:
            return ("https://data-seed-prebsc-1-s1.binance.org:8545/", 97)
        }
    }

}
