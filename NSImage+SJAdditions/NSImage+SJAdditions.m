
// NSImage+SJAdditions.m

// Seb Jachec

#import "NSImage+SJAdditions.h"

@implementation NSImage (SJAdditions)

- (void)drawWithBlock:(void (^)())drawBlock {
    [self lockFocus];
    drawBlock();
    [self unlockFocus];
}

#pragma mark -

+ (NSImage*)blendImage:(NSImage*)top Over:(NSImage*)bottom BlendMode:(CGBlendMode)blendMode Opacity:(float)opacity {
    CGImageRef topRef = top.CGImage;
    CGImageRef bottomRef = bottom.CGImage;
    
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef currentContext = CGBitmapContextCreate(NULL,
                                                        CGImageGetWidth(bottomRef),
                                                        CGImageGetHeight(bottomRef),
                                                        CGImageGetBitsPerComponent(bottomRef),
                                                        CGImageGetBytesPerRow(bottomRef),
                                                        CGImageGetColorSpace(bottomRef),
                                                        CGImageGetBitmapInfo(bottomRef));
    
    CGRect drawRect = CGRectMake(0, 0, bottom.size.width, bottom.size.height);
    CGContextDrawImage(currentContext, drawRect, bottomRef);
    
    CGContextSetBlendMode(currentContext, blendMode);
    CGContextSetAlpha(currentContext, opacity);
    
    CGContextDrawImage(currentContext, drawRect, topRef);
    
    CGImageRef retRef = CGBitmapContextCreateImage(currentContext);
    
    NSImage *result = [[NSImage alloc] initWithCGImage:retRef size:top.size];
    
    CFRelease(genericColorSpace);
    CGImageRelease(topRef);
    CGImageRelease(bottomRef);
    CGImageRelease(retRef);
    
    return result;
}

#pragma mark -

+ (NSImage*)mask:(NSImage *)maskImage Image:(NSImage *)image {
    
    CGImageRef maskRef = maskImage.CGImage;
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)[image TIFFRepresentation], NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    
	CGImageRef masked = CGImageCreateWithMask(imageRef, mask);
    
	NSImage *result = [[NSImage alloc] initWithCGImage:masked size:image.size];
    
    CGImageRelease(mask);
	CGImageRelease(masked);
	CGImageRelease(maskRef);
    CFRelease(imageSource);
    CGImageRelease(imageRef);
    
    return result;
}

#pragma mark -

+ (NSImage *)imageWithColor:(NSColor *)color Size:(NSSize)size {
    
    NSImage *retval = [[NSImage alloc] initWithSize:size];
    
    [retval drawWithBlock:^{
        [color set];
        NSRectFill(NSMakeRect(0,0,size.width,size.height));
    }];
    
    return retval;
}

#pragma mark -
#pragma mark Flipping

- (NSImage *)flippedHorizontally {
    __block NSSize selfSize = self.size;
    NSImage *flippedImage = [[NSImage alloc] initWithSize:selfSize];
    
    [flippedImage drawWithBlock:^{
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        
        NSAffineTransform *t = [NSAffineTransform transform];
        [t translateXBy:selfSize.width yBy:0];
        [t scaleXBy:-1 yBy:1];
        [t concat];
        
        [self drawAtPoint:NSZeroPoint fromRect:NSMakeRect(0, 0, selfSize.width, selfSize.height) operation:NSCompositeSourceOver fraction:1.0];
    }];
    
    return flippedImage;
}

- (NSImage*)flippedVertically {
    __block NSSize selfSize = self.size;
    NSImage *flippedImage = [[NSImage alloc] initWithSize:selfSize];
    
    [flippedImage drawWithBlock:^{
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        
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
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)[self TIFFRepresentation], NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    
    CFRelease(imageSource);
    
    return imageRef;
}

@end