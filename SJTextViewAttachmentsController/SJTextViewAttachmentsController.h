
//  SJTextViewAttachmentsController.h

// Seb Jachec

#import <Foundation/Foundation.h>

@interface SJTextViewAttachmentsController : NSObject <NSTextStorageDelegate>

@property (strong) NSTextView *textView;
//Max file size (bytes) to load & store in array
@property int maxFileSize;

@property (strong) NSArray *attachments;
@property (strong) NSArray *images;


//Initalises SJTextViewAttachmentsController with a text view, and sets it as the text view's text storage delegate
- (id)initWithTextView:(NSTextView*)aTextView;

@end
