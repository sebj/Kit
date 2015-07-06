
// NSImage+SJAdditions.m

// Seb Jachec

#import "NSImage+SJAdditions.h"

@implementation NSImage (SJAdditions)

- (void)drawWithBlock:(void (^)())theDrawBlock {
    [self lockFocus];
    theDrawBlock();
    [self unlockFocus];
}

#pragma mark -

+ (NSImage*)blendImage:(NSImage*)theTopImage Over:(NSImage*)theBottomImage BlendMode:(CGBlendMode)theBlendMode Alpha:(float)theAlpha {
    CGImageRef topRef = theTopImage.CGImage;
    CGImageRef bottomRef = theBottomImage.CGImage;
    
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef currentContext = CGBitmapContextCreate(NULL,
                                                        CGImageGetWidth(bottomRef),
                                                        CGImageGetHeight(bottomRef),
                                                        CGImageGetBitsPerComponent(bottomRef),
                                                        CGImageGetBytesPerRow(bottomRef),
                                                        CGImageGetColorSpace(bottomRef),
                                                        CGImageGetBitmapInfo(bottomRef));
    
    CGRect drawRect = CGRectMake(0, 0, theBottomImage.size.width, theBottomImage.size.height);
    CGContextDrawImage(currentContext, drawRect, bottomRef);
    
    CGContextSetBlendMode(currentContext, theBlendMode);
    CGContextSetAlpha(currentContext, theAlpha);
    
    CGContextDrawImage(currentContext, drawRect, topRef);
    
    CGImageRef retRef = CGBitmapContextCreateImage(currentContext);
    
    NSImage *result = [[NSImage alloc] initWithCGImage:retRef size:theTopImage.size];
    
    CFRelease(genericColorSpace);
    CGImageRelease(topRef);
    CGImageRelease(bottomRef);
    CGImageRelease(retRef);
    
    return result;
}

#pragma mark -

+ (NSImage*)mask:(NSImage *)theMask Image:(NSImage *)theImage {
    
    CGImageRef maskRef = theMask.CGImage;
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)theImage.TIFFRepresentation, NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    
	CGImageRef masked = CGImageCreateWithMask(imageRef, mask);
    
	NSImage *result = [[NSImage alloc] initWithCGImage:masked size:theImage.size];
    
    CGImageRelease(mask);
	CGImageRelease(masked);
	CGImageRelease(maskRef);
    CFRelease(imageSource);
    CGImageRelease(imageRef);
    
    return result;
}

#pragma mark -

+ (NSImage *)imageWithColor:(NSColor *)theColor Size:(NSSize)theSize {
    
    NSImage *retval = [[NSImage alloc] initWithSize:theSize];
    
    [retval drawWithBlock:^{
        [theColor set];
        NSRectFill((NSRect){.origin=NSZeroPoint, .size=theSize});
    }];
    
    return retval;
}

+ (NSImage *)pad:(NSImage *)theImage toAspectRatio:(NSSize)aspectRatio WithBackgroundColor:(NSColor *)bgColor {
    NSSize originalSize = theImage.size;
    NSSize newSize = originalSize;
    
    if (originalSize.width == originalSize.height) {
        newSize.height = round(originalSize.width*(aspectRatio.height/aspectRatio.width));
    }else if (originalSize.width > originalSize.height) {
        newSize.height = round(originalSize.width*(aspectRatio.height/aspectRatio.width));
    } else {
        newSize.width = round(originalSize.height*(aspectRatio.width/aspectRatio.height));
    }
    
    NSImage *newImage = [[NSImage alloc] initWithSize:newSize];
    [newImage drawWithBlock:^(void){
        [bgColor set];
        NSRectFill((NSRect){.origin=NSZeroPoint, .size=newSize});
        [theImage drawAtPoint:NSMakePoint((newSize.width-originalSize.width)/2, newSize.height-originalSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    }];
    
    return newImage;
}

#pragma mark -
#pragma mark Flipping

- (NSImage *)flippedHorizontally {
    __block NSSize selfSize = self.size;
    NSImage *flippedImage = [[NSImage alloc] initWithSize:selfSize];
    
    [flippedImage drawWithBlock:^{
        NSGraphicsContext.currentContext.imageInterpolation = NSImageInterpolationHigh;
        
        NSAffineTransform *t = [NSAffineTransform transform];
        [t translateXBy:selfSize.width yBy:0];
        [t scaleXBy:-1 yBy:1];
        [t concat];
        
        [self drawAtPoint:NSZeroPoint fromRect:(NSRect){.origin=NSZeroPoint, .size=selfSize} operation:NSCompositeSourceOver fraction:1.0];
    }];
    
    return flippedImage;
}
    
- (NSImage*)flippedVertically {
    __block NSSize selfSize = self.size;
    NSImage *flippedImage = [[NSImage alloc] initWithSize:selfSize];
    
    [flippedImage drawWithBlock:^{
        NSGraphicsContext.currentContext.imageInterpolation = NSImageInterpolationHigh;
        
        NSAffineTransform *t = [NSAffineTransform transform];
        [t translateXBy:0 yBy:selfSize.height];
        [t scaleXBy:1 yBy:-1];
        [t concat];
        
        [self drawAtPoint:NSZeroPoint fromRect:NSMakeRect(0, 0, selfSize.width, selfSize.height) operation:NSCompositeSourceOver fraction:1.0];
    }];
    
    return flippedImage;
}

#pragma mark -

- (CGImageRef)CGImage {
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)self.TIFFRepresentation, NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    
    CFRelease(imageSource);
    
    return imageRef;
}

@end
