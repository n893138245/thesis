#import "ObjectIfNull.h"
@implementation NSObject (ObjectIfNull)
+ (id)objectIfNull:(NSObject *)obj
{
    if ([obj isEqual:[NSNull null]]) {
        return nil;
    }
    return obj;
}
@end
@implementation NSString (StringIfNull)
+ (NSString *)stringIfNull:(NSString *)aString
{
    if (aString && ![aString isEqual:[NSNull null]]) {
        return aString;
    }
    return @"";
}
+(BOOL)isEqualNull:(id)value{
    if (value == nil) {
        return YES;
    }
    if (value == [NSNull null]) {
        return  YES;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSString *cleanString = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([cleanString length] == 0) {
            return YES;
        }
        if ([cleanString isEqualToString:@""]) {
            return YES;
        }
    }
    return NO;
}
@end
@implementation NSNumber (NumberIfNull)
+ (NSNumber *)numberIfNull:(NSNumber *)aNumber
{
    if (aNumber && ![aNumber isEqual:[NSNull null]]) {
        return aNumber;
    }
    return [NSNumber numberWithInteger:0];
}
+(BOOL)isEqualNull:(id)value{
    if (!value && ![value isEqual:[NSNull null]]) {
        return YES;
    }
    if (value==nil) {
        return YES;
    }
    return NO;
}
@end
@implementation NSString (StringHave)
+ (NSString *)stringHave:(NSString *)aString{
    if ([aString isEqualToString:@""]) {
        return NSLocalizedString(@"did_not_fill_in", nil);
    }else{
        return aString;
    }
}
@end