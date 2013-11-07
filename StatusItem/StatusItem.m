
// StatusItem.m

// Seb Jachec

#import "StatusItem.h"

#define kStandardThickness [[NSStatusBar systemStatusBar] thickness]

@implementation StatusItem

#pragma mark - Init

- (id)initWithStandardThickness {
    return [self initWithThickness:kStandardThickness];
}

- (id)initWithThickness:(CGFloat)thickness {
    self = [super init];
    if (self) {
        statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:thickness];
        statusItem.view = [self initWithFrame:(NSRect){.size={thickness, thickness}}];
        
        selected = NO;
        menuVisible = NO;
        _showMenuOnLeftMouseDown = NO;
        _imageDrawBounds = _bounds;
        
        [self setup];
    }
    return self;
}

- (void)setup {
    //Subclasses can override
}

#pragma mark - Drawing

- (void)drawStandardBackground {
    [statusItem drawStatusBarBackgroundInRect:_bounds withHighlight:menuVisible];
}

- (void)drawImage {
    if (_image) {
        NSColor *color = selected? NSColor.whiteColor : NSColor.blackColor;
        
        NSSize statusSize = NSMakeSize(kStandardThickness, kStandardThickness);
        NSImage *statusImage = [NSImage imageWithSize:statusSize flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
            [NSColor.whiteColor set];
            NSRectFill(dstRect);
            
            [_image drawInRect:_imageDrawBounds fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
            
            return YES;
        }];
        
        NSImage *solidColor = [NSImage imageWithSize:statusSize flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
            [color set];
            NSRectFill(dstRect);
            
            return YES;
        }];
        
        NSImage *done = [self mask:statusImage Image:solidColor];
        
        [done drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    //Subclasses can override
    
    [self drawStandardBackground];
    [self drawImage];
}

// From NSImage+SJAdditions
- (NSImage*)mask:(NSImage *)theMask Image:(NSImage *)theImage {
    
    CGImageSourceRef maskSource = CGImageSourceCreateWithData((__bridge CFDataRef)theMask.TIFFRepresentation, NULL);
    CGImageRef maskRef = CGImageSourceCreateImageAtIndex(maskSource, 0, NULL);
    CFRelease(maskSource);
    
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

#pragma mark - Left click

- (void)mouseDown:(NSEvent *)theEvent {
    selected = ! selected;
    
    if (_showMenuOnLeftMouseDown) {
        [self showMenu];
        self.needsDisplay = YES;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(statusItemClicked:)]) {
        [_delegate statusItemClicked:selected];
    }
}

#pragma mark - Right click, menu

- (void)rightMouseDown:(NSEvent *)theEvent {
    [self showMenu];
    self.needsDisplay = YES;
}

- (void)showMenu {
    if (_menu) {
        if (_menu.delegate != self) {
            _menu.delegate = self;
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(statusItemRightClicked:)]) {
            [_delegate statusItemRightClicked:!menuVisible];
        }
        
        [statusItem popUpStatusItemMenu:_menu];
    }
}

- (void)menuWillOpen:(NSMenu*)menu {
    menuVisible = YES;
    selected = YES;
    self.needsDisplay = YES;
}

- (void)menuDidClose:(NSMenu*)menu {
    menuVisible = NO;
    selected = NO;
    self.needsDisplay = YES;
}

@end
