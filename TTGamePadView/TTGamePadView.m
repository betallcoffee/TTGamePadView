//
//  TTGamePadView.m
//  TTGamePadView
//
//  Created by liang on 1/6/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import "TTGamePadView.h"
#import "TTGamePadViewFactory.h"
#import "TTGamePadViewClassicFactory.h"
#import "TTGamePadViewRockFactory.h"
#import "TTContinuePressGestureRecognizer.h"

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

@property (nonatomic, strong) TTContinuePressGestureRecognizer *gesture;
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
        self.backgroundColor = [UIColor redColor];
        self.gesture = [[TTContinuePressGestureRecognizer alloc] initWithTarget:self action:@selector(responseForRockGesture:)];
        [self addGestureRecognizer:self.gesture];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.gesture removeAllBounds];
    
    [self.gesture addBound:[[TTContinuePressBound alloc] initWithRect:self.a.frame andTag:eTTPadButtonA]];
    [self.gesture addBound:[[TTContinuePressBound alloc] initWithRect:self.b.frame andTag:eTTPadButtonB]];
    [self.gesture addBound:[[TTContinuePressBound alloc] initWithRect:self.c.frame andTag:eTTPadButtonC]];
    [self.gesture addBound:[[TTContinuePressBound alloc] initWithRect:self.x.frame andTag:eTTPadButtonX]];
    [self.gesture addBound:[[TTContinuePressBound alloc] initWithRect:self.y.frame andTag:eTTPadButtonY]];
    [self.gesture addBound:[[TTContinuePressBound alloc] initWithRect:self.z.frame andTag:eTTPadButtonZ]];
    [self.gesture addBound:[[TTContinuePressBound alloc] initWithRect:self.select.frame andTag:eTTPadButtonSelect]];
    [self.gesture addBound:[[TTContinuePressBound alloc] initWithRect:self.start.frame andTag:eTTPadButtonStart]];
    
    [self.gesture addBounds:[self boundsOfDirection]];
}

#pragma mark cut a rect to nine part rect

- (NSArray *)boundsOfDirection {
    int width, height;
    width = self.directionView.bounds.size.width / 3;
    height = self.directionView.bounds.size.height / 3;
    CGRect rectOrigin = CGRectMake(self.directionView.frame.origin.x, self.directionView.frame.origin.y, width, height);
    
    NSDictionary *directions = @{@(eTTDirectionUpLeft):@{@"mx":@(0), @"my":@(0)}, @(eTTDirectionUp):@{@"mx":@(1), @"my":@(0)},
                                 @(eTTDirectionUpRight):@{@"mx":@(2), @"my":@(0)}, @(eTTDirectionRight):@{@"mx":@(2), @"my":@(1)},
                                 @(eTTDirectionDownRight):@{@"mx":@(2), @"my":@(2)}, @(eTTDirectionDown):@{@"mx":@(1), @"my":@(2)},
                                 @(eTTDirectionDownLeft):@{@"mx":@(0), @"my":@(2)}, @(eTTDirectionLeft):@{@"mx":@(0), @"my":@(1)}};
    NSMutableArray *bounds = [[NSMutableArray alloc] initWithCapacity:directions.count];
    [directions enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        *stop = NO;
        NSNumber *direction = (NSNumber *)key;
        NSDictionary *value = (NSDictionary *)obj;
        NSNumber *mx = (NSNumber *)value[@"mx"];
        NSNumber *my = (NSNumber *)value[@"my"];
        CGRect rect = CGRectMake(rectOrigin.origin.x+width*mx.intValue, rectOrigin.origin.y+height*my.intValue,width, height);
        TTContinuePressBound *bound = [[TTContinuePressBound alloc] initWithRect:rect
                                                                      andTag:direction.intValue+20];
        [bounds addObject:bound];
    }];
   
    return bounds;
}

#pragma mark touchs

- (void)responseForRockGesture:(TTContinuePressGestureRecognizer *)gesture {
//    NSLog(@"responseForRockGesture: %@, %d", gesture, gesture.pressBounds.count);
    [self resetAllPadButton];
    
    for (TTContinuePressBound *bound in gesture.pressBounds) {
        NSLog(@"responseForRockGesture: press: %d", bound.tag);
        if ([self selectedPadButton:bound]) {
            NSLog(@"responseForRockGesture: button %@", padButtonName(bound.tag));
            if (self.delegate) {
                [self.delegate TTGamePadView:self button:bound.tag];
            }
        } else if([self pressDirection:bound]){
            NSLog(@"responseForRockGesture: direction %@", directionName(bound.tag - 20));
            if (self.delegate) {
                [self.delegate TTGamePadView:self direction:bound.tag-20];
            }
        }
    }
}

- (void)resetAllPadButton {
    self.a.selected = NO;
    self.b.selected = NO;
    self.c.selected = NO;
    self.x.selected = NO;
    self.y.selected = NO;
    self.z.selected = NO;
    self.select.selected = NO;
    self.start.selected = NO;
}

- (BOOL)selectedPadButton:(TTContinuePressBound *)bound {
    switch (bound.tag) {
        case eTTPadButtonA:
            self.a.selected = YES;
            return YES;
        case eTTPadButtonB:
            self.b.selected = YES;
            return YES;
        case eTTPadButtonC:
            self.c.selected = YES;
            return YES;
        case eTTPadButtonX:
            self.x.selected = YES;
            return YES;
        case eTTPadButtonY:
            self.y.selected = YES;
            return YES;
        case eTTPadButtonZ:
            self.z.selected = YES;
            return YES;
        case eTTPadButtonSelect:
            self.select.selected = YES;
            return YES;
        case eTTPadButtonStart:
            self.start.selected = YES;
            return YES;
        default:
            break;
    }
    return NO;
}

- (BOOL)pressDirection:(TTContinuePressBound *)bound {
    switch (bound.tag-20) {
        case eTTDirectionUpLeft:
            return YES;
        case eTTDirectionUp:
            return YES;
        case eTTDirectionUpRight:
            return YES;
        case eTTDirectionRight:
            return YES;
        case eTTDirectionDownRight:
            return YES;
        case eTTDirectionDown:
            return YES;
        case eTTDirectionDownLeft:
            return YES;
        case eTTDirectionLeft:
            return YES;
        default:
            break;
    }
    return NO;
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
    [self addSubview:_directionView];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_directionView);
    // 设置左边距与宽
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_directionView(159)]"
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
