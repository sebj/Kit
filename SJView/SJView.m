
//  SJView.m

//  Seb Jachec

#import "SJView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SJView

#pragma mark - Basics

- (instancetype)initWithFrame:(NSRect)frame Color:(NSColor*)theColor {
    self = [super initWithFrame:frame];
    
    if (self) {
        if (theColor) {
            [self setDrawBlock:^(void){
                [theColor set];
                NSRectFill(self.bounds);
            }];
        }
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect Gradient:(NSGradient*)theGradient RelativeCenterPosition:(NSPoint)theCenter  {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        if (theGradient) {
            [self setDrawBlock:^(void){
                [theGradient drawInRect:self.bounds relativeCenterPosition:theCenter];
            }];
        }
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect Gradient:(NSGradient*)theGradient Angle:(int)theAngle {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        if (theGradient) {
            [self setDrawBlock:^(void){
                if (theAngle) {
                    [theGradient drawInRect:self.bounds angle:theAngle];
                } else {
                    [theGradient drawInRect:self.bounds angle:-90];
                }
            }];
        }
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {    
    if (self.drawBlock) {
        self.drawBlock();
    } else if (self.baseDrawBlock) {
        self.baseDrawBlock();
    }
}

#pragma mark - Fade to Gradient

- (void)fadeToDrawBlock:(void (^)(void))newDrawBlock withDuration:(CGFloat)animDuration {
    //Make an NSImageView with the current image
    NSImageView *currentImageView = [[NSImageView alloc] initWithFrame:self.frame];
    currentImageView.image = self.image;
    [self addSubview:currentImageView];
    
    
    //Make a new view drawing the new draw block, then get an image from it
    SJView *tempView = [[SJView alloc] initWithFrame:self.frame];
    tempView.drawBlock = newDrawBlock;
    
    //Make a new NSImageView, with the new image
    NSImageView *newImageView = [[NSImageView alloc] initWithFrame:self.frame];
    newImageView.image = tempView.image;
    
    
    [self setWantsLayer:YES];
    
    NSDictionary *backupAnimations = self.animations;
    
    //Setup the transition
    CATransition *fade = [CATransition animation];
    fade.duration = animDuration;
    fade.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fade.type = kCATransitionFade;
    self.animations = @{@"subviews": fade};
    
    //Start the animation, fading from the NSImageView with the current view, to the one with the new one.
    [self replaceSubview:currentImageView with:newImageView];
    
    self.drawBlock = newDrawBlock;
    
    //Remove the NSImageView, to draw as normal
    [newImageView removeFromSuperview];
    
    //Restore previous animations
    self.animations = backupAnimations;
}

- (void)fadeToDrawBlock:(void (^)(void))newDrawBlock {
    [self fadeToDrawBlock:newDrawBlock withDuration:0.25];
}

#pragma mark - Image from View

- (NSImage *)image {
    //Get the size the image needs to be - this current view's size
    NSSize imgSize = NSMakeSize(self.bounds.size.width, self.bounds.size.height);
    
    //Get an NSBitmapImageRep for everything in this view's bounds
    NSBitmapImageRep *bitmapRep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    bitmapRep.size = imgSize;
    [self cacheDisplayInRect:self.bounds toBitmapImageRep:bitmapRep];
    
    //Return an NSImage, using the bitmap image representation (^)
    NSImage *image = [[NSImage alloc] initWithSize:imgSize];
    [image addRepresentation:bitmapRep];
    return image;
}

@end
