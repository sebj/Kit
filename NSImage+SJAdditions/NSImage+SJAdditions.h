
// NSImage+SJAdditions.h

// Seb Jachec

#import <Cocoa/Cocoa.h>

#define kA4Ratio NSMakeSize(210, 297)

@interface NSImage (SJAdditions)

- (void)drawWithBlock:(void (^)(void))theDrawBlock;

+ (NSImage *)blendImage:(NSImage *)theTopImage Over:(NSImage *)theBottomImage BlendMode:(CGBlendMode)theBlendMode Alpha:(float)theAlpha;

+ (NSImage *)mask:(NSImage *)theMask Image:(NSImage *)theImage;

+ (NSImage *)imageWithColor:(NSColor *)theColor Size:(NSSize)theSize;

+ (NSImage *)pad:(NSImage *)theImage toAspectRatio:(NSSize)aspectRatio WithBackgroundColor:(NSColor *)bgColor;

- (NSImage *)flippedHorizontally;
- (NSImage *)flippedVertically;

- (CGImageRef)CGImage;

@end
