
// NSImage+SJAdditions.h

// Seb Jachec

#import <Cocoa/Cocoa.h>

@interface NSImage (SJAdditions)

- (void)drawWithBlock:(void (^)())theDrawBlock;

+ (NSImage*)blendImage:(NSImage*)theTopImage Over:(NSImage*)theBottomImage BlendMode:(CGBlendMode)theBlendMode Alpha:(float)theAlpha;

+ (NSImage*)mask:(NSImage *)theMask Image:(NSImage *)theImage;

+ (NSImage *)imageWithColor:(NSColor *)theColor Size:(NSSize)theSize;

- (NSImage*)flippedHorizontally;
- (NSImage*)flippedVertically;

- (CGImageRef)CGImage;

@end
