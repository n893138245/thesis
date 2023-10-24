#ifndef SSETypeDefine_h
#define SSETypeDefine_h
#import <ShareSDK/ShareSDK.h>
@class SSEFriendsPaging;
typedef void(^SSDKAddFriendStateChangedHandler) (SSDKResponseState state, SSDKUser *user, NSError *error);
typedef void(^SSDKGetFriendsStateChangedHandler) (SSDKResponseState state, SSEFriendsPaging *paging,  NSError *error);
typedef void(^SSDKCallApiStateChangedHandler)(SSDKResponseState state, id data, NSError *error);
#endif 