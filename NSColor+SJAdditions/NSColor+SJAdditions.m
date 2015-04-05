
//  NSColor+SJAdditions.m

//  Created by Seb Jachec on 03/10/2013.
//  Copyright (c) Sebastian Jachec. All rights reserved.

#import "NSColor+SJAdditions.h"
#import "NSColor+Hex.h"

#define RGBRegex @"rgb\\((([0-1]?[0-9]?[0-9])|([2][0-4][0-9])|(25[0-5])),(([0-1]?[0-9]?[0-9])|([2][0-4][0-9])|(25[0-5])),(([0-1]?[0-9]?[0-9])|([2][0-4][0-9])|(25[0-5]))\\)"
#define RGBARegex @"rgba\\((([0-1]?[0-9]?[0-9])|([2][0-4][0-9])|(25[0-5])),(([0-1]?[0-9]?[0-9])|([2][0-4][0-9])|(25[0-5])),(([0-1]?[0-9]?[0-9])|([2][0-4][0-9])|(25[0-5])),(([0-1]?[0-9]?[0-9])|([2][0-4][0-9])|(25[0-5]))\\)"

@implementation NSColor (SJAdditions)

+ (NSColor *)colorWithRGB:(NSString *)rgbColor {
    if ([[rgbColor substringToIndex:4] isEqualToString:@"rgba"]) {
        //Redirects RGBA colors to appropriate function
        return [self colorWithRGBA:rgbColor];
    } else {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:RGBRegex options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSUInteger matches = [regex numberOfMatchesInString:rgbColor options:0 range:NSMakeRange(0, rgbColor.length)];
        
        if (matches == 1) {
            //One match
            
            //Convert to a RGBA color format
            NSString *rgbaColor = [rgbColor stringByReplacingCharactersInRange:NSMakeRange(rgbColor.length-1, 1) withString:@",1)"];
            rgbaColor = [rgbaColor stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@"rgba"];
            
            return [self colorWithRGBA:rgbaColor];
            
        } else if (matches > 1) {
            //Multiple matches
            NSException *exception = [NSException exceptionWithName:@"InvalidColorException" reason:@"Multiple colors inputted" userInfo:nil];
            @throw exception;
            
            
        } else {
            //No match
            NSException *exception = [NSException exceptionWithName:@"InvalidColorException" reason:@"Invalid rgb color" userInfo:nil];
            @throw exception;
            
        }
        
        return nil;
    }
}

+ (NSColor *)colorWithRGBA:(NSString *)rgbaColor {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:RGBARegex options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSUInteger matches = [regex numberOfMatchesInString:rgbaColor options:0 range:NSMakeRange(0, rgbaColor.length)];
    
    if (matches == 1) {
        //One match
        //Make NSColor from RGBA string
        
        //Remove "rgba(" and ")"
        NSMutableString *removedBrackets = rgbaColor.mutableCopy;
        [removedBrackets replaceCharactersInRange:NSMakeRange(0, 5) withString:@""];
        [removedBrackets replaceCharactersInRange:NSMakeRange(removedBrackets.length-1, 1) withString:@""];
        
        NSArray *colors = [removedBrackets componentsSeparatedByString:@","];
        
        float r,g,b,a;
        
        r = [colors[0] floatValue]/255.0f;
        g = [colors[1] floatValue]/255.0f;
        b = [colors[2] floatValue]/255.0f;
        a = [colors[3] floatValue];
        
        return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a];
        
    } else if (matches > 1) {
        //Multiple matches
        NSException *exception = [NSException exceptionWithName:@"InvalidColorException" reason:@"Multiple colors inputted" userInfo:nil];
        @throw exception;
        
        
    } else {
        //No match
        NSException *exception = [NSException exceptionWithName:@"InvalidColorException" reason:@"Invalid rgb color" userInfo:nil];
        @throw exception;
        
    }
    
    return nil;
}

@end
