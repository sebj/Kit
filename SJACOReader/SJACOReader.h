
//  SJACOReader.h

//  Seb Jachec

#import <Foundation/Foundation.h>

/** Reads an Adobe .aco swatch file and returns the HEX colors contained within it*/
@interface SJACOReader : NSObject {
    NSString *fileContents;
}

/**
 * Loads a file and gets HEX colors from it
 *
 * @param theFile Path of the file.
 *
 * @return NSArray containing an NSString for each HEX color code
 *
 */
- (NSArray*)HEXColorsFromFile:(NSString*)theFile;

/**
 * Loads a file and gets HEX colors from it
 *
 * @param theURL URL of the file.
 *
 * @return NSArray containing an NSString for each HEX color code
 *
 */
- (NSArray*)HEXColorsFromFileURL:(NSURL*)theURL;

@end
