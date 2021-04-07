//
//  OKTxDetailSeeMoreModel.h
//  OneKey
//
//  Created by bixin on 2021/4/7.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, InputOutputCornerType) {
    cornerNone,
    cornerTop,
    cornerBottom,
    cornerAll,
};
NS_ASSUME_NONNULL_BEGIN

@interface OKTxDetailSeeMoreModel : NSObject
@property (nonatomic,strong) NSArray* input_list;
@property (nonatomic,strong) NSArray* output_list;

@end

@interface OKTxDetailSectionModel : NSObject
@property (nonatomic,strong) NSArray* list;
@property (nonatomic,copy) NSString* titleName;

@end

@interface OKTxInputOutputModel : NSObject
@property (nonatomic,copy) NSString* address;
@property (nonatomic,copy) NSString* amount;
@property (nonatomic,assign) InputOutputCornerType cornerType;

@end
NS_ASSUME_NONNULL_END

