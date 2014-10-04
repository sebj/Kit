
//  SCNNode+SJAdditions.h

//  Created by Seb Jachec on 28/12/2013.
//  Copyright (c) 2013 Seb Jachec. All rights reserved.

#import <SceneKit/SceneKit.h>

@interface SCNNode (SJAdditions)

@property (nonatomic, retain) NSString *representedFile;
@property (nonatomic, retain) NSDictionary *representedDictionary;

/*
 * Will attempt to give height for any geometry. If none, or unable to, height will be 0
 */
@property (readonly) CGFloat height;

/*
 * Will attempt to give width for any geometry. If none, or unable to, width will be 0
 */
@property (readonly) CGFloat width;


/*
 * If node's geometry is an SCNPlane, this will return the bounds of the plane using the bottom-left as origin instead of middle.
 * Note: this will return NSZeroRect if the node has no geometry or no SCNPlane as geometry
 */
- (NSRect)planeBounds;


/*
 * Checks if geometry (SCNBox, or SCNPlane [2D X,Y checks] only) contains 3D vector
 * Other node geometry, or no node geometry, will return NO.
 */
- (BOOL)containsVector:(SCNVector3)aVector;

/*
 * Same as containsVector: but allows a certain z area around geometry, eg. in case of SCNPlane, will check aVector's Z position is within zMargin of either side of plane
 * [WIP]
 */
- (BOOL)containsVector:(SCNVector3)aVector withZMargin:(NSUInteger)zMargin;

@end
