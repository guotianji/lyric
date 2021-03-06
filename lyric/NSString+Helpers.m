//
//  NSString+Helpers.m
//  HXStockAccount
//
//  Created by apple on 14-11-5.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "NSString+Helpers.h"
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Helpers)

- (NSString *)stringByUrlEncoding
{
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    static NSString * const kAFCharactersToLeaveUnescaped = @"[].";
    
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, kCFStringEncodingUTF8);
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

- (NSString*)sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}


- (NSMutableDictionary *)dictionaryFromQueryString {
    if (!self)
        return nil;
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSRange separator = [pair rangeOfString:@"="];
        NSString *key, *value;
        if (separator.location != NSNotFound) {
            key = [pair substringToIndex:separator.location];
            value = [[pair substringFromIndex:separator.location + 1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        } else {
            key = pair;
            value = @"";
        }
        
        key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [result setObject:value forKey:key];
    }
    
    return result;
}


+(BOOL)checkStringIsEmpty:(NSString *)string
{
    if(string == nil)
    {
        return YES;
    }
    if([string isKindOfClass:[NSString class]] == NO)
    {
        return YES;
    }
    
    return [[self getTrimStringWithString:string] isEqualToString:@""];
}

+(NSString *)getTrimStringWithString:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
