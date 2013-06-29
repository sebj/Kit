
//  SJTextViewAttachmentsController.h

// Seb Jachec

#import <Foundation/Foundation.h>

@interface SJTextViewAttachmentsController : NSObject <NSTextStorageDelegate>

/**
 * NSTextView to monitor
 */
@property (strong) NSTextView *textView;


/**
 * NSFileWrapper for every attachment
 */
@property (strong) NSArray *attachments;

/**
 * NSImage for every image found
 */
@property (strong) NSArray *images;


/**
 * The methood initalises a new SJTextViewAttachmentsController with a text view,
 * and sets it as the text view's text storage delegate
 *
 * @param aTextView NSTextView to use
 *
 * @return An initialised SJTextViewAttachmentsController
 *
 */
- (id)initWithTextView:(NSTextView*)aTextView;

@end
