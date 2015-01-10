//
//  TTContinuePressGestureRecognizer.m
//  TTGamePadView
//
//  Created by liang on 1/9/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import "TTContinuePressGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation TTContinuePressBound

- (instancetype)initWithRect:(CGRect)rect andTag:(NSInteger)tag {
    self = [super init];
    if (self) {
        _rect = rect;
        _tag = tag;
    }
    return self;
}

@end

@interface TTContinuePressGestureRecognizer()

@property (nonatomic, strong) NSTimer *changeTimer;
@property (nonatomic, strong) NSMutableArray *bounds;

@end

@implementation TTContinuePressGestureRecognizer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bounds = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        self.bounds = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addBound:(TTContinuePressBound *)bound {
    [self.bounds addObject:bound];
}

- (void)addBounds:(NSArray *)bounds {
    [self.bounds addObjectsFromArray:bounds];
}

- (void)removeAllBounds {
    [self.bounds removeAllObjects];
}

- (void)findPressBounds:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableArray *pressBounds = [[NSMutableArray alloc] init];
    for (UITouch *touch in touches) {
        NSLog(@"findPressBounds touch figure count:%u", touch.tapCount);
        CGPoint point = [touch locationInView:self.view];
        for (TTContinuePressBound *bound in self.bounds) {
            if (CGRectContainsPoint(bound.rect, point)) {
                NSLog(@"hit press bound touch :%f, %f, %f, %f", bound.rect.origin.x, bound.rect.origin.y, bound.rect.size.width, bound.rect.size.height);
                [pressBounds addObject:bound];
            }
        }
    }
    _pressBounds = [NSArray arrayWithArray:pressBounds];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"gesture began: %u", [touches count]);
    [self findPressBounds:touches withEvent:event];
    self.state = UIGestureRecognizerStateBegan;
    if (self.changeTimer) {
        [self.changeTimer invalidate];
    }
    self.changeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                        target:self
                                                      selector:@selector(change)
                                                      userInfo:nil repeats:YES];
}

- (void)change {
    self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"gesture move: %u", [touches count]);
    [self findPressBounds:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"gesture end: %u", [touches count]);
    [self.changeTimer invalidate];
    _pressBounds = nil;
    [self setState:UIGestureRecognizerStateRecognized];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"gesture cancel: %u", [touches count]);
    [self .changeTimer invalidate];
    _pressBounds = nil;
    [self setState:UIGestureRecognizerStateRecognized];
}

@end
