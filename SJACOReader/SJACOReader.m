
//  SJACOReader.m

// Seb Jachec

#import "SJACOReader.h"

@implementation SJACOReader

//Structure:

//0001 <Number of colors (eg. 0008)> 0000 <Followed by HEX codes, separated by 2 sets of 4 zeroes>

//Notes:

//A HEX code like FFF8F3 would be stored as: ffff f8f8 f3f3

- (NSArray*)HEXColorsFromFile:(NSString*)theFile {
    if (![theFile.pathExtension isEqualToString:@"aco"]) {
        return nil;
    }
    
    NSData *theData = [NSData dataWithContentsOfFile:theFile];
    fileContents = theData.description;
    
    return [self getColors];
}

- (NSArray*)HEXColorsFromFileURL:(NSURL*)theURL {
    if (![theURL.pathExtension isEqualToString:@"aco"]) {
        return nil;
    }
    
    NSData *theData = [NSData dataWithContentsOfURL:theURL];
    fileContents = theData.description;
    
    return [self getColors];
}

- (NSArray*)getColors {
    //Rough code..
    fileContents = [fileContents substringWithRange:NSMakeRange(1, fileContents.length-2)];
    
    int colorCount = [fileContents substringWithRange:NSMakeRange(4, 4)].intValue;
    
    fileContents = [[[[fileContents substringFromIndex:9] substringWithRange:NSMakeRange(0, 24*colorCount)] componentsSeparatedByString:@"0000 0002"][0] substringFromIndex:4];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"00000000 " withString:@""];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"0000 0000" withString:@" "];
    //
    
    
    NSMutableArray *hexColors = [[NSMutableArray alloc] init];
    
    NSMutableString *tempString = [NSMutableString stringWithString:@""];
    
    for (NSString *block in [fileContents componentsSeparatedByString:@" "]) {
        
        if (hexColors.count == colorCount) {
            break;
        } else {
            //Append the first half
            NSString *firstHalf = [block substringToIndex:4];
            [tempString appendString:[firstHalf substringToIndex:2]];
            
            //Check if we have a hex code
            if (tempString.length == 6) {
                //Add to array and reset temporary string
                [hexColors addObject:tempString.copy];
                tempString = [NSMutableString stringWithString:@""];
            }
            
            //Try to append the second half (if it exists)
            @try {
                NSString *secondHalf = [block substringFromIndex:4];
                [tempString appendString:[secondHalf substringToIndex:2]];
            }
            @catch (NSException *exception) {
                //Ah well
            }
            
            
            //Check if we have a hex code
            if (tempString.length == 6) {
                //Add to array and reset temporary string
                [hexColors addObject:tempString.copy];
                tempString = [NSMutableString stringWithString:@""];
            }
        }
    }
    
    return hexColors;
}

@end
