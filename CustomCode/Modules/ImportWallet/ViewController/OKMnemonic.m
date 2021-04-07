//
//  OKMnemonic.m
//  OneKey
//
//  Created by zj on 2021/3/31.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import "OKMnemonic.h"

static const NSUInteger HINT_CAPACITY = 10;

@implementation OKMnemonic

+ (NSString *)checkMnemnoic:(NSString *)mnc {

    NSArray <NSString *>*mncs = [mnc.trim split:@" "];

    mncs = [[mncs ok_map:^NSString *(NSString *item) {
        return item.trim;
    }] ok_filter:^BOOL(NSString *item) {
        return item.length;
    }];

    if (mncs.count != 12 &&
        mncs.count != 18 &&
        mncs.count != 24) {
        [kTools tipMessage:@"仅支持 12/18/24 位助记词，请核对后重新输入。"];
        return nil;
    }

    NSString *mnemnoic = [mncs componentsJoinedByString:@" "];
    id result =  [kPyCommandsManager callInterface:kInterfaceverify_legality parameter:@{@"data":mnemnoic, @"flag": @"seed"}];
    if (!result) {
        [kTools tipMessage:@"请确认助记词是否抄写正确，并重新输入"];
        return nil;
    }
    return mnemnoic;
}

- (NSArray <NSString *>*)mnemonic {
    if (!_mnemonic) {
        _mnemonic = [kPyCommandsManager callInterface:kInterfaceget_all_mnemonic parameter:nil];
    }
    return _mnemonic;
}

- (NSArray <NSString *>*)hintsWithPrefix:(NSString *)prefix {
    if (!prefix.length) {
        return @[];
    }
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:HINT_CAPACITY];
    for (NSString *str in self.mnemonic) {
        if (arr.count >= HINT_CAPACITY) {
            break;
        }
        if ([str hasPrefix:prefix]) {
            [arr addObject:str];
        }
    }
    return arr;
}

@end
