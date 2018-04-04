
//  SJView.h

//  Seb Jachec

#import <Cocoa/Cocoa.h>

/** A view that allows blocks for drawing, can fade between background gradients and can return an image of itself */
@interface SJView : NSView

@property (strong) void(^drawBlock)(void);
@property (strong) void(^baseDrawBlock)(void);

@property (readonly, getter = image) NSImage *image;

/**
 * Initialises a view with a solid color
 *
 * @param frameRect Frame for view
 * @param theColor The color to draw/fill the view with
 */
- (instancetype)initWithFrame:(NSRect)frameRect Color:(NSColor*)theColor;

/**
 * Initialises a view with a radial gradient
 *
 * @param frameRect Frame for view
 * @param theGradient The gradient to draw
 * @param theCenter The relative center point of the gradient
 */
- (instancetype)initWithFrame:(NSRect)frameRect Gradient:(NSGradient*)theGradient RelativeCenterPosition:(NSPoint)theCenter;

/**
 * Initialises a view with a linear gradient
 *
 * @param frameRect Frame for view
 * @param theGradient The gradient to draw
 * @param theAngle The angle at which to draw the gradient
 */
- (instancetype)initWithFrame:(NSRect)frameRect Gradient:(NSGradient*)theGradient Angle:(int)theAngle;


- (void)fadeToDrawBlock:(void (^)(void))newDrawBlock withDuration:(CGFloat)animDuration;

/**
 * Fade the view's contents to a new gradient, using the default duration of 0.25s
 */
- (void)fadeToDrawBlock:(void (^)(void))newDrawBlock;


/**
 * @return An NSImage of the same size as the view, containing its contents
 */
- (NSImage *)image;

@end
