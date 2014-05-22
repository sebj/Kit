
//  SJACOReader.m

// Seb Jachec

#import "SJACOReader.h"

@implementation SJACOReader

- (NSArray*)HEXColorsFromFile:(NSString*)theFile {
    if (![theFile.pathExtension isEqualToString:@"aco"]) {
        NSLog(@"SJACOReader: Invalid file extension (expected '.aco')");
        return nil;
    }
    
    return [self getColors:[NSData dataWithContentsOfFile:theFile]];
}

- (NSArray*)HEXColorsFromFileURL:(NSURL*)theURL {
    if (![theURL.pathExtension isEqualToString:@"aco"]) {
        NSLog(@"SJACOReader: Invalid file extension (expected '.aco')");
        return nil;
    }
    
    return [self getColors:[NSData dataWithContentsOfURL:theURL]];
}

- (NSArray*)getColors:(NSData*)theData {
    NSString *fileContents = theData.description;
    
    if (fileContents.length < 29) {
        //Minimum length should be 29, eg. "0001 0001 0000 ffff ffff ffff"
        return nil;
    }
    
    //Trim start and end ("<" and ">")
    fileContents = [fileContents substringWithRange:NSMakeRange(1, fileContents.length-2)];
    //Remove spaces
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    //Sort into 'chunks'
    NSMutableArray *chunks = [[NSMutableArray alloc] init];
    
    NSRange range = NSMakeRange(0, 4);
    while (chunks.count != (fileContents.length/4)) {
        [chunks addObject:[fileContents substringWithRange:range]];
        
        range = NSMakeRange(range.location+4, 4);
    }
    
    
    //Get number of colors
    unsigned colorCount = 0;
    NSScanner *scanner = [NSScanner scannerWithString:chunks[1]];
    [scanner scanHexInt:&colorCount];
    
    //Remove version, number and "blannk" ("0000") after - first 3 objects
    [chunks removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
    
    
    NSMutableArray *hexColors = [[NSMutableArray alloc] init];
    
    //Loop through, turning FFFF 9999 0000 into FF9900
    NSMutableString *temp = [NSMutableString stringWithString:@""];
    for (NSString *block in chunks) {
        if (hexColors.count == colorCount) {
            break;
        }
        
        if (temp.length == 6) {
            [hexColors addObject:temp];
            temp = [NSMutableString stringWithString:@""];
        }
        
        if (![block isEqualToString:@"0000"]) {
            [temp appendString:[block substringToIndex:2]];
        }
    }
    
    return hexColors;
}

@end