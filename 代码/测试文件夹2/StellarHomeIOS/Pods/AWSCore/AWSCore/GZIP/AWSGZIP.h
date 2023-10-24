#import <Foundation/Foundation.h>
void awsgzip_loadGZIP(void);
@interface NSData (AWSGZIP)
- (NSData *)awsgzip_gzippedDataWithCompressionLevel:(float)level;
- (NSData *)awsgzip_gzippedData;
- (NSData *)awsgzip_gunzippedData;
@end