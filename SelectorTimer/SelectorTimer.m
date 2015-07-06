
//  SelectorTimer.m

//  Created by Sebastian Jachec on 28/06/2015.
//  Copyright (c) 2015 Sebastian Jachec. All rights reserved.

#import "SelectorTimer.h"

@implementation TestObject

+ (instancetype)objectWithSelector:(SEL)aSel Object:(id)anObject Target:(id)aTarget RunCount:(int)runCount {
    TestObject *a = [TestObject new];
    a.selector = aSel;
    a.object = anObject;
    a.target = aTarget;
    a.runCount = runCount;
    return a;
}

@end

@implementation SelectorTimer

+ (double)convertTimeToSeconds:(CGFloat)aTime {
    if (time > 0) {
        uint64_t elapsedTimeNano = 0;
        
        mach_timebase_info_data_t timeBaseInfo;
        mach_timebase_info(&timeBaseInfo);
        elapsedTimeNano = aTime * timeBaseInfo.numer / timeBaseInfo.denom;
        double elapsedSeconds = elapsedTimeNano * 1.0E-9;
        return elapsedSeconds;
    }
    return 0.0;
}

+ (NSArray*)averageTimesToPerformTests:(NSArray*)tests {
    NSMutableArray *times = [NSMutableArray new];
    
    for (id obj in tests) {
        if ([obj class] == [TestObject class]) {
            CGFloat time = [SelectorTimer averageTimeToPerformTest:obj];
            [times addObject:@(time)];
        }
    }
    
    return times;
}

+ (CGFloat)averageTimeToPerformTest:(TestObject*)aTest {
    return [SelectorTimer averageTimeToPerformSelector:aTest.selector withObject:aTest.object forTarget:aTest.target withRunCount:aTest.runCount];
}

+ (CGFloat)averageTimeToPerformSelector:(SEL)aSel withObject:(id)anObject forTarget:(id)aTarget withRunCount:(int)runCount {
    float total = 0.0;
    
    int i = 0;
    while (i != runCount) {
        uint64_t start = mach_absolute_time();
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [aTarget performSelector:aSel withObject:anObject];
        #pragma clang diagnostic pop
        uint64_t stop = mach_absolute_time();
        
        uint64_t elapsed = stop - start;
        total += elapsed;
        
        i++;
    }
    
    return (float)total/(float)i;
}

@end
