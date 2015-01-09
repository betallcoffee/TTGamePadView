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
@property (nonatomic, readonly) NSUInteger tag;

- (instancetype)initWith:(CGRect)rect andTag:(NSUInteger)tag;

@end

@interface TTContinuePressGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) NSArray *pressBounds;

- (void)addBound:(TTContinuePressBound *)bound;
- (void)removeAllBounds;

@end
