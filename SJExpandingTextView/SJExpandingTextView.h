
// SJExpandingTextView.h

// Seb Jachec

#import <Cocoa/Cocoa.h>

@interface SJExpandingTextView : NSTextView {
    id actionSender;
}

@property int minimumWidth;
@property int heightMargin;

@property SEL action;

- (void)setAction:(SEL)action Sender:(id)sender;

@end
