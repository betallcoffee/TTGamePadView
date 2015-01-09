//
//  TTGamePadViewRockFactory.m
//  TTGamePadView
//
//  Created by liang on 1/8/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import "TTGamePadView.h"
#import "TTGamePadViewRockFactory.h"

@interface TTGamePadViewRockFactory ()
@property (nonatomic, strong) NSDictionary *buttonImage;
@end

@implementation TTGamePadViewRockFactory

- (instancetype)init {
    self = [super init];
    if (self) {
        _buttonImage = @{@(eTTPadButtonA): @"six_a",
                         @(eTTPadButtonB): @"six_b",
                         @(eTTPadButtonC): @"six_c",
                         @(eTTPadButtonX): @"six_x",
                         @(eTTPadButtonY): @"six_y",
                         @(eTTPadButtonZ): @"six_z",
                         @(eTTPadButtonSelect): @"select",
                         @(eTTPadButtonStart): @"start",
                         };
    }
    return self;
}

- (UIImageView *)backgroundView {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gamepad_bg_hand.jpg"]];
}

- (UIView<TTGamePadDirectionView> *)directionView {
    return [[TTGamePadViewRock alloc] init];
}

- (UIButton *)padButtonView:(eTTPadButton)padButton {
    UIImage *normal = [UIImage imageNamed:[NSString stringWithFormat:@"gamepad_btn_%@_n_paper.png", self.buttonImage[@(padButton)]]];
    UIImage *press = [UIImage imageNamed:[NSString stringWithFormat:@"gamepad_btn_%@_p_paper.png", self.buttonImage[@(padButton)]]];
    UIButton *button = [[UIButton alloc] init];
    [button setImage:normal forState:UIControlStateNormal];
    [button setImage:press forState:UIControlStateHighlighted];
    return button;
}

@end
