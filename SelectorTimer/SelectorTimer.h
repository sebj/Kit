
//  SelectorTimer.h

//  Created by Sebastian Jachec on 28/06/2015.
//  Copyright (c) 2015 Sebastian Jachec. All rights reserved.

#import <Foundation/Foundation.h>

@interface TestObject : NSObject

@property SEL selector;
@property (strong) id object;
@property (strong) id target;
@property int runCount;

+ (instancetype)objectWithSelector:(SEL)aSel Object:(id)anObject Target:(id)aTarget RunCount:(int)runCount;

@end

@interface SelectorTimer : NSObject

+ (double)convertTimeToSeconds:(CGFloat)aTime;

+ (NSArray*)averageTimesToPerformTests:(NSArray*)tests;

+ (CGFloat)averageTimeToPerformSelector:(SEL)aSel withObject:(id)anObject forTarget:(id)aTarget withRunCount:(int)runCount;

@end
