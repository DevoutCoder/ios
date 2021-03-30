//
//  OKActionSheetController.h
//  OneKey
//
//  Created by zj on 2021/3/29.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface OKActionSheetCell : UITableViewCell
@property (nonatomic, strong) NSString *text;
@end

@interface OKActionSheetController : UIViewController
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray <NSString *> *entries;
@property (nonatomic, copy) void(^callback)(BOOL cancel, NSInteger index);

+ (instancetype)controllerWithStoryboard;
@end

NS_ASSUME_NONNULL_END
