
// NSColor+SJAdditions.h

// Seb Jachec

#import <Cocoa/Cocoa.h>

/** Additions to NSColor to use RGB and RGBA string inputs */
@interface NSColor (SJAdditions)

/**
 * Initialises an NSColor with RGB input
 *
 * Note that this method will accept RGB or RGBA input
 * (redirecting RGBA input to return value from
 * 'colorwithRGBA:')
 *
 * @param rgbColor RGB formatted NSString input
 *
 * @return Initialised NSColor, or nil if input invalid
 *
 */
+ (NSColor *)colorWithRGB:(NSString *)rgbColor;

/**
 * Initialises an NSColor with RGBA input
 *
 * @param rgbaColor RGBA formatted NSString input
 *
 * @return Initialised NSColor, or nil if input invalid
 *
 */
+ (NSColor *)colorWithRGBA:(NSString *)rgbaColor;

@end
