//
//  TTGamePadViewFactory.h
//  TTGamePadView
//
//  Created by liang on 1/6/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 @brief 面板的样式
 */
typedef enum : NSUInteger {
    eTTPadStyleClassic, /**< @brief 经典样式 */
    eTTPadStyleRock, /**< @brief 摇杆样式 */
} eTTPadStyle;

/**
 @brief 方向控制
 */
typedef enum : NSUInteger {
    eTTDirectionUpLeft,
    eTTDirectionUp,
    eTTDirectionUpRight,
    eTTDirectionRight,
    eTTDirectionDownRight,
    eTTDirectionDown,
    eTTDirectionDownLeft,
    eTTDirectionLeft,
} eTTDirection;


/**
 @brief 按钮控制
 */
typedef enum : NSUInteger {
    eTTPadButtonA,
    eTTPadButtonB,
    eTTPadButtonC,
    eTTPadButtonX,
    eTTPadButtonY,
    eTTPadButtonZ,
    eTTPadButtonSelect,
    eTTPadButtonStart,
} eTTPadButton;

NSString *directionName(eTTDirection direction);
NSString *padButtonName(eTTPadButton button);

@protocol TTGamePadDirectionViewDelegate;

@protocol TTGamePadDirectionView <NSObject>

@property (nonatomic, assign) id<TTGamePadDirectionViewDelegate> delegate;

@end

@protocol TTGamePadDirectionViewDelegate <NSObject>

/**
 @brief TTGamePadDirectionView 方向控制时将调用 delegate 的此方法。
 */
- (void)TTGamePadDirectionView:(UIView<TTGamePadDirectionView> *)directionView direction:(eTTDirection)direction;

@end

@protocol TTGamePadViewFactory <NSObject>

- (UIImageView *)backgroundView;
- (UIView<TTGamePadDirectionView> *)directionView;
- (UIButton *)padButtonView:(eTTPadButton)padButton;

@end
