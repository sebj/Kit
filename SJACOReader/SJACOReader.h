
//  SJACOReader.h

//  Seb Jachec

#import <Foundation/Foundation.h>

/** Reads an Adobe .aco swatch file and returns the Hexadecimal colors contained within it */
@interface SJACOReader : NSObject

- (instancetype)initWithFile:(NSString*)aFile;

- (instancetype)initWithURL:(NSURL*)aURL;

/*
 * @returns The number of Hex colors within the file, or 0 if unable get the count
 */
@property (readonly, getter = numberOfColors) int numberOfColors;

/*
 * @returns An array containing each Hex color, or nil if unable to get the  colors
 */
@property (readonly, getter = colors) NSArray *colors;

@end
