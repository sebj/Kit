
//  SJView.h

//  Seb Jachec

#import <Cocoa/Cocoa.h>

@interface SJView : NSView

@property (strong) void(^drawBlock)();
@property (strong) void(^baseDrawBlock)();

- (id)initWithFrame:(NSRect)frameRect Gradient:(NSGradient*)theGradient Angle:(int)theAngle;

- (void)fadeToGradient:(NSGradient*)newGradient Duration:(int)animDuration;
- (void)fadeToGradient:(NSGradient*)newGradient;

- (NSImage *)image;

@end