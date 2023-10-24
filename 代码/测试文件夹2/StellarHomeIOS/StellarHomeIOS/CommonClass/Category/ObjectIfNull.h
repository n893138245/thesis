#import <Foundation/Foundation.h>
#define NullString(str) [NSString stringIfNull:str]
#define NullNumber(num) [NSNumber numberIfNull:num]
#define HaveNoString(str) [NSString stringHave:str]
@interface NSObject (ObjectIfNull)
+ (id)objectIfNull:(NSObject *)obj;
@end
@interface NSString (StringIfNull)
+ (NSString *)stringIfNull:(NSString *)aString;
+(BOOL)isEqualNull:(id)value;
@end
@interface NSNumber (NumberIfNull)
+ (NSNumber *)numberIfNull:(NSNumber *)aNumber;
+(BOOL)isEqualNull:(id)value;
@end
@interface NSString (StringHave)
+ (NSString *)stringHave:(NSString *)aString;
@end