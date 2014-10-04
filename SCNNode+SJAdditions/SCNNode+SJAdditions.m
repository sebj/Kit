
//  SCNNode+SJAdditions.m

//  Created by Seb Jachec on 28/12/2013.
//  Copyright (c) 2013 Seb Jachec. All rights reserved.

#import "SCNNode+SJAdditions.h"
#import <objc/runtime.h>

static char REPRESENTED_FILE;
static char REPRESENTED_DICT;

@implementation SCNNode (SJAdditions)

@dynamic representedFile;
@dynamic representedDictionary;
@dynamic width;

#pragma mark - Represented file/dictionary

- (void)setRepresentedFile:(NSString *)representedFile {
    objc_setAssociatedObject(self, &REPRESENTED_FILE, representedFile, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)representedFile {
    return objc_getAssociatedObject(self, &REPRESENTED_FILE);
}

- (void)setRepresentedDictionary:(NSString *)representedDictionary {
    objc_setAssociatedObject(self, &REPRESENTED_DICT, representedDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary*)representedDictionary {
    return objc_getAssociatedObject(self, &REPRESENTED_DICT);
}

#pragma mark - Width, Height, Bounds

- (CGFloat)width {
    if (!self.geometry) {
        return 0.0;
    }
    
    Class geometryClass = [self.geometry class];
    
    if (geometryClass == [SCNPlane class]) {
        return ((SCNPlane*)self.geometry).width;
        
    } else if (geometryClass == [SCNBox class]) {
        return ((SCNBox*)self.geometry).width;
        
    } else if (geometryClass == [SCNPyramid class]) {
        return ((SCNPyramid*)self.geometry).width;
        
    }
    
    return 0.0;
}

- (CGFloat)height {
    if (!self.geometry) {
        return 0.0;
    }
    
    Class geometryClass = [self.geometry class];
    
    if (geometryClass == [SCNPlane class]) {
        return ((SCNPlane*)self.geometry).height;
        
    } else if (geometryClass == [SCNBox class]) {
        return ((SCNBox*)self.geometry).height;
        
    } else if (geometryClass == [SCNPyramid class]) {
        return ((SCNPyramid*)self.geometry).height;
        
    } else if (geometryClass == [SCNCylinder class]) {
        return ((SCNCylinder*)self.geometry).height;
        
    } else if (geometryClass == [SCNCone class]) {
        return ((SCNCone*)self.geometry).height;
        
    } else if (geometryClass == [SCNTube class]) {
        return ((SCNTube*)self.geometry).height;
        
    }
    
    return 0.0;
}

- (NSRect)planeBounds {
    if (!self.geometry || [self.geometry class] != [SCNPlane class]) {
        return NSZeroRect;
    } else {
        SCNPlane *geometry = (SCNPlane*)self.geometry;
        
        return NSMakeRect(self.position.x-(geometry.width/(float)2), self.position.y-(geometry.height/(float)2), geometry.width, geometry.height);
    }
}

#pragma mark - Contains 3D Vector?

- (BOOL)containsVector:(SCNVector3)aVector withZMargin:(NSUInteger)zMargin {
    NSRect bounds = [self planeBounds];
    
    if (!NSIsEmptyRect(bounds)) {
        if ((aVector.x >= bounds.origin.x && aVector.x <= bounds.origin.x+bounds.size.width) &&
            (aVector.y >= bounds.origin.y && aVector.y <= bounds.origin.y+bounds.size.height)) {
            //Vector is "inside"/hitting, 2D-wise.
            //What about 3D?
            
            if ([self.geometry class] == [SCNBox class]) {
                SCNBox *geometry = (SCNBox*)self.geometry;
                return (aVector.z >= self.position.z-(geometry.length/2) && aVector.z <= self.position.z-(geometry.length/2));
            } else {
               return (aVector.z >= self.position.z-zMargin && aVector.z <= self.position.z+zMargin);
            }
        }
    }
    
    return NO;
}

- (BOOL)containsVector:(SCNVector3)aVector {
    return [self containsVector:aVector withZMargin:0.0];
}

@end
