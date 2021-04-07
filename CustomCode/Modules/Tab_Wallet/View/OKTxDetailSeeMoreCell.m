//
//  OKTxDetailSeeMoreCell.m
//  OneKey
//
//  Created by bixin on 2021/4/7.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import "OKTxDetailSeeMoreCell.h"
@interface OKTxDetailSeeMoreCell()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *decorateView;


@end
@implementation OKTxDetailSeeMoreCell

- (void)setModel:(OKTxInputOutputModel *)model {
    _model = model;
    self.addressLabel.text = model.address;
    self.numberLabel.text = [model.amount stringByAppendingString:@" BTC"];
    
    UIRectCorner corner;
    if (model.cornerType == cornerTop) {
        corner = UIRectCornerTopRight | UIRectCornerTopLeft;
        
    }else if (model.cornerType == cornerBottom) {
         corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;

    }else if (model.cornerType == cornerAll) {
         corner = UIRectCornerAllCorners;

    }else{
         corner = 0;
    }
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:self.decorateView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *layer = [ [CAShapeLayer alloc ] init];
    layer.frame = self.decorateView.bounds;
    layer.path = cornerRadiusPath.CGPath;
    self.decorateView.layer.mask = layer;
}


@end
