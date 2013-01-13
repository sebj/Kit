
// NSImage+Additions.m

// Seb Jachec

#import "NSImage+Additions.h"
#import "CIImage+NSImage.h"

@implementation NSImage (Additions)

#pragma mark - Image Adjustment

- (NSImage*)setSaturation:(NSNumber*)num {
    return [self setSaturation:num Brightness:nil Contrast:nil];
}

- (NSImage*)setContrast:(NSNumber*)num {
    return [self setSaturation:nil Brightness:nil Contrast:num];
}

- (NSImage*)setBrightness:(NSNumber*)num {
    return [self setSaturation:nil Brightness:num Contrast:nil];
}

- (NSImage*)setSaturation:(NSNumber*)sat Brightness:(NSNumber*)bright Contrast:(NSNumber*)ctrst {
    CIImage *image = [CIImage imageWithNSImage:self];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, image, nil];
    [filter setDefaults];
    
    if (sat) [filter setValue:sat forKey:kCIInputSaturationKey];
    
    if (bright) [filter setValue:bright forKey:kCIInputBrightnessKey];
    
    if (ctrst) [filter setValue:ctrst forKey:kCIInputContrastKey];
    
    CIImage *outputImage = [filter valueForKey:kCIOutputImageKey];
    
    return [outputImage NSImage];
}

- (NSImage*)setExposure:(NSNumber*)num {
    CIImage *image = [CIImage imageWithNSImage:self];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, image, nil];
    [filter setDefaults];
    [filter setValue:num forKey:@"inputEV"];
    
    return [[filter valueForKey:kCIOutputImageKey] NSImage];
}

- (NSImage*)setVibrance:(NSNumber*)num {
    CIImage *image = [CIImage imageWithNSImage:self];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIVibrance" keysAndValues:kCIInputImageKey, image, nil];
    [filter setDefaults];
    [filter setValue:num forKey:@"inputAmount"];
    
    return [[filter valueForKey:kCIOutputImageKey] NSImage];
}

#pragma mark -

- (NSImage*)sharpenedImage {
    return [self imageSharpenedWithRadius:nil AndIntensity:nil];
}

- (NSImage*)imageSharpenedWithRadius:(NSNumber*)rad AndIntensity:(NSNumber*)intensity {
    CIImage *image = [CIImage imageWithNSImage:self];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues:kCIInputImageKey, image, nil];
    [filter setDefaults];
    
    if (rad)
        [filter setValue:rad forKey:kCIInputRadiusKey];
    else {
        //Default to 1.1
        [filter setValue:@1.1 forKey:kCIInputRadiusKey];
    }
    
    if (intensity) [filter setValue:intensity forKey:kCIInputIntensityKey];
    
    CIImage *outputImage = [filter valueForKey:kCIOutputImageKey];
    
    return [outputImage NSImage];
}

#pragma mark -

+ (NSImage*)blendImage:(NSImage*)top Over:(NSImage*)bottom BlendMode:(CGBlendMode)blendMode Opacity:(float)opacity {
    CGImageSourceRef topSource = CGImageSourceCreateWithData((__bridge CFDataRef)[top TIFFRepresentation], NULL);
    CGImageRef topRef = CGImageSourceCreateImageAtIndex(topSource, 0, NULL);
    
    CGImageSourceRef bottomSource = CGImageSourceCreateWithData((__bridge CFDataRef)[bottom TIFFRepresentation], NULL);
    CGImageRef bottomRef = CGImageSourceCreateImageAtIndex(bottomSource, 0, NULL);
    
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    //CGContextRef currentContext = CGBitmapContextCreate(NULL, bottom.size.width, bottom.size.height, 5, 0, genericColorSpace, kCGImageAlphaNoneSkipFirst);
    CGContextRef currentContext = CGBitmapContextCreate(NULL, CGImageGetWidth(bottomRef), CGImageGetHeight(bottomRef), CGImageGetBitsPerComponent(bottomRef), CGImageGetBytesPerRow(bottomRef), CGImageGetColorSpace(bottomRef), CGImageGetBitmapInfo(bottomRef));
    
    CGRect drawRect = CGRectMake(0, 0, bottom.size.width, bottom.size.height);
    CGContextDrawImage(currentContext, drawRect, bottomRef);
    
    CGContextSetBlendMode(currentContext, blendMode);
    CGContextSetAlpha(currentContext, opacity);
    
    CGContextDrawImage(currentContext, drawRect, topRef);
    
    CGImageRef retRef = CGBitmapContextCreateImage(currentContext);
    
    NSImage *result = [[NSImage alloc] initWithCGImage:retRef size:top.size];
    
    CFRelease(genericColorSpace);
    CFRelease(topSource);
    CGImageRelease(topRef);
    CFRelease(bottomSource);
    CGImageRelease(bottomRef);
    CGImageRelease(retRef);
    
    return result;
}

#pragma mark -

- (NSImage *)squareCrop {
    if ((self.size.height > self.size.width) || self.size.height == self.size.width) {
        return [[NSImage alloc] initWithSize:NSMakeSize(self.size.width, self.size.width)];
    } else if (self.size.width > self.size.height)  {
        return [[NSImage alloc] initWithSize:NSMakeSize(self.size.height, self.size.height)];
    } else {
        return self;
    }
}

#pragma mark - True Size

- (void)setTrueSize:(NSSize)theSize {
    [self setSize:theSize];
}

- (NSSize)trueSize
{
    NSImageRep *imageRep = [[NSBitmapImageRep alloc] initWithCIImage:[CIImage imageWithNSImage:self]];
    
    NSInteger width = 0;
    NSInteger height = 0;
    
    if ([imageRep pixelsWide] > width) width = [imageRep pixelsWide];
    if ([imageRep pixelsHigh] > height) height = [imageRep pixelsHigh];
    
    NSSize size = NSMakeSize((CGFloat)width, (CGFloat)height);
    
    return size;
}

#pragma mark - Mask

+ (NSImage*)mask:(NSImage *)maskImage Image:(NSImage *)image {
    
    CGImageSourceRef maskSource = CGImageSourceCreateWithData((__bridge CFDataRef)[maskImage TIFFRepresentation], NULL);
    CGImageRef maskRef = CGImageSourceCreateImageAtIndex(maskSource, 0, NULL);
    
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
    
    CFRelease(maskSource);
    CGImageRelease(mask);
	CGImageRelease(masked);
	CGImageRelease(maskRef);
    CFRelease(imageSource);
    CGImageRelease(imageRef);
    
    return result;
}

#pragma mark - imageWithColor:Size:

+ (NSImage *)imageWithColor:(NSColor *)color Size:(NSSize)size {
    
    NSImage *retval = [[NSImage alloc] initWithSize:size];
    [retval lockFocus];
    [color set];
    NSRectFill(NSMakeRect(0,0,size.width,size.height));
    [retval unlockFocus];
    
    return retval;
}

@end
