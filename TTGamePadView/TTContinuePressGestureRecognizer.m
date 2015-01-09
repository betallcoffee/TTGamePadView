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

- (instancetype)initWith:(CGRect)rect andTag:(NSUInteger)tag {
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

- (void)removeAllBounds {
    [self.bounds removeAllObjects];
}

- (void)findPressBounds:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableArray *presses = [[NSMutableArray alloc] init];
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        for (TTContinuePressBound *bound in self.bounds) {
            NSLog(@"gesture began:%f, %f, %f, %f", bound.rect.origin.x, bound.rect.origin.y, bound.rect.size.width, bound.rect.size.height);
            if (CGRectContainsPoint(bound.rect, point)) {
                [presses addObject:bound];
            }
        }
    }
    _presses = [NSArray arrayWithArray:presses];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"gesture began: %d", [touches count]);
    [self findPressBounds:touches withEvent:event];
    self.state = UIGestureRecognizerStateBegan;
    if (self.changeTimer) {
        [self.changeTimer invalidate];
    }
    self.changeTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                        target:self
                                                      selector:@selector(change)
                                                      userInfo:nil repeats:YES];
}

- (void)change {
    self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"gesture move: %d", [touches count]);
    [self findPressBounds:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"gesture end: %d", [touches count]);
    [self.changeTimer invalidate];
    _presses = nil;
    [self setState:UIGestureRecognizerStateRecognized];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"gesture cancel: %d", [touches count]);
    [self .changeTimer invalidate];
    _presses = nil;
    [self setState:UIGestureRecognizerStateRecognized];
}

@end