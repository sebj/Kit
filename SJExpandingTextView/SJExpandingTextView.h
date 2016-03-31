
// SJExpandingTextView.h

// Seb Jachec

#import <Cocoa/Cocoa.h>

@interface SJExpandingTextView : NSTextView {
    SEL action;
    id actionSender;
}

@property BOOL clearsTextOnEnter;

@property UInt16 actionKey;

@property int heightMargin;

@property IBOutlet NSLayoutConstraint *flexibleEdgeConstraint;


//Action run on enter
- (void)setAction:(SEL)theAction Sender:(id)sender;

@end
