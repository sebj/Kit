
//  SJView.m

//  Seb Jachec

#import "SJView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SJView

#pragma mark -
#pragma mark Basics

- (id)initWithFrame:(NSRect)frameRect Gradient:(NSGradient*)theGradient Angle:(int)theAngle {
    id toReturn = [self initWithFrame:frameRect];
    
    if (theGradient) {
        [toReturn setDrawBlock:^(void){
            if (theAngle) {
                [theGradient drawInRect:self.bounds angle:theAngle];
            } else {
                [theGradient drawInRect:self.bounds angle:-90];
            }
        }];
    }
    
    return toReturn;
}

- (void)drawRect:(NSRect)dirtyRect
{    
    if (self.drawBlock) {
        self.drawBlock();
    } else if (self.baseDrawBlock) {
        self.baseDrawBlock();
    }
}

#pragma mark -
#pragma mark Fade to Gradient

- (void)fadeToGradient:(NSGradient*)newGradient Duration:(int)animDuration {
    //Get the current view gradient (image)
    NSImage *current = [self image];
    
    //Make an NSImageView with the current gradient image
    NSImageView *currentImageView = [[NSImageView alloc] initWithFrame:self.frame];
    [currentImageView setImage:current];
    
    [self addSubview:currentImageView];
    
    
    //Make a new view drawing the new gradient, then get an image from it
    SJView *tempView = [[SJView alloc] initWithFrame:self.frame];
    [tempView setDrawBlock:^(void){
        //Ask it to draw the new gradient
        [newGradient drawInRect:NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height) angle:-90];
        [self setNeedsDisplay:YES];
    }];
    
    NSImage *new = [tempView image];
    
    //Make a new NSImageView, with the new gradient image
    NSImageView *newImageView = [[NSImageView alloc] initWithFrame:self.frame];
    [newImageView setImage:new];
    
    
    [self setWantsLayer:YES];
    
    //Setup the transition
    CATransition *trans = [CATransition animation];
    
    trans.duration = animDuration;
    trans.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    trans.type = kCATransitionFade;
    self.animations = [NSDictionary dictionaryWithObject:trans forKey:@"subviews"];
    
    //Start the animation, fading from the NSImageView with the current view, to the one with the new one.
    [self replaceSubview:currentImageView with:newImageView];
    
    [self setDrawBlock:^(void){
        //Get ourselves drawing the new gradient
        [newGradient drawInRect:NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height) angle:-90];
    }];
    
    //Remove the NSImageView, to draw as normal
    [newImageView removeFromSuperview];
}

- (void)fadeToGradient:(NSGradient*)newGradient {
    //Fade to the gradient, defaulting to a duration of 0.25s
    [self fadeToGradient:newGradient Duration:0.25];
}

#pragma mark -
#pragma mark Image from View

- (NSImage *)image
{
    //Get the size the image needs to be - this current view's size
    NSSize imgSize = NSMakeSize(self.bounds.size.width, self.bounds.size.height);
    
    //Get an NSBitmapImageRep for everything in this view's bounds
    NSBitmapImageRep *bir = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    [bir setSize:imgSize];
    [self cacheDisplayInRect:self.bounds toBitmapImageRep:bir];
    
    //Return an NSImage, using the bitmap image representation (^)
    NSImage *image = [[NSImage alloc] initWithSize:imgSize];
    [image addRepresentation:bir];
    return image;
}

@end
