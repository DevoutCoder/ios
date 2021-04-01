//
//  OKWalletCreateModel.m
//  OneKey
//
//  Created by zj on 2021/4/1.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import "OKWalletCreateModel.h"

@implementation OKWalletCreateModel

- (OKWalletCoinType)walletCoinType {
    return [OKWalletInfoModel walletCoinTypeWithStr:self.coinType];
}
@end
