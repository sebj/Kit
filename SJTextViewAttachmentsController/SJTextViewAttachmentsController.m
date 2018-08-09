
//  SJTextViewAttachmentsController.m

// Seb Jachec

#import "SJTextViewAttachmentsController.h"

@implementation SJTextViewAttachmentsController

- (instancetype)initWithTextView:(NSTextView*)aTextView {
    if ([super init]) {
        _textView = aTextView;
        _textView.textStorage.delegate = self;
        
        _attachments = @[];
        _images = @[];
    }
    return self;
}

- (instancetype)init {
    if ([super init]) {
        _attachments = @[];
        _images = @[];
    }
    return self;
}

#pragma mark -

// Rough implementation.
// Probably want to switch this out for a delegate method or something else depending on your needs
- (BOOL)isImage:(NSString*)aPathExtension {
    NSArray *imageExtensions = @[@"tif",@"tiff",@"jpg",@"jpeg",@"jp2",@"exr",@"pdf",@"png",@"nef",@"raw",@"gif",@"psd",@"psb"];
    return [imageExtensions containsObject:aPathExtension.lowercaseString];
}

- (void)calculateAttachmentsIndices {
    NSAttributedString *text = _textView.textStorage;
    
    NSMutableArray *newIndices = [NSMutableArray new];
    
    int index = 0;
    NSRange range = NSMakeRange(0, 0);
    while (index < text.length) {
        NSTextAttachment *attachment = [text attribute:NSAttachmentAttributeName atIndex:index effectiveRange:&range];
        
        if (attachment) [newIndices addObject:@(index)];
        
        index++;
    }
    
    //To counter a strange glitch in which the last attachment is duplicated
    if (newIndices.count > 1) [newIndices removeLastObject];
    
    _attachmentsIndices = newIndices;
}

//Idea of looping through, useful code: http://www.dejal.com/blog/2007/11/cocoa-custom-attachment-text-view
- (void)textStorage:(NSTextStorage *)textStorage willProcessEditing:(NSTextStorageEditActions)editedMask range:(NSRange)editedRange changeInLength:(NSInteger)delta {
    NSMutableArray *attachments = [NSMutableArray new];
    NSMutableArray *images = [NSMutableArray new];
    
    NSAttributedString *text = _textView.textStorage;
    
    NSRange effectiveRange = NSMakeRange(0, 0);
    
    while (NSMaxRange(effectiveRange) < text.length) {
        NSTextAttachment *attachment = [text attribute:NSAttachmentAttributeName atIndex:NSMaxRange(effectiveRange) effectiveRange:&effectiveRange];
        NSString *pathExtension = attachment.fileWrapper.preferredFilename.pathExtension;
        
        if (attachment) {
            if ([self isImage:pathExtension]) {
                NSImage *theImage = [[NSImage alloc] initWithData:attachment.fileWrapper.regularFileContents];
                [images addObject:theImage];
            }
            
            [attachments addObject: attachment.fileWrapper];
        }
    }
    
    //To counter a strange glitch in which the last attachment is duplicated
    if (images.count > 1) [images removeLastObject];
    if (attachments.count > 1) [attachments removeLastObject];
    
    _attachments = attachments.copy;
    _images = images.copy;
    
    [self calculateAttachmentsIndices];
}

- (NSTextAttachment*)attachmentAtIndex:(NSUInteger)index {
    NSRange effectiveRange = NSMakeRange(0, 0);
    NSTextAttachment *attachment = [_textView.textStorage attribute:NSAttachmentAttributeName atIndex:index effectiveRange:&effectiveRange];
    
    return attachment;
}

@end
