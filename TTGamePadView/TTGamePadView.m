//
//  TTGamePadView.m
//  TTGamePadView
//
//  Created by liang on 1/6/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import "TTGamePadView.h"
#import "TTGamePadViewClassicFactory.h"
#import "TTGamePadViewRockFactory.h"

NSString *directionName(eTTDirection direction) {
    switch (direction) {
        case eTTDirectionUpLeft:
            return @"UpLeft";
        case eTTDirectionUp:
            return @"Up";
        case eTTDirectionUpRight:
            return @"UpRight";
        case eTTDirectionRight:
            return @"Right";
        case eTTDirectionDownRight:
            return @"DownRight";
        case eTTDirectionDown:
            return @"Down";
        case eTTDirectionDownLeft:
            return @"DownLeft";
        case eTTDirectionLeft:
            return @"Left";
        default:
            break;
    }
    return @"";
}

NSString *padButtonName(eTTPadButton button) {
    switch (button) {
        case eTTPadButtonA:
            return @"A";
        case eTTPadButtonB:
            return @"B";
        case eTTPadButtonC:
            return @"C";
        case eTTPadButtonX:
            return @"X";
        case eTTPadButtonY:
            return @"Y";
        case eTTPadButtonZ:
            return @"Z";
        case eTTPadButtonSelect:
            return @"Select";
        case eTTPadButtonStart:
            return @"Start";
        default:
            break;
    }
    return @"";
}

@interface TTGamePadView ()

@property (nonatomic, strong) id<TTGamePadViewFactory> factory;
@property (nonatomic, strong) UIView<TTGamePadDirectionView> *directionView;
@property (nonatomic, strong) UIButton *a;
@property (nonatomic, strong) UIButton *b;
@property (nonatomic, strong) UIButton *c;
@property (nonatomic, strong) UIButton *x;
@property (nonatomic, strong) UIButton *y;
@property (nonatomic, strong) UIButton *z;
@property (nonatomic, strong) UIButton *select;
@property (nonatomic, strong) UIButton *start;
@property (nonatomic, strong) UIButton *menu;

@end

@implementation TTGamePadView

- (instancetype)initWithPadStyle:(eTTPadStyle)style {
    self = [super init];
    if (self) {
        self.multipleTouchEnabled = YES;
        self.backgroundColor = [UIColor redColor];
        _style = style;
        switch (_style) {
            case eTTPadStyleClassic:
                _factory = [[TTGamePadViewClassicFactory alloc] init];
                break;
            case eTTPadStyleRock:
                _factory = [[TTGamePadViewRockFactory alloc] init];
                break;
        }
        [self buildView];
    }
    return self;
}

#pragma mark TTGameDirectionViewDelegate

- (void)TTGamePadDirectionView:(UIView<TTGamePadDirectionView> *)directionView direction:(eTTDirection)direction {
    if (self.delegate != nil) {
        [self.delegate TTGamePadView:self direction:direction];
    }
}

#pragma mark response the button press

- (void)pressButton:(UIButton *)sender {
    if (self.delegate != nil) {
        [self.delegate TTGamePadView:self button:sender.tag];
    }
}

#pragma mark build view

- (void)buildView {
    [self buildBackgroundView];
    [self buildDirectionView];
    [self buildButtonA];
    [self buildButtonB];
    [self buildButtonC];
    [self buildButtonX];
    [self buildButtonY];
    [self buildButtonZ];
    [self buildSelect];
    [self buildStart];
}

- (void)buildBackgroundView {
    UIImageView *background = [_factory backgroundView];
    [self addSubview:background];
}

- (void)buildDirectionView {
    _directionView = [_factory directionView];
    _directionView.translatesAutoresizingMaskIntoConstraints = NO;
    _directionView.delegate = self;
    [self addSubview:_directionView];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_directionView);
    // 设置左边距与宽
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_directionView(200)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict]];
    // 设置下边距
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_directionView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0 constant:-30]];
    // 设置宽高相等
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_directionView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_directionView
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0 constant:0]];
}

