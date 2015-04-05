
// CIImage+NSImage.h

// Seb Jachec

#import <Quartz/Quartz.h>

@interface CIImage (NSImage)

- (NSImage *)NSImage;

/**
 * @param theImage An NSImage to initialise a CIImage with
 *
 * @return A CIIImage
 */
+ (CIImage *)imageWithNSImage:(NSImage*)theImage;

@end
