
// StatusItem.h

// Seb Jachec

#import <Foundation/Foundation.h>

@protocol StatusItemDelegate <NSObject>
@required
- (void)statusItemClicked:(BOOL)selected;

@end


@interface StatusItem : NSView <NSMenuDelegate>

@property (strong) NSImage *image;
@property (strong) NSMenu *menu;

@property (weak) id<StatusItemDelegate> delegate;

@property BOOL showMenuOnLeftMouseDown;
@property NSRect imageDrawBounds;

- (id)initWithStandardThickness;
- (id)initWithThickness:(CGFloat)thickness;

- (void)drawStandardBackground;

@end
