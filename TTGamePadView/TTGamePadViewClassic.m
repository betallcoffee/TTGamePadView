//
//  TTGamePadViewClassic.m
//  TTGamePadView
//
//  Created by liang on 1/6/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import "TTGamePadViewClassic.h"

@interface TTGamePadViewClassic ()

@property (nonatomic, strong) UIImageView *background;

@end

@implementation TTGamePadViewClassic

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gamepad_hand_direction_default.png"]];
        [self addSubview:_background];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    self.background.frame = self.bounds;
}

@end
