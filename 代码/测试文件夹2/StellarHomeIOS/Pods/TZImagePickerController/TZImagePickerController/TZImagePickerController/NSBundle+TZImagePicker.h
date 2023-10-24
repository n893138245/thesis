#import <UIKit/UIKit.h>
@interface NSBundle (TZImagePicker)
+ (NSBundle *)tz_imagePickerBundle;
+ (NSString *)tz_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)tz_localizedStringForKey:(NSString *)key;
@end