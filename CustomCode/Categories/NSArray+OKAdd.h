//
//  NSArray+OKAdd.h
//  OneKey
//
//  Created by zj on 2021/2/4.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<__covariant T> (OKAdd)
- (NSArray <T>*)ok_map:(T(^)(T item))mapBlock;
- (NSArray <T>*)ok_filter:(BOOL(^)(T item))filterBlock;

- (NSArray *)ok_padding:(id)item to:(NSUInteger)idealCount;
@end
