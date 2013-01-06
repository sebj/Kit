
// CIImage+NSImage.h

// Seb Jachec

#import <QuartzCore/QuartzCore.h>

@interface CIImage (NSImage)

- (NSImage *)NSImage;

+ (CIImage *)imageWithNSImage:(NSImage*)nsimg;

@end
