//
//  TTGamePadView.h
//  TTGamePadView
//
//  Created by liang on 1/6/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTGamePadViewFactory.h"

@class TTGamePadView;

/**
 @brief TTGamePadView  delegate protocol
 */
@protocol TTGamePadViewDelegate <NSObject>

/**
 @brief TTGamePadView 方向控制时将调用 delegate 的此方法。
 */
- (void)TTGamePadView:(TTGamePadView *)padView direction:(eTTDirection)direction;

/**
 @brief TTGamePadView 按钮控制时将调用 delegate 的此方法
 */
- (void)TTGamePadView:(TTGamePadView *)padView button:(eTTPadButton)padButton;

@end

@interface TTGamePadView : UIView<TTGamePadDirectionViewDelegate>

@property (nonatomic, assign) id<TTGamePadViewDelegate> delegate; /**< @brief TTGamePadView delegate */
@property (nonatomic, assign) eTTPadStyle style; /**< @brief TTGamePadView 面板样式 */

- (instancetype)initWithPadStyle:(eTTPadStyle)style;

@end
