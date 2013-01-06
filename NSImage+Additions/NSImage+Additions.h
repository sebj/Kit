
// NSImage+Additions.h

// Seb Jachec

#import <Cocoa/Cocoa.h>

@interface NSImage (Additions)

@property (getter = trueSize) NSSize trueSize;

- (NSImage*)setSaturation:(NSNumber*)num;
- (NSImage*)setContrast:(NSNumber*)num;
- (NSImage*)setBrightness:(NSNumber*)num;
- (NSImage*)setSaturation:(NSNumber*)sat Brightness:(NSNumber*)bright Contrast:(NSNumber*)ctrst;

- (NSImage*)setExposure:(NSNumber*)num;
- (NSImage*)setVibrance:(NSNumber*)num;

- (NSImage*)sharpenedImage;
- (NSImage*)imageSharpenedWithRadius:(NSNumber*)rad AndIntensity:(NSNumber*)intensity;

+ (NSImage*)blendImage:(NSImage*)top Over:(NSImage*)bottom BlendMode:(CGBlendMode)blendMode Opacity:(float)opacity;

- (NSImage *)squareCrop;

+ (NSImage*)mask:(NSImage *)maskImage Image:(NSImage *)image;

+ (NSImage *)imageWithColor:(NSColor *)color Size:(NSSize)size;

@end
