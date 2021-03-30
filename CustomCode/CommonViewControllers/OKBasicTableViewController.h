//
//  OKBasicTableViewController.h
//  OneKey
//
//  Created by zj on 2021/3/30.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OKBasicTableViewCellModel : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy, nullable) NSString *iconUrlStr;
@end

@interface OKBasicTableViewCell : UITableViewCell
@property (nonatomic, strong) OKBasicTableViewCellModel *model;
@end

@interface OKBasicTableViewController : BaseViewController
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy, nullable) NSString *desc;
@property (nonatomic, strong) NSArray<OKBasicTableViewCellModel *> *data;
@property (nonatomic, copy) void(^callback)(BOOL cancel, NSInteger index);

+ (instancetype)controllerWithStoryboard;
@end

NS_ASSUME_NONNULL_END
