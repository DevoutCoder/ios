//
//  File.swift
//  OneKey
//
//  Created by xuxiwen on 2021/3/27.
//  Copyright © 2021 Onekey. All rights reserved.
//

import Foundation

struct DAppAllFavorites : Codable {
    let allFavorite : [OKDappItem]
}

struct DAppFavoriteManage {

    static func getAllFavorites(completion: @escaping ([OKDappItem]) -> Void) {
        Dispatch.globalAsync {
            var result: [OKDappItem] = []
            if let data = fetchAllFavorites() {
                result.append(contentsOf: data.allFavorite)
            }
            Dispatch.mainAsync {
                completion(result)
            }
        }
    }

    static func addFavorite(item: OKDappItem, completion: @escaping () -> Void) {
        Dispatch.globalAsync {
            var items: [OKDappItem] = []
            if let data = fetchAllFavorites() {
                items.append(contentsOf: data.allFavorite)
            }
            items.removeAll(item)
            items.insert(item, at: 0)
            cacheAllFavorites(items: items)
            Dispatch.mainAsync {
                completion()
            }
        }
    }

    static func removeFavorite(item: OKDappItem, completion: @escaping () -> Void) {
        Dispatch.globalAsync {
            var items: [OKDappItem] = []
            if let data = fetchAllFavorites() {
                items.append(contentsOf: data.allFavorite)
            }
            items.removeAll(item)
            cacheAllFavorites(items: items)
            Dispatch.mainAsync {
                completion()
            }
        }
    }

    static func isFavorite(item: OKDappItem, completion: @escaping (Bool) -> Void) {
        Dispatch.globalAsync {
            var result: [OKDappItem] = []
            if let data = fetchAllFavorites() {
                result.append(contentsOf: data.allFavorite)
            }
            let flag = result.contains(item)
            Dispatch.mainAsync {
                completion(flag)
            }
        }
    }

    private static func fetchAllFavorites() -> DAppAllFavorites? {
        return UserDefaults.standard.object(DAppAllFavorites.self, with: key)
    }

    private static func cacheAllFavorites(items: [OKDappItem]) {
        let model = DAppAllFavorites(allFavorite: items)
        UserDefaults.standard.set(object: model, forKey: key)
    }

    private static let key = "OneKey-DAppAllFavorites"
}
