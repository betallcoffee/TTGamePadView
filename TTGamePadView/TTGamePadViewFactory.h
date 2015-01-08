//
//  TTGamePadViewFactory.h
//  TTGamePadView
//
//  Created by liang on 1/6/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTGamePadView.h"

@protocol TTGamePadDirectionView <NSObject>


@end

@protocol TTGamePadViewFactory <NSObject>

- (UIImageView *)backgroundView;
- (UIView<TTGamePadDirectionView> *)directionView;
- (UIButton *)padButtonView:(eTTPadButton)padButton;

@end
