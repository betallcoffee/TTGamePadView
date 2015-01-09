//
//  TTContinuePressGestureRecognizer.h
//  TTGamePadView
//
//  Created by liang on 1/9/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TTContinuePressBound : NSObject

@property (nonatomic, readonly) CGRect rect;
@property (nonatomic, readonly) NSInteger tag;

- (instancetype)initWithRect:(CGRect)rect andTag:(NSInteger)tag;

@end

@interface TTContinuePressGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) NSArray *pressBounds;

- (void)addBound:(TTContinuePressBound *)bound;
- (void)addBounds:(NSArray *)bounds;
- (void)removeAllBounds;

@end
