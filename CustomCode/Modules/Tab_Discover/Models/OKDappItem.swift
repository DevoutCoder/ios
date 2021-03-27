//
//  OKDappItem.swift
//  OneKey
//
//  Created by xuxiwen on 2021/3/18.
//  Copyright © 2021 Onekey. All rights reserved.
//

import Foundation

struct OKDappItem : Codable, Equatable {

    enum OKDappFromType {
        case discover
        case url
    }

    var chain : String = ""
    var code : String = ""
    var description : String = ""
    var favicon : String = ""
    var img : String = ""
    var layout : String = ""
    var name : String = ""
    var status : String = ""
    var subtitle : String = ""
    var url : String = ""
    var from : OKDappFromType = .discover

    init() {

    }

    func dappName() -> String {
        var string = name
        if string.isEmpty {
            string = url
        }
        if string.isEmpty {
            string = "Dapp"
        }
        return string
    }

    func dappIconURLString() -> String {
        if img.isEmpty {
            return url.favicon()
        } else {
            return img.addPreHttps
        }
    }

    func dappDescription() -> String {
        var des = description
        if des.isEmpty {
            des = subtitle
        }
        if des.isEmpty {
            des = "--"
        }
        return des
    }

    enum CodingKeys: String, CodingKey {
        case chain = "chain"
        case code = "code"
        case description = "description"
        case favicon = "favicon"
        case img = "img"
        case name = "name"
        case status = "status"
        case subtitle = "subtitle"
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        chain = try values.decodeIfPresent(String.self, forKey: .chain) ?? ""
        code = try values.decodeIfPresent(String.self, forKey: .code) ?? ""
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        favicon = try values.decodeIfPresent(String.self, forKey: .favicon) ?? ""
        img = try values.decodeIfPresent(String.self, forKey: .img) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        status = try values.decodeIfPresent(String.self, forKey: .status) ?? ""
        subtitle = try values.decodeIfPresent(String.self, forKey: .subtitle) ?? ""
        url = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.url == rhs.url
    }

}
