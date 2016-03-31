
// SJExpandingTextView.m

// Seb Jachec

#import "SJExpandingTextView.h"

@implementation SJExpandingTextView

- (void)setAction:(SEL)theAction Sender:(id)sender {
    actionSender = sender;
    action = theAction;
}

- (void)keyUp:(NSEvent *)theEvent {
    UInt16 key = theEvent.keyCode;
    
    if ((_actionKey && key == _actionKey) || (!_actionKey && key == 36)) {
        if (actionSender && action) {
            NSString *stringSelector = NSStringFromSelector(action);
            
            //Could be action:(id)sender for example
            if ([stringSelector characterAtIndex:stringSelector.length-1] == ':') {
                @try {
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [actionSender performSelector:action withObject:self];
                    #pragma clang diagnostic pop
                }
                @catch (NSException *exception) {
                    NSLog(@"SJExpandingTextView: Unable to performSelector: withObject:self . Selector '%@'. Object: '%@'",NSStringFromSelector(action), [actionSender description]);
                }
            } else {
                //If not, performSelector: as normal
                @try {
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [actionSender performSelector:action];
                    #pragma clang diagnostic pop
                }
                @catch (NSException *exception) {
                    NSLog(@"SJExpandingTextView: Unable to performSelector: . Selector '%@'. Object: '%@'",NSStringFromSelector(action), [actionSender description]);
                }
            }
        }
        
        if (_clearsTextOnEnter) {
            self.string = @"";
            [self didChangeText];
        }
    }
    
    [super keyUp:theEvent];
}

- (BOOL)usingAutoLayout {
    return self.enclosingScrollView.constraints.count;
}

- (void)didChangeText {
    
    [self.layoutManager ensureLayoutForTextContainer:self.textContainer];
    
    //Get the correct sized NSRect for the text in the our text container
    NSRect newRect = [self.layoutManager usedRectForTextContainer:self.textContainer];
    newRect.size.width = self.enclosingScrollView.frame.size.width;
    
    //If there's a height margin set, add it on to the height (of course!)
    if (_heightMargin) newRect.size.height += _heightMargin;
    
    if (self.usingAutoLayout && _flexibleEdgeConstraint) {
        
        float existingHeight = self.enclosingScrollView.frame.size.height;
        float newHeight = newRect.size.height;
        
        float existingConstant = _flexibleEdgeConstraint.constant;
        float newConstant = fabs((newHeight-existingHeight)-existingConstant);
        
        [_flexibleEdgeConstraint.animator setConstant:newConstant];
        
    } else if (!self.usingAutoLayout) {
        [self.enclosingScrollView.animator setFrameSize:newRect.size];
    }
}

@end

