
//  NSTableView+RightClickedIndices.m

//  Created by Sebastian Jachec on 05/04/2015.
//  Copyright (c) Sebastian Jachec. All rights reserved.

#import "NSTableView+RightClickedIndices.h"
#import <objc/runtime.h>

@implementation NSTableView (RightClickedIndices)

- (NSMenu *)menuForEvent:(NSEvent *)event {
    NSPoint mousePoint = [self convertPoint:event.locationInWindow fromView:nil];
    
    objc_setAssociatedObject(self, @selector(rightClickedColumn), @([self columnAtPoint:mousePoint]), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, @selector(rightClickedRow), @([self rowAtPoint:mousePoint]), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return self.menu;
}

- (NSInteger)rightClickedColumn {
    return [objc_getAssociatedObject(self, @selector(rightClickedColumn)) integerValue];
}

- (NSInteger)rightClickedRow {
    return [objc_getAssociatedObject(self, @selector(rightClickedRow)) integerValue];
}

@end
