
// SJExpandingTextView.m

// Seb Jachec

#import "SJExpandingTextView.h"

@implementation SJExpandingTextView

- (void)didChangeText {
    [self.layoutManager ensureLayoutForTextContainer:self.textContainer];
    
    //Get the correct sized NSRect for the text in the our text container
    NSRect newRect = [self.layoutManager usedRectForTextContainer:self.textContainer];
    
    //If there's a height margin set, add it on to the height (of course!)
    if (_heightMargin) {
        newRect.size.height += _heightMargin;
    }
    
    //Ensure that we doesn't start shrinking when you fill less than a line.
    if ((_minimumWidth && newRect.size.width >= _minimumWidth) || (newRect.size.width >= self.frame.size.width)) {
        //For some reason, I'm not sure why, we need to reference [[You are here] > superview > superview] to get to the our containing NSScrollView and set it's frameSize.
        [self.superview.superview.animator setFrameSize:newRect.size];
    }
}

@end
