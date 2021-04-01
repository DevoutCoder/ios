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
