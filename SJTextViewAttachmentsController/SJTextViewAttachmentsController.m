
//  SJTextViewAttachmentsController.m

// Seb Jachec

#import "SJTextViewAttachmentsController.h"

@implementation SJTextViewAttachmentsController

- (id)initWithTextView:(NSTextView*)aTextView {
    if ([super init]) {
        _textView = aTextView;
        _textView.textStorage.delegate = self;
        
        _attachments = @[];
        _images = @[];
        _maxFileSize = 0;
    }
    return self;
}

- (id)init {
    if ([super init]) {
        _attachments = @[];
        _images = @[];
        _maxFileSize = 0;
    }
    return self;
}

- (BOOL)isImage:(NSString*)aPathExtension {
    NSArray *imageExtensions = @[@"tif",@"tiff",@"jpg",@"jpeg",@"jp2",@"exr",@"pdf",@"png",@"nef",@"gif",@"psd",@"psb"];
    
    if ([imageExtensions containsObject:aPathExtension]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)textStorageWillProcessEditing:(NSNotification *)note {
    NSMutableArray *attachments = [[NSMutableArray alloc] init];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    NSAttributedString *text = _textView.textStorage;
    
    if (note.object != text)
        return;
    
    NSUInteger length = text.length;
    NSRange effectiveRange = NSMakeRange(0, 0);
    
    while (NSMaxRange(effectiveRange) < length) {
        NSTextAttachment *attachment = [text attribute:NSAttachmentAttributeName atIndex:NSMaxRange(effectiveRange) effectiveRange:&effectiveRange];
        NSString *pathExtension = attachment.fileWrapper.preferredFilename.pathExtension;
        
        if (attachment) {
            int sizeInBytes = (int)[attachment.fileWrapper.fileAttributes valueForKey:@"NSFileSize"];
            if (_maxFileSize != 0) {
                if (sizeInBytes <= _maxFileSize) {
                    if ([self isImage:pathExtension]) {
                        NSImage *theImage = [[NSImage alloc] initWithData:attachment.fileWrapper.regularFileContents];
                        [images addObject:theImage];
                    } else {
                        [attachments addObject:attachment.fileWrapper.regularFileContents];
                    }
                }
            }
        }
    }
    
    //To counter a strange glitch where the last image attachment is duplicated
    if (images.count>1) {
        [images removeLastObject];
    }
    
    _attachments = attachments.copy;
    _images = images.copy;
}

@end
