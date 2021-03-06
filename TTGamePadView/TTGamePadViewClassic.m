//
//  TTGamePadViewClassic.m
//  TTGamePadView
//
//  Created by liang on 1/6/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import "TTGamePadViewClassic.h"
#import "TTContinuePressGestureRecognizer.h"

@interface TTGamePadViewClassic ()

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) TTContinuePressGestureRecognizer *gesture;
@property (nonatomic, strong) NSDictionary *directions;

@end

@implementation TTGamePadViewClassic

@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.directions = @{@(eTTDirectionUpLeft):@{@"mx":@(0), @"my":@(0), @"img":@"plt"},
                            @(eTTDirectionUp):@{@"mx":@(1), @"my":@(0), @"img":@"pt"},
                            @(eTTDirectionUpRight):@{@"mx":@(2), @"my":@(0), @"img":@"prt"},
                            @(eTTDirectionRight):@{@"mx":@(2), @"my":@(1), @"img":@"pr"},
                            @(eTTDirectionDownRight):@{@"mx":@(2), @"my":@(2), @"img":@"prd"},
                            @(eTTDirectionDown):@{@"mx":@(1), @"my":@(2), @"img":@"pd"},
                            @(eTTDirectionDownLeft):@{@"mx":@(0), @"my":@(2), @"img":@"pld"},
                            @(eTTDirectionLeft):@{@"mx":@(0), @"my":@(1), @"img":@"pl"}};
        
        self.gesture = [[TTContinuePressGestureRecognizer alloc] initWithTarget:self action:@selector(responseForRockGesture:)];
        [self addGestureRecognizer:self.gesture];
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
    
    [self.gesture removeAllBounds];
    [self.gesture addBounds:[self boundsOfDirection]];
}

#pragma mark cut a rect to nine part rect

- (NSArray *)boundsOfDirection {
    int width, height;
    width = self.bounds.size.width / 3;
    height = self.bounds.size.height / 3;
    CGRect rectOrigin = CGRectMake(0, 0, width, height);
    
    
    NSMutableArray *bounds = [[NSMutableArray alloc] initWithCapacity:self.directions.count];
    [self.directions enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        *stop = NO;
        NSNumber *direction = (NSNumber *)key;
        NSDictionary *value = (NSDictionary *)obj;
        NSNumber *mx = (NSNumber *)value[@"mx"];
        NSNumber *my = (NSNumber *)value[@"my"];
        CGRect rect = CGRectMake(rectOrigin.origin.x+width*mx.intValue, rectOrigin.origin.y+height*my.intValue,width, height);
        TTContinuePressBound *bound = [[TTContinuePressBound alloc] initWithRect:rect
                                                                          andTag:direction.intValue];
        [bounds addObject:bound];
    }];
    
    return bounds;
}

#pragma mark touchs

- (void)responseForRockGesture:(TTContinuePressGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateChanged) {
        [self.background setImage:[UIImage imageNamed:@"gamepad_hand_direction_default.png"]];
        return;
    }
    for (TTContinuePressBound *bound in gesture.pressBounds) {
        NSLog(@"responseForRockGesture: press: %d", bound.tag);
        if([self pressDirection:bound]){
            NSLog(@"responseForRockGesture: direction %@", directionName(bound.tag));
            NSDictionary *direction = (NSDictionary *)self.directions[@(bound.tag)];
            NSString *suffix = (NSString *)direction[@"img"];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gamepad_hand_direction_%@.png", suffix]];
            [self.background setImage:image];
            if (self.delegate != nil) {
                [self.delegate TTGamePadDirectionView:self direction:bound.tag];
            }
        }
    }
}

- (BOOL)pressDirection:(TTContinuePressBound *)bound {
    switch (bound.tag) {
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

@end
