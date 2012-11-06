
//  WolframAlpha.h

//  Seb Jachec

#import <Foundation/Foundation.h>


@class WolframAlpha;

@protocol WolframAlphaDelegate <NSObject>

@optional

- (void)didStartQuery:(WolframAlpha *)wa;

- (void)didFinishQuery:(WolframAlpha *)wa;

@end


@interface WolframAlpha : NSObject

@property (strong) NSString *appID;
@property (nonatomic, assign) id <WolframAlphaDelegate> delegate;


- (id)initWithAppID:(NSString*)value;

- (NSData*)sendQueryWithString:(NSString*)value metric:(BOOL)isMetric;
- (NSData*)sendQueryWithString:(NSString*)value;

- (BOOL)valideQuery:(NSString*)value;

@end