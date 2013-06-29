
// NSImage+SJAdditions.h

// Seb Jachec

#import <Cocoa/Cocoa.h>

@interface NSImage (SJAdditions)

- (void)drawWithBlock:(void (^)())drawBlock;

+ (NSImage*)blendImage:(NSImage*)top Over:(NSImage*)bottom BlendMode:(CGBlendMode)blendMode Opacity:(float)opacity;

+ (NSImage*)mask:(NSImage *)maskImage Image:(NSImage *)image;

+ (NSImage *)imageWithColor:(NSColor *)color Size:(NSSize)size;

- (NSImage*)flippedHorizontally;
- (NSImage*)flippedVertically;

- (CGImageRef)CGImage;

@end
