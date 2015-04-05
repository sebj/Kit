
// NSBezierPath+Additions.h

// Seb Jachec

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (Additions)

/**
 * @param smoothness The number of interpolation points, more means a smoother line
 *
 * @return Smoothed NSBezierPath
 */
- (NSBezierPath*)smoothedPath:(CGFloat)smoothness;

/**
 * @return An array containing every major NSPoint along the NSBezierPath
 */
- (NSArray*)points;

@end