- (void)buildButtonA {
    _a = [_factory padButtonView:eTTPadButtonA];
    _a.translatesAutoresizingMaskIntoConstraints = NO;
    _a.tag = eTTPadButtonA;
    [_a addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_a];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_a);
    // 设置右边距与宽
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_a(67)]-130-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict]];
    // 设置下边距
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_a
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0 constant:-30]];
    // 设置宽高相等
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_a
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_a
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0 constant:0]];

}

- (void)buildButtonB {
    _b = [_factory padButtonView:eTTPadButtonB];
    _b.translatesAutoresizingMaskIntoConstraints = NO;
    _b.tag = eTTPadButtonB;
    [_b addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_b];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_b);
    // 设置右边距与宽
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_b(67)]-70-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict]];
    // 设置下边距
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_b
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0 constant:-60]];
    // 设置宽高相等
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_b
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_b
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0 constant:0]];
    
}

- (void)buildButtonC {
    _c = [_factory padButtonView:eTTPadButtonC];
    _c.translatesAutoresizingMaskIntoConstraints = NO;
    _c.tag = eTTPadButtonC;
    [_c addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_c];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_c);
    // 设置右边距与宽
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_c(67)]-10-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict]];
    // 设置下边距
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_c
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0 constant:-90]];
    // 设置宽高相等
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_c
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_c
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0 constant:0]];
    
}

- (void)buildButtonX {
    _x = [_factory padButtonView:eTTPadButtonX];
    _x.translatesAutoresizingMaskIntoConstraints = NO;
    _x.tag = eTTPadButtonX;
    [_x addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_x];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_x);
    // 设置右边距与宽
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_x(67)]-130-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict]];
    // 设置下边距
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_x
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0 constant:-100]];
    // 设置宽高相等
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_x
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_x
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0 constant:0]];
    
}

- (void)buildButtonY {
    _y = [_factory padButtonView:eTTPadButtonY];
    _y.translatesAutoresizingMaskIntoConstraints = NO;
    _y.tag = eTTPadButtonY;
    [_y addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_y];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_y);
    // 设置右边距与宽
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_y(67)]-70-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict]];
    // 设置下边距
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_y
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0 constant:-130]];
    // 设置宽高相等
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_y
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_y
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0 constant:0]];
    
}

- (void)buildButtonZ {
    _z = [_factory padButtonView:eTTPadButtonZ];
    _z.translatesAutoresizingMaskIntoConstraints = NO;
    _z.tag = eTTPadButtonZ;
    [_z addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_z];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_z);
    // 设置右边距与宽
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_z(67)]-10-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict]];
    // 设置下边距
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_z
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0 constant:-160]];
    // 设置宽高相等
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_z
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_z
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0 constant:0]];
    
}

- (void)buildSelect {
    _select = [_factory padButtonView:eTTPadButtonSelect];
    _select.translatesAutoresizingMaskIntoConstraints = NO;
    _select.tag = eTTPadButtonSelect;
    [_select addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_select];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_select);
    // 设置宽
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_select(50)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict]];
    
    // 设置居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_select
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0 constant:0]];
    
    // 设置下边距
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_select
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0 constant:-130]];
    // 设置宽高相等
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_select
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_select
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0 constant:0]];
}

- (void)buildStart {
    _start = [_factory padButtonView:eTTPadButtonStart];
    _start.translatesAutoresizingMaskIntoConstraints = NO;
    _start.tag = eTTPadButtonStart;
    [_start addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_start];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_start);
    // 设置宽
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_start(50)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict]];
    
    // 设置居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_start
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0 constant:0]];
    
    // 设置下边距
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_start
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0 constant:-60]];
    // 设置宽高相等
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_start
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_start
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0 constant:0]];
}

@end
