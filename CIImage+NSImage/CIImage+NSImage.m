
// CIImage+NSImage.m

// Seb Jachec

#import "CIImage+NSImage.h"

@implementation CIImage (NSImage)

- (NSImage *)NSImage {
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:self];
    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(self.extent.size.width, self.extent.size.height)];
    [image addRepresentation:rep];
    
    return image;
}

+ (CIImage *)imageWithNSImage:(NSImage*)theImage {
    return theImage? [CIImage imageWithData:theImage.TIFFRepresentation] : nil;
}

@end
