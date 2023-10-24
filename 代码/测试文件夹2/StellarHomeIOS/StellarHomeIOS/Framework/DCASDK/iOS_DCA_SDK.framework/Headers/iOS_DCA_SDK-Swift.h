#if 0
#elif defined(__arm64__) && __arm64__
#ifndef IOS_DCA_SDK_SWIFT_H
#define IOS_DCA_SDK_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"
#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif
#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif
#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif
#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif
#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif
#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif
#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import CoreGraphics;
@import Foundation;
@import ObjectiveC;
@import UIKit;
@import WebKit;
@import YYKit;
#endif
#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"
#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="iOS_DCA_SDK",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif
typedef SWIFT_ENUM(NSInteger, APNetworkState, open) {
  APNetworkStateAPNetworkSuccess = 0,
  APNetworkStateAPNetworkFailure = 1,
  APNetworkStateAPNetworkConnecting = 2,
};
@class NSCoder;
SWIFT_CLASS("_TtC11iOS_DCA_SDK17AboutUsH5UrlModel")
@interface AboutUsH5UrlModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable adCooperation;
@property (nonatomic, copy) NSString * _Nullable commonProblem;
@property (nonatomic, copy) NSString * _Nullable companyProcurement;
@property (nonatomic, copy) NSString * _Nullable contactUs;
@property (nonatomic, copy) NSString * _Nullable hardwareInformation;
@property (nonatomic, copy) NSString * _Nullable secrecyProtocol;
@property (nonatomic, copy) NSString * _Nullable serviceProtocol;
@property (nonatomic, copy) NSString * _Nullable shopLink;
@property (nonatomic, copy) NSString * _Nullable useGuide;
@property (nonatomic, copy) NSString * _Nullable userProtocol;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class AccountTokenModel;
@class AccountRmemAuthModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK12AccountModel")
@interface AccountModel : NSObject <NSCoding, YYModel>
@property (nonatomic) BOOL isNewUser;
@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable pwCredential;
@property (nonatomic, strong) AccountTokenModel * _Nullable TOKEN;
@property (nonatomic, strong) AccountRmemAuthModel * _Nullable RmemAuth;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20AccountRmemAuthModel")
@interface AccountRmemAuthModel : NSObject
@property (nonatomic, copy) NSString * _Nullable value;
@property (nonatomic, copy) NSString * _Nullable expire_in;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK17AccountTokenModel")
@interface AccountTokenModel : NSObject
@property (nonatomic, copy) NSString * _Nullable value;
@property (nonatomic, copy) NSString * _Nullable expire_in;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18AdvertisementModel")
@interface AdvertisementModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger mode;
@property (nonatomic, copy) NSString * _Nullable appId;
@property (nonatomic) NSInteger adId;
@property (nonatomic) NSInteger type;
@property (nonatomic, copy) NSString * _Nullable content;
@property (nonatomic, copy) NSString * _Nullable url;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK23ApplianceAliasSyncModel")
@interface ApplianceAliasSyncModel : NSObject
@property (nonatomic, copy) NSString * _Nullable skillId;
@property (nonatomic, copy) NSString * _Nullable skillVersion;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13HiFiBaseModel")
@interface HiFiBaseModel : NSObject <NSCoding, YYModel>
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22ArtistGroupDetailModel")
@interface ArtistGroupDetailModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable smallimg;
@property (nonatomic, copy) NSString * _Nullable artistId;
@property (nonatomic, copy) NSString * _Nullable name;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20ArtistGroupListModel")
@interface ArtistGroupListModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable image;
@property (nonatomic, copy) NSString * _Nullable groupId;
@property (nonatomic, copy) NSString * _Nullable name;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18AudioFileListModel")
@interface AudioFileListModel : HiFiBaseModel
@property (nonatomic) NSInteger audioCategoryId;
@property (nonatomic, copy) NSString * _Nullable musicUrl;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13BabyDataModel")
@interface BabyDataModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger born;
@property (nonatomic, copy) NSString * _Nullable relation;
@property (nonatomic) NSInteger sex;
@property (nonatomic) NSInteger babyInfoId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15BatchPosRequest")
@interface BatchPosRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull skillId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, BleNetworkState, open) {
  BleNetworkStateBleNetworkSuccess = 0,
  BleNetworkStateBleNetworkFailure = 1,
  BleNetworkStateBleNetworkConnecting = 2,
};
typedef SWIFT_ENUM(NSInteger, BluetoothState, open) {
  BluetoothStateBluetoothOpen = 0,
  BluetoothStateBluetoothClose = 1,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK15BookSearchModel")
@interface BookSearchModel : NSObject
@property (nonatomic, copy) NSString * _Nullable announcer;
@property (nonatomic, copy) NSString * _Nullable author;
@property (nonatomic, copy) NSString * _Nullable cover;
@property (nonatomic, copy) NSString * _Nullable desc;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable musicId;
@property (nonatomic, copy) NSString * _Nullable typeName;
@property (nonatomic, copy) NSString * _Nullable typeId;
@property (nonatomic) NSInteger state;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22BookTypeReadStatsModel")
@interface BookTypeReadStatsModel : NSObject <NSCoding, YYModel>
@property (nonatomic) double ratio;
@property (nonatomic, copy) NSString * _Nullable bookTypeName;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK21ChildAlbumBrowseModel")
@interface ChildAlbumBrowseModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable musicId;
@property (nonatomic, copy) NSString * _Nullable musicTitle;
@property (nonatomic, copy) NSString * _Nullable musicType;
@property (nonatomic, copy) NSString * _Nullable artistsName;
@property (nonatomic, copy) NSString * _Nullable albumName;
@property (nonatomic) double duration;
@property (nonatomic, copy) NSString * _Nullable play_url;
@property (nonatomic) BOOL isfav;
@property (nonatomic) BOOL isplay;
@property (nonatomic, copy) NSString * _Nullable cover_url_middle;
@property (nonatomic, copy) NSString * _Nullable cover_url_large;
@property (nonatomic, copy) NSString * _Nullable sort;
@property (nonatomic) BOOL isOwn;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK21ChildBatchDetailModel")
@interface ChildBatchDetailModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable aboumId;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable front_url;
@property (nonatomic, copy) NSString * _Nullable author;
@property (nonatomic) double duration;
@property (nonatomic, copy) NSString * _Nullable des;
@property (nonatomic, copy) NSString * _Nullable source;
@property (nonatomic, copy) NSString * _Nullable type;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK19ChildBatchListModel")
@interface ChildBatchListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable ID;
@property (nonatomic, copy) NSString * _Nullable mouldName;
@property (nonatomic, copy) NSString * _Nullable mouldType;
@property (nonatomic, copy) NSString * _Nullable albumType;
@property (nonatomic, copy) NSArray<ChildBatchDetailModel *> * _Nullable data;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18ChildCarouselModel")
@interface ChildCarouselModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable imgUrl;
@property (nonatomic) NSInteger position;
@property (nonatomic, copy) NSString * _Nullable redirection;
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic, copy) NSString * _Nullable information;
@property (nonatomic, copy) NSString * _Nullable source;
@property (nonatomic, copy) NSString * _Nullable stype;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK14CommandRequest")
@interface CommandRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable text;
@property (nonatomic, copy) NSString * _Nullable type;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, ConnectStatus, open) {
  ConnectStatusCONNECT_SUCCESS = 1,
  ConnectStatusCONNECT_FAIL = 2,
  ConnectStatusSUBSCRIBE_SUCCESS = 3,
  ConnectStatusUNSUBSCRIBE_SUCCESS = 4,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK18CourseAlbumRequest")
@interface CourseAlbumRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable grade;
@property (nonatomic, copy) NSString * _Nullable subject;
@property (nonatomic, copy) NSString * _Nullable version;
@property (nonatomic, copy) NSString * _Nullable term;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class NSDictionary;
SWIFT_CLASS("_TtC11iOS_DCA_SDK15DCAAPNetManager")
@interface DCAAPNetManager : NSObject
@property (nonatomic, copy) NSString * _Nonnull urlStr;
@property (nonatomic, copy) NSString * _Nonnull deviceWifiName;
- (void)startAPNetworkWithWifiStr:(NSString * _Nonnull)wifiStr pwd:(NSString * _Nonnull)pwd apNetResult:(void (^ _Nullable)(enum APNetworkState, NSString * _Nonnull, NSDictionary * _Nonnull))apNetResult;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class WeChatLoginRequest;
@class LinkPhoneRequest;
@class GetCodeRequestModel;
@class LoginRequest;
@class VerifyRequest;
@class InitPasswordRequest;
@class SetPasswordRequest;
@class NSError;
@class QuickLoginRequest;
SWIFT_CLASS("_TtC11iOS_DCA_SDK17DCAAccountManager")
@interface DCAAccountManager : NSObject
- (NSString * _Nonnull)getUserId SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nonnull)getAccessToken SWIFT_WARN_UNUSED_RESULT;
- (void)loginOut;
- (void)loginByWeChatWithRequest:(WeChatLoginRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AccountModel * _Nullable))callBack;
- (void)linkPhoneNumWithRequest:(LinkPhoneRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AccountModel * _Nullable))callBack;
- (void)getVerifyCodeWithRequestModel:(GetCodeRequestModel * _Nonnull)requestModel callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)loginWithRequest:(LoginRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AccountModel * _Nullable))callBack;
- (void)verifyUserNameBySmsCodeWithRequest:(VerifyRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AccountModel * _Nullable))callBack;
- (void)initPasswordWithRequest:(InitPasswordRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack SWIFT_METHOD_FAMILY(none);
- (void)setPasswordWithRequest:(SetPasswordRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)linkAcountWithThirdPlatformUid:(NSString * _Nonnull)thirdPlatformUid thirdPlatformToken:(NSString * _Nonnull)thirdPlatformToken manufactureSecret:(NSString * _Nonnull)manufactureSecret callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AccountModel * _Nullable))callBack;
- (void)refreshTokenWithCallBack:(void (^ _Nonnull)(BOOL))callBack;
- (void)getWeChatAuthDataWithWxAppId:(NSString * _Nonnull)wxAppId wxAppSecret:(NSString * _Nonnull)wxAppSecret code:(NSString * _Nonnull)code callBack:(void (^ _Nonnull)(NSDictionary * _Nullable, NSError * _Nullable))callBack;
- (void)getWeChatLoginUserInfoWithAccessToken:(NSString * _Nonnull)accessToken openId:(NSString * _Nonnull)openId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable, NSError * _Nullable))callBack;
- (void)phoneQuickLoginWithRequest:(QuickLoginRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AccountModel * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13DCAAppManager")
@interface DCAAppManager : NSObject
- (void)getAdvertisementListDataWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AdvertisementModel * _Nullable))callBack;
- (void)getCarouselDataWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ChildCarouselModel *> * _Nullable))callBack;
- (void)feedBackWithType:(NSString * _Nonnull)type userPhone:(NSString * _Nonnull)userPhone content:(NSString * _Nonnull)content imageUrl:(NSString * _Nonnull)imageUrl callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)loadAboutUsMsgDataWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AboutUsH5UrlModel * _Nullable))callBack;
- (void)checkAppVersionWithVersion:(NSString * _Nonnull)version callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class CBPeripheral;
@class UIViewController;
enum ReceiveState : NSInteger;
SWIFT_CLASS("_TtC11iOS_DCA_SDK16DCABleNetManager")
@interface DCABleNetManager : NSObject
- (void)getDeviceIdWithBleDeviceID:(void (^ _Nullable)(NSString * _Nonnull))bleDeviceID;
- (void)initBleNetworkWithBleState:(void (^ _Nullable)(enum BluetoothState))bleState SWIFT_METHOD_FAMILY(none);
- (void)startDiscoverBleWithBleData:(void (^ _Nullable)(NSDictionary * _Nonnull))bleData;
- (void)sendDataToDeviceWithPeripheral:(CBPeripheral * _Nonnull)peripheral ssid:(NSString * _Nonnull)ssid pwd:(NSString * _Nonnull)pwd vc:(UIViewController * _Nonnull)vc bleNetResult:(void (^ _Nonnull)(enum BleNetworkState, NSString * _Nonnull, NSDictionary * _Nonnull))bleNetResult;
- (void)sendWifiInfoToDeviceWithPeripheral:(CBPeripheral * _Nonnull)peripheral ssid:(NSString * _Nonnull)ssid pwd:(NSString * _Nonnull)pwd vc:(UIViewController * _Nonnull)vc receiveResult:(void (^ _Nonnull)(enum ReceiveState, NSString * _Nonnull))receiveResult;
- (void)stopDiscoverBle;
- (void)deallocBleNetwork;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
enum PlayStatus : NSInteger;
SWIFT_CLASS("_TtC11iOS_DCA_SDK23DCADeviceControlManager")
@interface DCADeviceControlManager : NSObject
@property (nonatomic) BOOL isConnect;
- (void)connectWithConnectStatus:(void (^ _Nullable)(enum ConnectStatus))connectStatus;
- (void)subscribeTopicWithTopic:(NSString * _Nullable)topic;
- (void)sendDataWithTopic:(NSString * _Nullable)topic jsonStr:(NSString * _Nullable)jsonStr isRetain:(BOOL)isRetain;
- (void)unSubscribeTopicWithTopic:(NSString * _Nullable)topic;
- (void)disconnect;
- (void)onReceiveControlMessageWithReceiveMessage:(void (^ _Nullable)(enum PlayStatus, NSDictionary * _Nonnull))receiveMessage;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@interface DCADeviceControlManager (SWIFT_EXTENSION(iOS_DCA_SDK))
- (void)pausePlayWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)continuePlayWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)playPreviousMusicWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)playNextMusicWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getPlayListWithPage:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSInteger, NSArray<ChildAlbumBrowseModel *> * _Nullable))callBack;
- (void)cleanPlayListWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getCurrentPlayIndexWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getCurrentPlayModelWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)setPlayModelWithCurmodel:(NSString * _Nonnull)curmodel callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)playMusicFromPlayListWithSort:(NSString * _Nonnull)sort callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getVolumeWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)setVolumeWithVolume:(NSInteger)volume callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)playMuiscFromListWithModel:(ChildAlbumBrowseModel * _Nonnull)model callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)playMuiscFromAlbumListWithInformation:(NSString * _Nonnull)information model:(ChildBatchDetailModel * _Nonnull)model index:(NSInteger)index callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)pushTolistAndPlayWithIndex:(NSInteger)index musicType:(NSString * _Nonnull)musicType list:(NSArray<ChildAlbumBrowseModel *> * _Nonnull)list callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)playCollectionListWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
@end
@class EquipDeviceInfoModel;
@class EquipAlarmModel;
@class NSArray;
@class EquipRemindModel;
@class EquipVoiceMessageModel;
@class NSData;
@class EquCallRecordListModel;
@class FamilyGroupChatListModel;
@class FGCDetailListModel;
@class QuickCreateRequest;
@class InstructionModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK16DCADeviceManager")
@interface DCADeviceManager : NSObject
@property (nonatomic, copy) NSString * _Nonnull codeVerifier;
- (void)requestAuthCodeWithRedirectUrl:(NSString * _Nonnull)redirectUrl clientId:(NSString * _Nonnull)clientId isScan:(BOOL)isScan callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)bindDeviceWithDeviceData:(NSDictionary * _Nullable)deviceData callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)unbindDeviceWithCallBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)getBindDeviceListWithCallBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)getDialogRecordWithProductId:(NSString * _Nonnull)productId seqId:(NSString * _Nullable)seqId count:(NSInteger)count callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)sendAuthCodeWithDeviceId:(NSString * _Nonnull)deviceId authCode:(NSString * _Nonnull)authCode isScan:(BOOL)isScan callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getQueryDeviceStatusWithUid:(NSString * _Nonnull)uid callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getDeviceCurrentStateWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getDeviceBasicInfoWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, EquipDeviceInfoModel * _Nullable))callBack;
- (void)getAlarmListWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<EquipAlarmModel *> * _Nullable))callBack;
- (void)addAlarmWithAlarmDate:(NSString * _Nonnull)alarmDate alarmTime:(NSString * _Nonnull)alarmTime repeatStr:(NSString * _Nonnull)repeatStr callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)deleteAlarmWithAlarmIds:(NSArray * _Nonnull)alarmIds callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getRemindListWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<EquipRemindModel *> * _Nullable))callBack;
- (void)addRemindWithRemindDate:(NSString * _Nonnull)remindDate remindTime:(NSString * _Nonnull)remindTime event:(NSString * _Nonnull)event repeatStr:(NSString * _Nonnull)repeatStr callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)deleteRemindWithRemindIds:(NSArray * _Nonnull)remindIds callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)setBleActivatedWithModel:(BOOL)model callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)setWakeUpFunctionWithState:(NSInteger)state callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getchatAndMsgUnReadCountWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSInteger))callBack;
- (void)getMessagesWithPage:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<EquipVoiceMessageModel *> * _Nullable))callBack;
- (void)sendVoiceMessageWithData:(NSData * _Nonnull)data callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)getUnReadMessageCountWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)readVoiceMessageWithChatId:(NSString * _Nonnull)chatId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)addCallRecordWithSrcId:(NSString * _Nonnull)srcId targetId:(NSString * _Nonnull)targetId state:(NSInteger)state talkTime:(NSString * _Nonnull)talkTime type:(NSString * _Nonnull)type callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getCallRecordListWithAccId:(NSString * _Nonnull)accId page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<EquCallRecordListModel *> * _Nullable))callBack;
- (void)getGroupChatsWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<FamilyGroupChatListModel *> * _Nullable))callBack;
- (void)createGroupChatWithGroupName:(NSString * _Nonnull)groupName userIds:(NSArray * _Nonnull)userIds callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getGroupChatMessagesWithChatId:(NSString * _Nonnull)chatId page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray * _Nonnull, NSArray<FGCDetailListModel *> * _Nullable))callBack;
- (void)sendGroupChatMessageWithChatId:(NSString * _Nonnull)chatId data:(NSData * _Nonnull)data callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)readGroupChatMessageWithChatId:(NSString * _Nonnull)chatId recordId:(NSString * _Nonnull)recordId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)addSceneWithProductId:(NSString * _Nonnull)productId quickCreateRequest:(QuickCreateRequest * _Nonnull)quickCreateRequest callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)deleteSceneWithProductId:(NSString * _Nonnull)productId sceneId:(NSString * _Nonnull)sceneId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)updateSceneWithProductId:(NSString * _Nonnull)productId sceneId:(NSString * _Nonnull)sceneId quickCreateRequest:(QuickCreateRequest * _Nonnull)quickCreateRequest callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getSceneWithProductId:(NSString * _Nonnull)productId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSArray<InstructionModel *> * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@protocol DCAManagerDelegate;
@class DCAUserManager;
@class DCAMediaResourceManager;
@class DCASmartHomeManager;
@class DCASkillManager;
@class DCASonicNetManager;
@class DCAVoiceCopyManager;
SWIFT_CLASS("_TtC11iOS_DCA_SDK10DCAManager")
@interface DCAManager : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) DCAManager * _Nonnull shared;)
+ (DCAManager * _Nonnull)shared SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, weak) id <DCAManagerDelegate> _Nullable delegate;
@property (nonatomic, copy) NSString * _Nonnull deviceId;
@property (nonatomic, strong) DCAAccountManager * _Nonnull accountManager;
@property (nonatomic, strong) DCAAppManager * _Nonnull appManager;
@property (nonatomic, strong) DCAUserManager * _Nonnull userManager;
@property (nonatomic, strong) DCAMediaResourceManager * _Nonnull mediaResourceManager;
@property (nonatomic, strong) DCADeviceManager * _Nonnull deviceManager;
@property (nonatomic, strong) DCASmartHomeManager * _Nonnull smartHomeManager;
@property (nonatomic, strong) DCASkillManager * _Nonnull skillManager;
@property (nonatomic, strong) DCADeviceControlManager * _Nonnull deviceControlManager;
@property (nonatomic, strong) DCABleNetManager * _Nonnull bleNetManager;
@property (nonatomic, strong) DCASonicNetManager * _Nonnull sonicNetManager;
@property (nonatomic, strong) DCAAPNetManager * _Nonnull apNetManager;
@property (nonatomic, strong) DCAVoiceCopyManager * _Nonnull voiceCopyManager;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
enum EvnType : NSInteger;
@interface DCAManager (SWIFT_EXTENSION(iOS_DCA_SDK))
- (void)setEnvWithEvn:(enum EvnType)evn;
- (void)sdkPrintLogWithIsPrint:(BOOL)isPrint;
- (void)initializeWithApiKey:(NSString * _Nonnull)apiKey apiSecret:(NSString * _Nonnull)apiSecret;
- (NSString * _Nonnull)getSDKVersion SWIFT_WARN_UNUSED_RESULT;
@end
SWIFT_PROTOCOL("_TtP11iOS_DCA_SDK18DCAManagerDelegate_")
@protocol DCAManagerDelegate <NSObject>
@optional
- (void)onNeedLogin;
@end
@class TVShowModel;
@class TVBatchListModel;
@class TVDetailModel;
@class PBRecommendTypeModel;
@class PBRecommendListModel;
@class PBRecommendDetailModel;
@class PBReadRecordModel;
@class PBReadRecordDetailModel;
enum ResCommType : NSInteger;
@class ResAlbumModel;
@class ResMusicModel;
@class ResNewsCateListModel;
@class ResNewsListModel;
@class ResRadioCateListModel;
@class ResRadioListModel;
@class LetingCateModel;
@class GetVideoRequest;
@class LetingVideoModel;
@class SearchVideoRequest;
@class FeedBack;
@class ResIdaddyCatesModel;
@class IDaddyAlbumRequest;
@class IDaddyTrackRequest;
@class IDaddySearchAlbumRequest;
@class IDaddySearchTrackRequest;
SWIFT_CLASS("_TtC11iOS_DCA_SDK23DCAMediaResourceManager")
@interface DCAMediaResourceManager : NSObject
- (void)getBatchListWithType:(NSString * _Nonnull)type page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ChildBatchListModel *> * _Nullable))callBack;
- (void)getBatchDetailWithType:(NSString * _Nonnull)type moduleID:(NSString * _Nonnull)moduleID page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<ChildBatchDetailModel *> * _Nullable))callBack;
- (void)getAlbumBrowseWithBatchModel:(ChildBatchListModel * _Nonnull)batchModel albumModel:(ChildBatchDetailModel * _Nonnull)albumModel page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<ChildAlbumBrowseModel *> * _Nullable))callBack;
- (void)getSearchDataWithQ:(NSString * _Nonnull)q page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<ChildAlbumBrowseModel *> * _Nullable))callBack;
- (void)getTVShowListWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<TVShowModel *> * _Nullable))callBack;
- (void)getTVBatchListWithType:(NSString * _Nonnull)type callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<TVBatchListModel *> * _Nullable))callBack;
- (void)getTVBatchDetailWithTag:(NSString * _Nonnull)tag type:(NSString * _Nonnull)type page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<TVDetailModel *> * _Nullable))callBack;
- (void)getCompleteSystemRecommendWithAge:(NSString * _Nonnull)age callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<PBRecommendTypeModel *> * _Nullable))callBack;
- (void)getRecommendDetailedWithRecommendId:(NSString * _Nonnull)recommendId type:(NSInteger)type callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<PBRecommendListModel *> * _Nullable))callBack;
- (void)getMiniProgramBookInfoWithRecommendId:(NSString * _Nonnull)recommendId picBookId:(NSString * _Nonnull)picBookId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, PBRecommendDetailModel * _Nullable))callBack;
- (void)getUserReadRcordWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, PBReadRecordModel * _Nullable))callBack;
- (void)getUserReadDetailWithDateStr:(NSString * _Nonnull)dateStr callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, PBReadRecordDetailModel * _Nullable))callBack;
- (void)savePicBookReadRecordWithModel:(PBRecommendListModel * _Nonnull)model beginTimeStr:(NSString * _Nonnull)beginTimeStr endTimeStr:(NSString * _Nonnull)endTimeStr pageTimeList:(NSArray * _Nonnull)pageTimeList callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)getCommResAlbumsWithType:(enum ResCommType)type page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResAlbumModel *> * _Nullable))callBack;
- (void)getCommResTracksWithType:(enum ResCommType)type albumId:(NSString * _Nonnull)albumId page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResMusicModel *> * _Nullable))callBack;
- (void)getNewsCategoryWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResNewsCateListModel *> * _Nullable))callBack;
- (void)getNewsWithCatId:(NSString * _Nonnull)catId pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResNewsListModel *> * _Nullable))callBack;
- (void)getRadioCategoryWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResRadioCateListModel *> * _Nullable))callBack;
- (void)getRadioWithCatId:(NSString * _Nonnull)catId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResRadioListModel *> * _Nullable))callBack;
- (void)searchAlbumsWithTitle:(NSString * _Nonnull)title page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResAlbumModel *> * _Nullable))callBack;
- (void)getTracksBySearchAlbumIdWithAlbumId:(NSString * _Nonnull)albumId page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResMusicModel *> * _Nullable))callBack;
- (void)searchTracksWithTitle:(NSString * _Nonnull)title page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResMusicModel *> * _Nullable))callBack;
- (void)searchStoryWithTitle:(NSString * _Nonnull)title tags:(NSString * _Nonnull)tags page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResMusicModel *> * _Nullable))callBack;
- (void)getLetingCatalogsWithUid:(NSString * _Nonnull)uid productId:(NSString * _Nonnull)productId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<LetingCateModel *> * _Nullable))callBack;
- (void)getLetingVideoByCatalogIdWithRequest:(GetVideoRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<LetingVideoModel *> * _Nullable))callBack;
- (void)searchLetingVideoWithRequest:(SearchVideoRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<LetingVideoModel *> * _Nullable))callBack;
- (void)letingFeedbackWithUid:(NSString * _Nonnull)uid productId:(NSString * _Nonnull)productId feedback:(FeedBack * _Nonnull)feedback callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getIDaddyCategoryWithProductId:(NSString * _Nonnull)productId deviceId:(NSString * _Nonnull)deviceId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResIdaddyCatesModel *> * _Nullable))callBack;
- (void)getIDaddyAlbumWithAlbumRequest:(IDaddyAlbumRequest * _Nonnull)albumRequest callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResAlbumModel *> * _Nullable))callBack;
- (void)getIDaddyTrackWithTrackRequest:(IDaddyTrackRequest * _Nonnull)trackRequest callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResMusicModel *> * _Nullable))callBack;
- (void)searchIDaddyAlbumWithSearchRequest:(IDaddySearchAlbumRequest * _Nonnull)searchRequest callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResAlbumModel *> * _Nullable))callBack;
- (void)searchIDaddyTrackWithSearchRequest:(IDaddySearchTrackRequest * _Nonnull)searchRequest callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResMusicModel *> * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, DCASDKEBTYPE, open) {
  DCASDKEBTYPESMARTHOME = 0,
  DCASDKEBTYPESMARTHOME_DEVICE_LIST = 1,
  DCASDKEBTYPEDIALOG_MESSGAE = 2,
  DCASDKEBTYPESKILL_CENTER = 3,
  DCASDKEBTYPEPRODUCT_SKILL = 4,
  DCASDKEBTYPESEARCH_SKILL = 5,
  DCASDKEBTYPECOMMON_PAGE = 6,
  DCASDKEBTYPESKILL_INSTALL = 7,
  DCASDKEBTYPECUSTOME_DIALOG = 8,
  DCASDKEBTYPECUSTOME_DIALOGCREATE = 9,
  DCASDKEBTYPESKILL_STORE = 10,
};
@class DCAWebViewInfo;
@protocol DCASDKWebViewControllerDelegate;
@class NSBundle;
SWIFT_CLASS("_TtC11iOS_DCA_SDK23DCASDKWebViewController")
@interface DCASDKWebViewController : UIViewController
@property (nonatomic, strong) DCAWebViewInfo * _Nullable webInfo;
@property (nonatomic, weak) id <DCASDKWebViewControllerDelegate> _Nullable delegate;
- (void)viewDidLoad;
- (void)observeValueForKeyPath:(NSString * _Nullable)keyPath ofObject:(id _Nullable)object change:(NSDictionary<NSKeyValueChangeKey, id> * _Nullable)change context:(void * _Nullable)context;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end
@class WKUserContentController;
@class WKScriptMessage;
@interface DCASDKWebViewController (SWIFT_EXTENSION(iOS_DCA_SDK)) <WKScriptMessageHandler>
- (void)userContentController:(WKUserContentController * _Nonnull)userContentController didReceiveScriptMessage:(WKScriptMessage * _Nonnull)message;
@end
@class WKWebView;
@class WKNavigationAction;
@class WKNavigation;
@interface DCASDKWebViewController (SWIFT_EXTENSION(iOS_DCA_SDK)) <UIWebViewDelegate, WKNavigationDelegate>
- (void)webView:(WKWebView * _Nonnull)webView decidePolicyForNavigationAction:(WKNavigationAction * _Nonnull)navigationAction decisionHandler:(void (^ _Nonnull)(WKNavigationActionPolicy))decisionHandler;
- (void)webView:(WKWebView * _Nonnull)webView didStartProvisionalNavigation:(WKNavigation * _Null_unspecified)navigation;
- (void)webView:(WKWebView * _Nonnull)webView didFinishNavigation:(WKNavigation * _Null_unspecified)navigation;
- (void)webView:(WKWebView * _Nonnull)webView didFailNavigation:(WKNavigation * _Null_unspecified)navigation withError:(NSError * _Nonnull)error;
@end
@interface DCASDKWebViewController (SWIFT_EXTENSION(iOS_DCA_SDK))
- (void)loadH5;
- (void)loadH5WithUrlWithUrlStr:(NSString * _Nonnull)urlStr;
- (void)setAccessTokenWithToken:(NSString * _Nonnull)token;
- (void)registerThemeWithTheme:(NSString * _Nonnull)theme;
- (BOOL)webViewCanGoBack SWIFT_WARN_UNUSED_RESULT;
- (void)webViewBack;
- (void)setWebViewFrameWithFrame:(CGRect)frame;
@end
SWIFT_PROTOCOL("_TtP11iOS_DCA_SDK31DCASDKWebViewControllerDelegate_")
@protocol DCASDKWebViewControllerDelegate <NSObject>
@optional
- (void)quitDCASDKWebViewViewController;
- (void)onTitleChangeWithTitle:(NSString * _Nonnull)title;
- (void)webViewHasDeviceWithParam:(BOOL)param;
- (void)webViewOpenNewTabWithParam:(NSString * _Nonnull)param;
@end
@class SkillDetailRequest;
SWIFT_CLASS("_TtC11iOS_DCA_SDK15DCASkillManager")
@interface DCASkillManager : NSObject
- (void)querySkillListByProductVersionWithProductId:(NSString * _Nonnull)productId productVersion:(NSString * _Nonnull)productVersion callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)querySkillListByAliasKeyWithProductId:(NSString * _Nonnull)productId aliasKey:(NSString * _Nonnull)aliasKey callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)querySkillDetailWithSkillId:(NSString * _Nonnull)skillId skillVersion:(NSString * _Nonnull)skillVersion callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)querySkillDetailsWithList:(NSArray<SkillDetailRequest *> * _Nonnull)list callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class SmartHomeTokenRequest;
@class SkillRequest;
SWIFT_CLASS("_TtC11iOS_DCA_SDK19DCASmartHomeManager")
@interface DCASmartHomeManager : NSObject
- (void)querySmartHomeSkillWithCallBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)querySmartHomeAccountStatusWithSkillId:(NSString * _Nonnull)skillId skillVersion:(NSString * _Nonnull)skillVersion productId:(NSString * _Nonnull)productId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)querySmartHomeApplianceWithSkillId:(NSString * _Nonnull)skillId skillVersion:(NSString * _Nonnull)skillVersion productId:(NSString * _Nonnull)productId group:(NSString * _Nonnull)group callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)queryAllSmartHomeApplianceWithProductId:(NSString * _Nonnull)productId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)queryAppliancePositionWithApplianceId:(NSString * _Nonnull)applianceId skillId:(NSString * _Nonnull)skillId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)updateApplianceCustomPositionWithApplianceId:(NSString * _Nonnull)applianceId skillId:(NSString * _Nonnull)skillId productId:(NSString * _Nonnull)productId position:(NSString * _Nonnull)position group:(NSString * _Nonnull)group callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)updateApplianceAliasWithApplianceId:(NSString * _Nonnull)applianceId skillId:(NSString * _Nonnull)skillId productId:(NSString * _Nonnull)productId alias:(NSString * _Nonnull)alias group:(NSString * _Nonnull)group callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)applianceAliasSyncWithProductId:(NSString * _Nonnull)productId group:(NSString * _Nonnull)group iotSkillId:(NSString * _Nonnull)iotSkillId skillList:(NSArray<ApplianceAliasSyncModel *> * _Nullable)skillList callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)updateSmartHomeTokenInfoWithSmartHomeTokenRequest:(SmartHomeTokenRequest * _Nonnull)smartHomeTokenRequest callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)bindSmartHomeAccountWithUrl:(NSString * _Nonnull)url productId:(NSString * _Nonnull)productId skillVersion:(NSString * _Nonnull)skillVersion callBack:(void (^ _Nonnull)(BOOL))callBack;
- (void)unbindSmartHomeAccountWithSkillId:(NSString * _Nonnull)skillId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)getSmartHomeDetailWithSkillId:(NSString * _Nonnull)skillId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)getSupportDeviceWithSkillId:(NSString * _Nonnull)skillId page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)batchQuerySmartHomeAccountStatusWithProductId:(NSString * _Nonnull)productId list:(NSArray<SkillRequest *> * _Nonnull)list callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)batchQueryAppliancePositionWithProductId:(NSString * _Nonnull)productId list:(NSArray<BatchPosRequest *> * _Nonnull)list callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
enum SonicNetworkState : NSInteger;
SWIFT_CLASS("_TtC11iOS_DCA_SDK18DCASonicNetManager")
@interface DCASonicNetManager : NSObject
- (void)initSonicNetwork SWIFT_METHOD_FAMILY(none);
- (void)startSonicNetworkWithWifiStr:(NSString * _Nonnull)wifiStr pwd:(NSString * _Nonnull)pwd sonicNetResult:(void (^ _Nullable)(enum SonicNetworkState, NSString * _Nonnull, NSDictionary * _Nonnull))sonicNetResult;
- (void)stopSonicNetwork;
- (void)deallocSonicNetwork;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class UserInfoModel;
enum GENDER : NSInteger;
@class FamilyAddressBookListModel;
@class EquipDeviceListModel;
@class QaInitModel;
@class QaInfoModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK14DCAUserManager")
@interface DCAUserManager : NSObject
- (void)getUserInfoWithUserId:(NSString * _Nonnull)userId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, UserInfoModel * _Nullable))callBack;
- (void)registerFirstWithNickname:(NSString * _Nonnull)nickname phone:(NSString * _Nonnull)phone gender:(enum GENDER)gender headUrl:(NSString * _Nonnull)headUrl callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, UserInfoModel * _Nullable))callBack;
- (void)setHeadImgWithData:(NSData * _Nonnull)data callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)setNicknameWithNickname:(NSString * _Nonnull)nickname callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)setGenderWithGender:(enum GENDER)gender callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getBabyDataWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, BabyDataModel * _Nullable))callBack;
- (void)saveBabyDataWithBorn:(NSString * _Nonnull)born relation:(NSString * _Nonnull)relation gender:(enum GENDER)gender babyInfoId:(NSString * _Nonnull)babyInfoId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)addModelInCollectionWithModel:(ChildAlbumBrowseModel * _Nonnull)model callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)deleteModelInCollectionWithModel:(ChildAlbumBrowseModel * _Nonnull)model callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getCollectionListWithPage:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<ChildAlbumBrowseModel *> * _Nullable))callBack;
- (void)getContactsWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<FamilyAddressBookListModel *> * _Nullable))callBack;
- (void)addContactWithNickname:(NSString * _Nonnull)nickname relation:(NSString * _Nonnull)relation phone:(NSString * _Nonnull)phone callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)getUserQRCodeWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)addQRContactWithNickname:(NSString * _Nonnull)nickname relation:(NSString * _Nonnull)relation userId:(NSString * _Nonnull)userId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)getNewFriendsWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<FamilyAddressBookListModel *> * _Nullable))callBack;
- (void)agreeContactRequestWithModel:(FamilyAddressBookListModel * _Nonnull)model callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)editContactWithNickname:(NSString * _Nonnull)nickname relation:(NSString * _Nonnull)relation editId:(NSString * _Nonnull)editId fbId:(NSString * _Nonnull)fbId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)deleteContactWithFbId:(NSString * _Nonnull)fbId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)getFriendDeviceListWithUserID:(NSString * _Nonnull)userID callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<EquipDeviceListModel *> * _Nullable))callBack;
- (void)initQaWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, QaInitModel * _Nullable))callBack SWIFT_METHOD_FAMILY(none);
- (void)queryQaInfoWithQaInitModel:(QaInitModel * _Nonnull)qaInitModel callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<QaInfoModel *> * _Nullable))callBack;
- (void)queryQaInfoDetailWithKid:(NSString * _Nonnull)kid callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, QaInfoModel * _Nullable))callBack;
- (void)addQaInfoWithQaInitModel:(QaInitModel * _Nonnull)qaInitModel questionNameArr:(NSArray * _Nonnull)questionNameArr answerNameArr:(NSArray * _Nonnull)answerNameArr callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, QaInfoModel * _Nullable))callBack;
- (void)deleteQaInfoWithKid:(NSString * _Nonnull)kid callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)updateQaInfoWithQaInfoModel:(QaInfoModel * _Nonnull)qaInfoModel callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, QaInfoModel * _Nullable))callBack;
- (void)effectiveQaOperationWithQaInitModel:(QaInitModel * _Nonnull)qaInitModel callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class VoiceCopyTextModel;
@class UploadRequestModel;
@class TrainRequestModel;
@class DeleteRequestModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK19DCAVoiceCopyManager")
@interface DCAVoiceCopyManager : NSObject
- (void)getTextWithProductId:(NSString * _Nonnull)productId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<VoiceCopyTextModel *> * _Nullable))callBack;
- (void)uploadWithRequest:(UploadRequestModel * _Nonnull)request callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)trainingWithRequest:(TrainRequestModel * _Nonnull)request callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)queryTaskWithProductId:(NSString * _Nonnull)productId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)deleteToneWithRequest:(DeleteRequestModel * _Nonnull)request callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)updateCustomInfoWithProductId:(NSString * _Nonnull)productId taskId:(NSString * _Nonnull)taskId customInfo:(NSString * _Nonnull)customInfo callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class UIColor;
SWIFT_CLASS("_TtC11iOS_DCA_SDK14DCAWebViewInfo")
@interface DCAWebViewInfo : NSObject
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSString * _Nullable productVersion;
@property (nonatomic) enum DCASDKEBTYPE webType;
@property (nonatomic, copy) NSString * _Nullable aliasKey;
@property (nonatomic, copy) NSString * _Nullable manufacture;
@property (nonatomic) BOOL isHiddenTitle;
@property (nonatomic) BOOL isUseCustomWebViewFrame;
@property (nonatomic) CGRect webViewFrame;
@property (nonatomic, copy) NSString * _Nullable searchContent;
@property (nonatomic, copy) NSString * _Nullable urlContent;
@property (nonatomic, copy) NSString * _Nullable theme;
@property (nonatomic, strong) UIColor * _Nullable themeColor;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18DeleteRequestModel")
@interface DeleteRequestModel : NSObject
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable taskId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22DeviceConfigScopeModel")
@interface DeviceConfigScopeModel : NSObject
@property (nonatomic) NSInteger bind_ble;
@property (nonatomic) NSInteger bind_sound;
@property (nonatomic) NSInteger bind_wifiap;
@property (nonatomic) NSInteger bind_scan;
@property (nonatomic) NSInteger res_children;
@property (nonatomic) NSInteger res_fm;
@property (nonatomic) NSInteger res_book;
@property (nonatomic) NSInteger res_shows;
@property (nonatomic) NSInteger res_tv_play;
@property (nonatomic) NSInteger res_movie;
@property (nonatomic) NSInteger setting_wifi_rest;
@property (nonatomic) NSInteger setting_ble;
@property (nonatomic) NSInteger setting_sound;
@property (nonatomic) NSInteger setting_dev_name;
@property (nonatomic) NSInteger setting_unbind;
@property (nonatomic) NSInteger setting_reset;
@property (nonatomic) NSInteger setting_reconnect;
@property (nonatomic) NSInteger dev_talklog;
@property (nonatomic) NSInteger dev_im;
@property (nonatomic) NSInteger dev_contact_video;
@property (nonatomic) NSInteger dev_contact_voice;
@property (nonatomic) NSInteger dev_contact_chat;
@property (nonatomic) NSInteger dev_family_list;
@property (nonatomic) NSInteger dev_custom_qa;
@property (nonatomic) NSInteger dev_custom_command;
@property (nonatomic) NSInteger dev_remind;
@property (nonatomic) NSInteger dev_clock;
@property (nonatomic) NSInteger device_info;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15DeviceInfoModel")
@interface DeviceInfoModel : NSObject
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable appId;
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic, copy) NSString * _Nullable platform;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK24DeviceProductConfigModel")
@interface DeviceProductConfigModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable subtitle;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, strong) DeviceConfigScopeModel * _Nullable scope;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22EquCallRecordListModel")
@interface EquCallRecordListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable recordId;
@property (nonatomic, copy) NSString * _Nullable srcId;
@property (nonatomic, copy) NSString * _Nullable targetId;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic) NSInteger talkTime;
@property (nonatomic) NSInteger state;
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic) BOOL isRead;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class OdmConfigModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK23EquSmartDeviceListModel")
@interface EquSmartDeviceListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable productType;
@property (nonatomic, copy) NSString * _Nullable productTypeCode;
@property (nonatomic, copy) NSString * _Nullable image;
@property (nonatomic, copy) NSString * _Nullable deviceName;
@property (nonatomic, copy) NSString * _Nullable appId;
@property (nonatomic, copy) NSString * _Nullable secret;
@property (nonatomic, copy) NSString * _Nullable company;
@property (nonatomic) NSInteger hide;
@property (nonatomic, strong) DeviceProductConfigModel * _Nullable config;
@property (nonatomic, strong) OdmConfigModel * _Nullable odmConfig;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15EquipAlarmModel")
@interface EquipAlarmModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable alarmId;
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSString * _Nullable date;
@property (nonatomic, copy) NSString * _Nullable time;
@property (nonatomic, copy) NSString * _Nullable timestamp;
@property (nonatomic, copy) NSString * _Nullable event;
@property (nonatomic, copy) NSString * _Nullable repeatS;
@property (nonatomic) BOOL isSelected;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20EquipDeviceInfoModel")
@interface EquipDeviceInfoModel : NSObject <NSCoding, YYModel>
@property (nonatomic) float volume;
@property (nonatomic) BOOL bluetooth;
@property (nonatomic) BOOL hasBattery;
@property (nonatomic) BOOL wifiState;
@property (nonatomic, copy) NSString * _Nullable wifiSsid;
@property (nonatomic) NSInteger battery;
@property (nonatomic) NSInteger playlistCount;
@property (nonatomic, copy) NSString * _Nullable version;
@property (nonatomic) NSInteger wakeUp;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20EquipDeviceListModel")
@interface EquipDeviceListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable deviceType;
@property (nonatomic, copy) NSString * _Nullable deviceAlias;
@property (nonatomic, copy) NSString * _Nullable deviceName;
@property (nonatomic, strong) DeviceInfoModel * _Nullable deviceInfo;
@property (nonatomic, copy) NSString * _Nullable apiKey;
@property (nonatomic) BOOL isDefault;
@property (nonatomic, copy) NSString * _Nullable accId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16EquipRemindModel")
@interface EquipRemindModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic, copy) NSString * _Nullable date;
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSString * _Nullable event;
@property (nonatomic, copy) NSString * _Nullable remindId;
@property (nonatomic, copy) NSString * _Nullable object;
@property (nonatomic, copy) NSString * _Nullable repeatS;
@property (nonatomic, copy) NSString * _Nullable time;
@property (nonatomic, copy) NSString * _Nullable timestamp;
@property (nonatomic, copy) NSString * _Nullable vid;
@property (nonatomic) BOOL isSelected;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22EquipVoiceMessageModel")
@interface EquipVoiceMessageModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger voiceId;
@property (nonatomic, copy) NSString * _Nullable senderId;
@property (nonatomic, copy) NSString * _Nullable senderAvatarUrl;
@property (nonatomic, copy) NSString * _Nullable senderName;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable text;
@property (nonatomic, copy) NSString * _Nullable voiceUrl;
@property (nonatomic) NSInteger duration;
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic) NSInteger readed;
@property (nonatomic, copy) NSString * _Nullable content;
@property (nonatomic) NSInteger groupType;
@property (nonatomic) BOOL isPlayAnimation;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
typedef SWIFT_ENUM(NSInteger, EvnType, open) {
  EvnTypeDEV = 1,
  EvnTypeTEST = 2,
  EvnTypeBETA = 3,
  EvnTypeDUI = 4,
};
@class FBExt;
SWIFT_CLASS("_TtC11iOS_DCA_SDK6FBData")
@interface FBData : NSObject
@property (nonatomic, copy) NSString * _Nonnull sid;
@property (nonatomic, copy) NSString * _Nonnull category;
@property (nonatomic) NSInteger duration;
@property (nonatomic, strong) NSDictionary * _Nonnull ext;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (NSDictionary * _Nonnull)initializWithRExt:(FBExt * _Nullable)rExt SWIFT_WARN_UNUSED_RESULT;
- (NSDictionary * _Nonnull)getDataDic SWIFT_WARN_UNUSED_RESULT;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK5FBExt")
@interface FBExt : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable district;
@property (nonatomic, copy) NSString * _Nullable city;
@property (nonatomic, copy) NSString * _Nullable province;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18FGCDetailListModel")
@interface FGCDetailListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable voiceUrl;
@property (nonatomic, copy) NSString * _Nullable targetId;
@property (nonatomic) NSInteger fgcId;
@property (nonatomic, copy) NSString * _Nullable srcId;
@property (nonatomic) NSInteger duration;
@property (nonatomic) NSInteger groupId;
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic) NSInteger groupTalk;
@property (nonatomic, strong) UserInfoModel * _Nullable srcUser;
@property (nonatomic) BOOL isPlayAnimation;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK26FamilyAddressBookListModel")
@interface FamilyAddressBookListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic, copy) NSString * _Nullable ownerId;
@property (nonatomic, copy) NSString * _Nullable relation;
@property (nonatomic, copy) NSString * _Nullable fbId;
@property (nonatomic, copy) NSString * _Nullable nickname;
@property (nonatomic, copy) NSString * _Nullable state;
@property (nonatomic, copy) NSString * _Nullable phone;
@property (nonatomic, copy) NSString * _Nullable head;
@property (nonatomic) BOOL isSelected;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK24FamilyGroupChatListModel")
@interface FamilyGroupChatListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic) NSInteger chatId;
@property (nonatomic, copy) NSString * _Nullable ownerId;
@property (nonatomic) NSInteger number;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK27FamilyRelationshipListModel")
@interface FamilyRelationshipListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable frId;
@property (nonatomic, copy) NSString * _Nullable name;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK8FeedBack")
@interface FeedBack : NSObject
@property (nonatomic, copy) NSString * _Nonnull action_type;
@property (nonatomic, copy) NSString * _Nonnull timestamp;
@property (nonatomic, copy) NSString * _Nonnull imei;
@property (nonatomic, copy) NSString * _Nonnull os;
@property (nonatomic, copy) NSString * _Nonnull client_ip;
@property (nonatomic, copy) NSString * _Nonnull brand;
@property (nonatomic, copy) NSString * _Nonnull clarity;
@property (nonatomic, copy) NSString * _Nonnull log_id;
@property (nonatomic, strong) NSArray * _Nullable data;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, GENDER, open) {
  GENDERMALE = 1,
  GENDERFAMALE = 2,
  GENDERUNKNOWN = 3,
};
enum SMSCODETYPE : NSInteger;
SWIFT_CLASS("_TtC11iOS_DCA_SDK19GetCodeRequestModel")
@interface GetCodeRequestModel : NSObject
@property (nonatomic, copy) NSString * _Nullable userName;
@property (nonatomic) enum SMSCODETYPE type;
@property (nonatomic, copy) NSString * _Nonnull channel;
@property (nonatomic, copy) NSString * _Nonnull signName;
@property (nonatomic, copy) NSString * _Nonnull templateCode;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15GetVideoRequest")
@interface GetVideoRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull catalogId;
@property (nonatomic, copy) NSString * _Nonnull uid;
@property (nonatomic, copy) NSString * _Nonnull productId;
@property (nonatomic, copy) NSString * _Nonnull province;
@property (nonatomic, copy) NSString * _Nonnull city;
@property (nonatomic, copy) NSString * _Nonnull keyword;
@property (nonatomic) NSInteger distinct;
@property (nonatomic) NSInteger size;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK14HiFiAlbumModel")
@interface HiFiAlbumModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable cn_name;
@property (nonatomic, copy) NSString * _Nullable smallimg;
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic, copy) NSString * _Nullable artist;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable recordingTime;
@property (nonatomic, copy) NSString * _Nullable musicListId;
@property (nonatomic, copy) NSString * _Nullable introduce;
@property (nonatomic, copy) NSString * _Nullable smallImg;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16HiFiHotListModel")
@interface HiFiHotListModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable bigimg;
@property (nonatomic, copy) NSString * _Nullable smallimg;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic) NSInteger trackstotal;
@property (nonatomic, copy) NSString * _Nullable packId;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18HiFiMenuAlbumModel")
@interface HiFiMenuAlbumModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable imgurl;
@property (nonatomic, copy) NSString * _Nullable artistname;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic, copy) NSString * _Nullable cn_name;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK24HiFiMenuTypeContentModel")
@interface HiFiMenuTypeContentModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable imgurl;
@property (nonatomic, copy) NSString * _Nullable artistname;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable albumId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK17HiFiMenuTypeModel")
@interface HiFiMenuTypeModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable menuid;
@property (nonatomic, copy) NSString * _Nullable menuname;
@property (nonatomic, copy) NSString * _Nullable image;
@property (nonatomic, copy) NSArray<HiFiMenuTypeContentModel *> * _Nullable menuContent;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class HiFiSliderContentModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK14HiFiMenusModel")
@interface HiFiMenusModel : HiFiBaseModel
@property (nonatomic) NSInteger tagid;
@property (nonatomic, copy) NSString * _Nullable sliderid;
@property (nonatomic, copy) NSString * _Nullable menuid;
@property (nonatomic) NSInteger displayorder;
@property (nonatomic) NSInteger hasmore;
@property (nonatomic, copy) NSString * _Nullable pattern;
@property (nonatomic) NSInteger isnew;
@property (nonatomic, copy) NSString * _Nullable menutype;
@property (nonatomic, copy) NSString * _Nullable menuname;
@property (nonatomic, copy) NSString * _Nullable moretype;
@property (nonatomic, copy) NSArray<HiFiSliderContentModel *> * _Nullable sliderContent;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class HiFiMusicModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK17HiFiMusicArrModel")
@interface HiFiMusicArrModel : HiFiBaseModel
@property (nonatomic, copy) NSArray<HiFiMusicModel *> * _Nullable musics;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20HiFiMusicDetailModel")
@interface HiFiMusicDetailModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable introduction;
@property (nonatomic, copy) NSString * _Nullable companyname;
@property (nonatomic, copy) NSString * _Nullable productid;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable publishtime;
@property (nonatomic, copy) NSString * _Nullable bigimg;
@property (nonatomic, copy) NSString * _Nullable sliderid;
@property (nonatomic, copy) NSString * _Nullable size;
@property (nonatomic, copy) NSString * _Nullable cn_name;
@property (nonatomic) NSInteger musiccount;
@property (nonatomic, copy) NSString * _Nullable smallimg;
@property (nonatomic) NSInteger prize;
@property (nonatomic, copy) NSString * _Nullable reference;
@property (nonatomic, copy) NSString * _Nullable technology;
@property (nonatomic) NSInteger isfullflac;
@property (nonatomic, copy) NSString * _Nullable musicId;
@property (nonatomic, copy) NSString * _Nullable language;
@property (nonatomic, copy) NSString * _Nullable artists;
@property (nonatomic, copy) NSArray<HiFiMusicArrModel *> * _Nullable disks;
@property (nonatomic, copy) NSArray<HiFiMusicModel *> * _Nullable musicListItems;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK14HiFiMusicModel")
@interface HiFiMusicModel : HiFiBaseModel
@property (nonatomic) NSInteger price;
@property (nonatomic, copy) NSString * _Nullable productid;
@property (nonatomic, copy) NSString * _Nullable albumid;
@property (nonatomic, copy) NSString * _Nullable artistid;
@property (nonatomic, copy) NSString * _Nullable musicId;
@property (nonatomic, copy) NSString * _Nullable artist;
@property (nonatomic, copy) NSString * _Nullable totaltime;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic) NSInteger trackno;
@property (nonatomic, copy) NSString * _Nullable albumimg;
@property (nonatomic, copy) NSString * _Nullable albumname;
@property (nonatomic, copy) NSArray<AudioFileListModel *> * _Nullable audioFileList;
@property (nonatomic, copy) NSString * _Nullable listenurl;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22HiFiSearchContentModel")
@interface HiFiSearchContentModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable Imgurl;
@property (nonatomic, copy) NSString * _Nullable albumname;
@property (nonatomic, copy) NSString * _Nullable artistname;
@property (nonatomic, copy) NSString * _Nullable contentid;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic) NSInteger type;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15HiFiSearchModel")
@interface HiFiSearchModel : NSObject
@property (nonatomic, copy) NSString * _Nullable Imgurl;
@property (nonatomic, copy) NSString * _Nullable albumname;
@property (nonatomic, copy) NSString * _Nullable artistname;
@property (nonatomic, copy) NSString * _Nullable contentid;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic) NSInteger type;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, HiFiSearchType, open) {
  HiFiSearchTypeALL = 0,
  HiFiSearchTypeALBUM = 1,
  HiFiSearchTypeSONG = 5,
  HiFiSearchTypeARTIST = 10,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK22HiFiSliderContentModel")
@interface HiFiSliderContentModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable contentTitle;
@property (nonatomic, copy) NSString * _Nullable albumName;
@property (nonatomic, copy) NSString * _Nullable ImgUrl;
@property (nonatomic) NSInteger displayOrder;
@property (nonatomic, copy) NSString * _Nullable artistName;
@property (nonatomic, copy) NSString * _Nullable linkUrl;
@property (nonatomic, copy) NSString * _Nullable contentId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18IDaddyAlbumRequest")
@interface IDaddyAlbumRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull deviceId;
@property (nonatomic, copy) NSString * _Nonnull productId;
@property (nonatomic, copy) NSString * _Nonnull categoryId;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger limit;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK24IDaddySearchAlbumRequest")
@interface IDaddySearchAlbumRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull deviceId;
@property (nonatomic, copy) NSString * _Nonnull productId;
@property (nonatomic, copy) NSString * _Nonnull keyword;
@property (nonatomic) NSInteger matching;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger limit;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK24IDaddySearchTrackRequest")
@interface IDaddySearchTrackRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull deviceId;
@property (nonatomic, copy) NSString * _Nonnull productId;
@property (nonatomic, copy) NSString * _Nonnull keyword;
@property (nonatomic) NSInteger matching;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger limit;
@property (nonatomic, copy) NSString * _Nonnull cat_ids;
@property (nonatomic) NSInteger scoped;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18IDaddyTrackRequest")
@interface IDaddyTrackRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull deviceId;
@property (nonatomic, copy) NSString * _Nonnull productId;
@property (nonatomic, copy) NSString * _Nonnull albumId;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger limit;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK19InitPasswordRequest")
@interface InitPasswordRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable userName;
@property (nonatomic, copy) NSString * _Nullable password;
@property (nonatomic, copy) NSString * _Nullable pwCredential;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16InstructionModel")
@interface InstructionModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable instructionId;
@property (nonatomic, strong) NSArray * _Nullable sentences;
@property (nonatomic, strong) NSArray * _Nullable commands;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15LetingCateModel")
@interface LetingCateModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable catalog_id;
@property (nonatomic, copy) NSString * _Nullable catalog_name;
@property (nonatomic, copy) NSString * _Nullable user_subscribe;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16LetingVideoModel")
@interface LetingVideoModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable audio;
@property (nonatomic, copy) NSString * _Nullable catalog_id;
@property (nonatomic, copy) NSString * _Nullable catalog_name;
@property (nonatomic, copy) NSString * _Nullable content;
@property (nonatomic) NSInteger duration;
@property (nonatomic, copy) NSString * _Nullable hms;
@property (nonatomic, copy) NSString * _Nullable hot;
@property (nonatomic, copy) NSString * _Nullable human_time;
@property (nonatomic, copy) NSString * _Nullable image;
@property (nonatomic, copy) NSString * _Nullable pub_time;
@property (nonatomic, copy) NSString * _Nullable sid;
@property (nonatomic, copy) NSString * _Nullable source;
@property (nonatomic, copy) NSString * _Nullable tags;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable updated_at;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16LinkPhoneRequest")
@interface LinkPhoneRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable unionId;
@property (nonatomic, copy) NSString * _Nullable openId;
@property (nonatomic, copy) NSString * _Nullable nickName;
@property (nonatomic, copy) NSString * _Nullable headImgUrl;
@property (nonatomic, copy) NSString * _Nonnull channel;
@property (nonatomic, copy) NSString * _Nullable mobile;
@property (nonatomic, copy) NSString * _Nullable smsCode;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK12LoginRequest")
@interface LoginRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable userName;
@property (nonatomic, copy) NSString * _Nullable password;
@property (nonatomic, copy) NSString * _Nullable smsCode;
@property (nonatomic, copy) NSString * _Nonnull channel;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15NewsSearchModel")
@interface NewsSearchModel : NSObject
@property (nonatomic, copy) NSString * _Nullable audio;
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic) double duration;
@property (nonatomic, copy) NSString * _Nullable human_time;
@property (nonatomic, copy) NSString * _Nullable image;
@property (nonatomic, copy) NSString * _Nullable sid;
@property (nonatomic, copy) NSString * _Nullable source;
@property (nonatomic, copy) NSString * _Nullable title;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18ODMFunctiongsModel")
@interface ODMFunctiongsModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger funId;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable icon;
@property (nonatomic) NSInteger type;
@property (nonatomic, copy) NSString * _Nullable url;
@property (nonatomic, copy) NSString * _Nullable text;
@property (nonatomic) NSInteger page;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK21ODMPagesCategoryModel")
@interface ODMPagesCategoryModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger catId;
@property (nonatomic, copy) NSString * _Nullable name;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16ODMSettingsModel")
@interface ODMSettingsModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger setId;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable icon;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class PersonalityModel;
@class PagesModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK14OdmConfigModel")
@interface OdmConfigModel : NSObject <NSCoding, YYModel>
@property (nonatomic, strong) PersonalityModel * _Nullable personality;
@property (nonatomic, copy) NSArray<PagesModel *> * _Nullable pages;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16OtherSearchModel")
@interface OtherSearchModel : NSObject
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic, copy) NSString * _Nullable albumTitle;
@property (nonatomic, copy) NSString * _Nullable artist;
@property (nonatomic, copy) NSString * _Nullable author;
@property (nonatomic, copy) NSString * _Nullable coverUrlLarge;
@property (nonatomic, copy) NSString * _Nullable coverUrlMiddle;
@property (nonatomic, copy) NSString * _Nullable coverUrlSmall;
@property (nonatomic) double duration;
@property (nonatomic, copy) NSString * _Nullable episode;
@property (nonatomic, copy) NSString * _Nullable playUrl64;
@property (nonatomic, copy) NSString * _Nullable source;
@property (nonatomic, copy) NSString * _Nullable sourceId;
@property (nonatomic, copy) NSString * _Nullable trackIntro;
@property (nonatomic, copy) NSString * _Nullable trackTags;
@property (nonatomic, copy) NSString * _Nullable trackTitle;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable musicId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class PBRecordListModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK19PBDetailedListModel")
@interface PBDetailedListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable dataStr;
@property (nonatomic) NSInteger readBookCount;
@property (nonatomic, copy) NSArray<PBRecordListModel *> * _Nullable bookCountList;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK11PBListModel")
@interface PBListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic, copy) NSString * _Nullable audioUrl;
@property (nonatomic) NSInteger pageNum;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class ReadTrendModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK23PBReadRecordDetailModel")
@interface PBReadRecordDetailModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger days;
@property (nonatomic) NSInteger exceedRatio;
@property (nonatomic, copy) NSString * _Nullable poster;
@property (nonatomic, copy) NSString * _Nullable qrCode;
@property (nonatomic, strong) ReadTrendModel * _Nullable readTrend;
@property (nonatomic, copy) NSArray<BookTypeReadStatsModel *> * _Nullable bookTypeReadStats;
@property (nonatomic) NSInteger readBookCount;
@property (nonatomic) NSInteger readDuration;
@property (nonatomic, copy) NSArray<PBDetailedListModel *> * _Nullable detailedList;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK17PBReadRecordModel")
@interface PBReadRecordModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger readBookCount;
@property (nonatomic) NSInteger readFrequency;
@property (nonatomic) NSInteger readDuration;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22PBRecommendDetailModel")
@interface PBRecommendDetailModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable author;
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic, copy) NSString * _Nullable recommendReason;
@property (nonatomic, copy) NSString * _Nullable desc;
@property (nonatomic, copy) NSString * _Nullable typeName;
@property (nonatomic) NSInteger readFrequency;
@property (nonatomic) NSInteger languageType;
@property (nonatomic, copy) NSString * _Nullable picBookName;
@property (nonatomic, copy) NSArray<PBListModel *> * _Nullable picBookList;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20PBRecommendListModel")
@interface PBRecommendListModel : NSObject <NSCoding, YYModel>
@property (nonatomic) float discountPrice;
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic, copy) NSString * _Nullable recommendId;
@property (nonatomic, copy) NSString * _Nullable picBookName;
@property (nonatomic) float originalPrice;
@property (nonatomic, copy) NSString * _Nullable recommendReason;
@property (nonatomic, copy) NSString * _Nullable picBookId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20PBRecommendTypeModel")
@interface PBRecommendTypeModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable recommendId;
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger viewType;
@property (nonatomic, copy) NSString * _Nullable themeValue;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK17PBRecordListModel")
@interface PBRecordListModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger correctQaCount;
@property (nonatomic) NSInteger qaCount;
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic, copy) NSString * _Nullable picBookName;
@property (nonatomic, copy) NSString * _Nullable picBookId;
@property (nonatomic) NSInteger readFrequency;
@property (nonatomic) NSInteger readDuration;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK10PagesModel")
@interface PagesModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable defaultIcon;
@property (nonatomic, copy) NSString * _Nullable selectIcon;
@property (nonatomic) NSInteger page;
@property (nonatomic, copy) NSArray<ODMPagesCategoryModel *> * _Nullable category;
@property (nonatomic, copy) NSArray<ODMFunctiongsModel *> * _Nullable functions;
@property (nonatomic, copy) NSArray<ODMSettingsModel *> * _Nullable settings;
@property (nonatomic, copy) NSArray<ODMFunctiongsModel *> * _Nullable personalCenter;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16PersonalityModel")
@interface PersonalityModel : NSObject
@property (nonatomic, copy) NSString * _Nullable icon;
@property (nonatomic, copy) NSString * _Nullable subColor;
@property (nonatomic, strong) NSArray * _Nullable network;
@property (nonatomic, copy) NSString * _Nullable viceTitle;
@property (nonatomic, copy) NSString * _Nullable title;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, PlayStatus, open) {
  PlayStatusAPP_OTHER_TYPE = -1,
  PlayStatusAPP_OFFLINE = 0,
  PlayStatusAPP_ONLINE = 1,
  PlayStatusAPP_PLAY = 2,
  PlayStatusAPP_SUSPEND = 3,
  PlayStatusAPP_CONTINUE_PLAY = 4,
  PlayStatusAPP_NEXT = 5,
  PlayStatusAPP_PREV = 6,
  PlayStatusAPP_SOUND = 7,
  PlayStatusAPP_DOWNLOAD_STATE = 8,
  PlayStatusAPP_PLAY_MODE = 9,
  PlayStatusAPP_BLUETOOTH_NEXT = 10,
  PlayStatusAPP_BLUETOOTH_PREV = 11,
  PlayStatusAPP_BLUETOOTH_SUSPEND = 12,
  PlayStatusAPP_BLUETOOTH_CONTINUE = 13,
  PlayStatusAPP_BLUETOOTH = 14,
  PlayStatusAPP_DRAG = 15,
  PlayStatusAPP_UNBIND = 16,
  PlayStatusAPP_STATE = 17,
  PlayStatusAPP_LIKE = 18,
  PlayStatusAPP_CANCEL_LIKE = 19,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK13QaAnswerModel")
@interface QaAnswerModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable aID;
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable skillId;
@property (nonatomic, copy) NSString * _Nullable topicId;
@property (nonatomic, copy) NSString * _Nullable kId;
@property (nonatomic, copy) NSString * _Nullable answerId;
@property (nonatomic, copy) NSString * _Nullable answerName;
@property (nonatomic) BOOL mobileClient;
@property (nonatomic) BOOL pcClient;
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic, copy) NSString * _Nullable linkUrl;
@property (nonatomic, copy) NSString * _Nullable weight;
@property (nonatomic) BOOL primaryFlag;
@property (nonatomic, copy) NSString * _Nullable createBy;
@property (nonatomic, copy) NSString * _Nullable createDate;
@property (nonatomic, copy) NSString * _Nullable updateBy;
@property (nonatomic, copy) NSString * _Nullable updateDate;
@property (nonatomic, copy) NSString * _Nullable deleteBy;
@property (nonatomic, copy) NSString * _Nullable deleteDate;
@property (nonatomic) BOOL deleteFlag;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class QaTopicKnowledgeModel;
@class QaQuestionModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK11QaInfoModel")
@interface QaInfoModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable skillId;
@property (nonatomic, copy) NSString * _Nullable topicId;
@property (nonatomic, copy) NSString * _Nullable kId;
@property (nonatomic, strong) QaTopicKnowledgeModel * _Nullable topicKnowledgeModel;
@property (nonatomic, copy) NSArray<QaQuestionModel *> * _Nullable question;
@property (nonatomic, copy) NSArray<QaAnswerModel *> * _Nullable answer;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK11QaInitModel")
@interface QaInitModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable productName;
@property (nonatomic, copy) NSString * _Nullable productType;
@property (nonatomic, copy) NSString * _Nullable publicKey;
@property (nonatomic, copy) NSString * _Nullable secretKey;
@property (nonatomic, strong) NSArray * _Nullable skillIds;
@property (nonatomic, strong) NSArray * _Nullable topicIds;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15QaQuestionModel")
@interface QaQuestionModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable qID;
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable skillId;
@property (nonatomic, copy) NSString * _Nullable topicId;
@property (nonatomic, copy) NSString * _Nullable kId;
@property (nonatomic, copy) NSString * _Nullable questionId;
@property (nonatomic, copy) NSString * _Nullable questionName;
@property (nonatomic) BOOL primaryFlag;
@property (nonatomic) BOOL diffusionFlag;
@property (nonatomic, copy) NSString * _Nullable createBy;
@property (nonatomic, copy) NSString * _Nullable createDate;
@property (nonatomic, copy) NSString * _Nullable updateBy;
@property (nonatomic, copy) NSString * _Nullable updateDate;
@property (nonatomic, copy) NSString * _Nullable deleteBy;
@property (nonatomic, copy) NSString * _Nullable deleteDate;
@property (nonatomic) BOOL deleteFlag;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK21QaTopicKnowledgeModel")
@interface QaTopicKnowledgeModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable topicKnowledgeId;
@property (nonatomic, copy) NSString * _Nullable topicId;
@property (nonatomic, copy) NSString * _Nullable kId;
@property (nonatomic) BOOL kType;
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable skillId;
@property (nonatomic, copy) NSString * _Nullable weight;
@property (nonatomic, copy) NSString * _Nullable createBy;
@property (nonatomic, copy) NSString * _Nullable createDate;
@property (nonatomic, copy) NSString * _Nullable updateBy;
@property (nonatomic, copy) NSString * _Nullable updateDate;
@property (nonatomic, copy) NSString * _Nullable deleteBy;
@property (nonatomic, copy) NSString * _Nullable deleteDate;
@property (nonatomic) BOOL deleteFlag;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18QuickCreateRequest")
@interface QuickCreateRequest : NSObject
@property (nonatomic, strong) NSArray * _Nullable sentences;
@property (nonatomic, strong) NSArray * _Nullable commands;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK17QuickLoginRequest")
@interface QuickLoginRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable accesToken;
@property (nonatomic, copy) NSString * _Nonnull channel;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK14ReadTrendModel")
@interface ReadTrendModel : NSObject
@property (nonatomic) NSInteger Monday;
@property (nonatomic) NSInteger Tuesday;
@property (nonatomic) NSInteger Wednesday;
@property (nonatomic) NSInteger Thursday;
@property (nonatomic) NSInteger Friday;
@property (nonatomic) NSInteger Saturday;
@property (nonatomic) NSInteger Sunday;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, ReceiveState, open) {
  ReceiveStateReceiveSuccess = 0,
  ReceiveStateReceiveFailure = 1,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK13ResAlbumModel")
@interface ResAlbumModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable coverUrlLarge;
@property (nonatomic) NSInteger trackCount;
@property (nonatomic, copy) NSString * _Nullable releaseTime;
@property (nonatomic, copy) NSString * _Nullable artist;
@property (nonatomic, copy) NSString * _Nullable coverUrlSmall;
@property (nonatomic, copy) NSString * _Nullable coverUrlMiddle;
@property (nonatomic, copy) NSString * _Nullable author;
@property (nonatomic, copy) NSString * _Nullable intro;
@property (nonatomic, copy) NSString * _Nullable resAlbumId;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable languageName;
@property (nonatomic, copy) NSString * _Nullable tags;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable source;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
typedef SWIFT_ENUM(NSInteger, ResCommType, open) {
  ResCommTypeSTORY = 1,
  ResCommTypeGUO_XUE = 2,
  ResCommTypeCHILD_SONG = 3,
  ResCommTypePOETRY = 4,
  ResCommTypeXIANG_SHENG = 5,
  ResCommTypeXIAO_PIN = 6,
  ResCommTypePING_SHU = 7,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK19ResIdaddyCatesModel")
@interface ResIdaddyCatesModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable catId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13ResMusicModel")
@interface ResMusicModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable musicId;
@property (nonatomic, copy) NSString * _Nullable coverUrlLarge;
@property (nonatomic, copy) NSString * _Nullable artist;
@property (nonatomic, copy) NSString * _Nullable coverUrlSmall;
@property (nonatomic, copy) NSString * _Nullable author;
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic, copy) NSString * _Nullable trackIntro;
@property (nonatomic, copy) NSString * _Nullable coverUrlMiddle;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable languageName;
@property (nonatomic, copy) NSString * _Nullable trackTitle;
@property (nonatomic, copy) NSString * _Nullable playUrl;
@property (nonatomic, copy) NSString * _Nullable playSize;
@property (nonatomic) NSInteger duration;
@property (nonatomic, copy) NSString * _Nullable albumTitle;
@property (nonatomic, copy) NSString * _Nullable trackTags;
@property (nonatomic, copy) NSString * _Nullable source;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20ResNewsCateListModel")
@interface ResNewsCateListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable newsId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16ResNewsListModel")
@interface ResNewsListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable newsListId;
@property (nonatomic, copy) NSString * _Nullable category;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable image_url;
@property (nonatomic, copy) NSString * _Nullable audio_url;
@property (nonatomic, copy) NSString * _Nullable duration;
@property (nonatomic, copy) NSString * _Nullable source;
@property (nonatomic, copy) NSString * _Nullable human_time;
@property (nonatomic, copy) NSString * _Nullable updated_at;
@property (nonatomic, copy) NSString * _Nullable tags;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK21ResRadioCateListModel")
@interface ResRadioCateListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable radioId;
@property (nonatomic, copy) NSString * _Nullable icon;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class ResRadioProgramModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK17ResRadioListModel")
@interface ResRadioListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable logo;
@property (nonatomic, copy) NSString * _Nullable play_url;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable fm;
@property (nonatomic, strong) ResRadioProgramModel * _Nullable program;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20ResRadioProgramModel")
@interface ResRadioProgramModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable start_time;
@property (nonatomic, copy) NSString * _Nullable end_time;
@property (nonatomic, copy) NSString * _Nullable dj;
@property (nonatomic, copy) NSString * _Nullable week;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
typedef SWIFT_ENUM(NSInteger, SMSCODETYPE, open) {
  SMSCODETYPELOGIN = 1,
  SMSCODETYPEFORGETPW = 2,
  SMSCODETYPEBINDINGPHONE = 4,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK11SearchModel")
@interface SearchModel : NSObject
@property (nonatomic, copy) NSArray<HiFiSearchModel *> * _Nullable hifiSearchModel;
@property (nonatomic, copy) NSArray<OtherSearchModel *> * _Nullable otherSearchModel;
@property (nonatomic, copy) NSArray<NewsSearchModel *> * _Nullable newsSearchModel;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, SearchType, open) {
  SearchTypeHIFISONG = 1,
  SearchTypeHIFIALBUM = 2,
  SearchTypeQUYI = 3,
  SearchTypeBOOK = 4,
  SearchTypeNEWS = 5,
  SearchTypeSTORY = 6,
  SearchTypeGUOXUE = 7,
  SearchTypeCHILDSONG = 8,
  SearchTypePOETRY = 9,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK18SearchVideoRequest")
@interface SearchVideoRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull catalogId;
@property (nonatomic, copy) NSString * _Nonnull uid;
@property (nonatomic, copy) NSString * _Nonnull productId;
@property (nonatomic, copy) NSString * _Nonnull province;
@property (nonatomic, copy) NSString * _Nonnull city;
@property (nonatomic, copy) NSString * _Nonnull keyword;
@property (nonatomic) NSInteger distinct;
@property (nonatomic) NSInteger size;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18SetPasswordRequest")
@interface SetPasswordRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable token;
@property (nonatomic, copy) NSString * _Nullable password;
@property (nonatomic, copy) NSString * _Nonnull channel;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18SkillDetailRequest")
@interface SkillDetailRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull skillId;
@property (nonatomic, copy) NSString * _Nonnull skillVersion;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK12SkillRequest")
@interface SkillRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull skillId;
@property (nonatomic, copy) NSString * _Nonnull skillVersion;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK21SmartHomeTokenRequest")
@interface SmartHomeTokenRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable skillId;
@property (nonatomic, copy) NSString * _Nullable skillVersion;
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable smartHomeAccessToken;
@property (nonatomic, copy) NSString * _Nullable smartHomeRefreshToken;
@property (nonatomic) NSInteger accessTokenExpiresIn;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, SonicNetworkState, open) {
  SonicNetworkStateSonicNetworkSuccess = 0,
  SonicNetworkStateSonicNetworkFailure = 1,
  SonicNetworkStateSonicNetworkConnecting = 2,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK16TVBatchListModel")
@interface TVBatchListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSArray<TVDetailModel *> * _Nullable data;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class iqiyiMediaModel;
@class vstMediaModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK13TVDetailModel")
@interface TVDetailModel : NSObject <NSCoding, YYModel>
@property (nonatomic, strong) NSArray * _Nullable screenwriter;
@property (nonatomic, strong) NSArray * _Nullable artist;
@property (nonatomic, strong) iqiyiMediaModel * _Nullable iqiyi_media;
@property (nonatomic, strong) vstMediaModel * _Nullable vst_media;
@property (nonatomic, copy) NSString * _Nullable iqiyi_score;
@property (nonatomic, copy) NSString * _Nullable douban_score;
@property (nonatomic, copy) NSString * _Nullable year;
@property (nonatomic, strong) NSArray * _Nullable director;
@property (nonatomic, strong) NSArray * _Nullable participator;
@property (nonatomic, copy) NSString * _Nullable hot;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, strong) NSArray * _Nullable union_styles;
@property (nonatomic, copy) NSString * _Nullable category;
@property (nonatomic, strong) NSArray * _Nullable region;
@property (nonatomic, copy) NSString * _Nullable tvId;
@property (nonatomic, strong) NSArray * _Nullable iqiyi_tags;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK11TVShowModel")
@interface TVShowModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable beginTime;
@property (nonatomic, copy) NSString * _Nullable detail;
@property (nonatomic, copy) NSString * _Nullable endTime;
@property (nonatomic) NSInteger showId;
@property (nonatomic, copy) NSString * _Nullable img;
@property (nonatomic, copy) NSString * _Nullable introduction;
@property (nonatomic) NSInteger state;
@property (nonatomic, copy) NSString * _Nullable title;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK17TrainRequestModel")
@interface TrainRequestModel : NSObject
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable gender;
@property (nonatomic, copy) NSString * _Nullable age;
@property (nonatomic, copy) NSString * _Nullable customInfo;
@property (nonatomic, copy) NSArray<NSString *> * _Nullable audio_list;
@property (nonatomic, copy) NSArray<NSString *> * _Nullable pre_tts_text;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18UploadRequestModel")
@interface UploadRequestModel : NSObject
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable textId;
@property (nonatomic, copy) NSString * _Nullable gender;
@property (nonatomic, copy) NSString * _Nonnull age;
@property (nonatomic, copy) NSData * _Nullable data;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13UserInfoModel")
@interface UserInfoModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic, copy) NSString * _Nullable phone;
@property (nonatomic, copy) NSString * _Nullable pId;
@property (nonatomic) NSInteger sex;
@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable token;
@property (nonatomic, copy) NSString * _Nullable qrCode;
@property (nonatomic, copy) NSString * _Nullable accId;
@property (nonatomic, copy) NSString * _Nullable address;
@property (nonatomic, copy) NSString * _Nullable nickName;
@property (nonatomic, copy) NSString * _Nullable head;
@property (nonatomic, copy) NSString * _Nullable appId;
@property (nonatomic, copy) NSString * _Nullable birthday;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13VerifyRequest")
@interface VerifyRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable userName;
@property (nonatomic, copy) NSString * _Nullable smsCode;
@property (nonatomic, copy) NSString * _Nonnull channel;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK14VoiceCopyModel")
@interface VoiceCopyModel : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18VoiceCopyTextModel")
@interface VoiceCopyTextModel : NSObject
@property (nonatomic, copy) NSString * _Nullable textId;
@property (nonatomic, copy) NSString * _Nullable text;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18WeChatLoginRequest")
@interface WeChatLoginRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable unionId;
@property (nonatomic, copy) NSString * _Nullable openId;
@property (nonatomic, copy) NSString * _Nullable nickName;
@property (nonatomic, copy) NSString * _Nullable headImgUrl;
@property (nonatomic, copy) NSString * _Nonnull channel;
@property (nonatomic) BOOL allowCreate;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK11epInfoModel")
@interface epInfoModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger epOrder;
@property (nonatomic, copy) NSString * _Nullable year;
@property (nonatomic) NSInteger epIsVip;
@property (nonatomic) NSInteger epLen;
@property (nonatomic, copy) NSString * _Nullable epPicUrl;
@property (nonatomic, copy) NSString * _Nullable videoId;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable epName;
@property (nonatomic) NSInteger epType;
@property (nonatomic, copy) NSString * _Nullable epFocus;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15iqiyiMediaModel")
@interface iqiyiMediaModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic, copy) NSString * _Nullable videoId;
@property (nonatomic) NSInteger hot;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic) NSInteger isVip;
@property (nonatomic) NSInteger effective;
@property (nonatomic, copy) NSString * _Nullable picUrl;
@property (nonatomic) NSInteger playCount;
@property (nonatomic) NSInteger sourceCode;
@property (nonatomic, copy) NSString * _Nullable focusName;
@property (nonatomic, copy) NSString * _Nullable posterUrl;
@property (nonatomic) NSInteger epProbation;
@property (nonatomic) NSInteger series;
@property (nonatomic) NSInteger channelId;
@property (nonatomic, copy) NSString * _Nullable desc;
@property (nonatomic, copy) NSArray<epInfoModel *> * _Nullable epInfo;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13vstMediaModel")
@interface vstMediaModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable playCount;
@property (nonatomic, copy) NSString * _Nullable posterUrl;
@property (nonatomic, copy) NSString * _Nullable videoId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif
#elif defined(__ARM_ARCH_7A__) && __ARM_ARCH_7A__
#ifndef IOS_DCA_SDK_SWIFT_H
#define IOS_DCA_SDK_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"
#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif
#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif
#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif
#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif
#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif
#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif
#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import CoreGraphics;
@import Foundation;
@import ObjectiveC;
@import UIKit;
@import WebKit;
@import YYKit;
#endif
#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"
#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="iOS_DCA_SDK",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif
typedef SWIFT_ENUM(NSInteger, APNetworkState, open) {
  APNetworkStateAPNetworkSuccess = 0,
  APNetworkStateAPNetworkFailure = 1,
  APNetworkStateAPNetworkConnecting = 2,
};
@class NSCoder;
SWIFT_CLASS("_TtC11iOS_DCA_SDK17AboutUsH5UrlModel")
@interface AboutUsH5UrlModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable adCooperation;
@property (nonatomic, copy) NSString * _Nullable commonProblem;
@property (nonatomic, copy) NSString * _Nullable companyProcurement;
@property (nonatomic, copy) NSString * _Nullable contactUs;
@property (nonatomic, copy) NSString * _Nullable hardwareInformation;
@property (nonatomic, copy) NSString * _Nullable secrecyProtocol;
@property (nonatomic, copy) NSString * _Nullable serviceProtocol;
@property (nonatomic, copy) NSString * _Nullable shopLink;
@property (nonatomic, copy) NSString * _Nullable useGuide;
@property (nonatomic, copy) NSString * _Nullable userProtocol;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class AccountTokenModel;
@class AccountRmemAuthModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK12AccountModel")
@interface AccountModel : NSObject <NSCoding, YYModel>
@property (nonatomic) BOOL isNewUser;
@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable pwCredential;
@property (nonatomic, strong) AccountTokenModel * _Nullable TOKEN;
@property (nonatomic, strong) AccountRmemAuthModel * _Nullable RmemAuth;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20AccountRmemAuthModel")
@interface AccountRmemAuthModel : NSObject
@property (nonatomic, copy) NSString * _Nullable value;
@property (nonatomic, copy) NSString * _Nullable expire_in;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK17AccountTokenModel")
@interface AccountTokenModel : NSObject
@property (nonatomic, copy) NSString * _Nullable value;
@property (nonatomic, copy) NSString * _Nullable expire_in;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18AdvertisementModel")
@interface AdvertisementModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger mode;
@property (nonatomic, copy) NSString * _Nullable appId;
@property (nonatomic) NSInteger adId;
@property (nonatomic) NSInteger type;
@property (nonatomic, copy) NSString * _Nullable content;
@property (nonatomic, copy) NSString * _Nullable url;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK23ApplianceAliasSyncModel")
@interface ApplianceAliasSyncModel : NSObject
@property (nonatomic, copy) NSString * _Nullable skillId;
@property (nonatomic, copy) NSString * _Nullable skillVersion;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13HiFiBaseModel")
@interface HiFiBaseModel : NSObject <NSCoding, YYModel>
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22ArtistGroupDetailModel")
@interface ArtistGroupDetailModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable smallimg;
@property (nonatomic, copy) NSString * _Nullable artistId;
@property (nonatomic, copy) NSString * _Nullable name;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20ArtistGroupListModel")
@interface ArtistGroupListModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable image;
@property (nonatomic, copy) NSString * _Nullable groupId;
@property (nonatomic, copy) NSString * _Nullable name;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18AudioFileListModel")
@interface AudioFileListModel : HiFiBaseModel
@property (nonatomic) NSInteger audioCategoryId;
@property (nonatomic, copy) NSString * _Nullable musicUrl;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13BabyDataModel")
@interface BabyDataModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger born;
@property (nonatomic, copy) NSString * _Nullable relation;
@property (nonatomic) NSInteger sex;
@property (nonatomic) NSInteger babyInfoId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15BatchPosRequest")
@interface BatchPosRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull skillId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, BleNetworkState, open) {
  BleNetworkStateBleNetworkSuccess = 0,
  BleNetworkStateBleNetworkFailure = 1,
  BleNetworkStateBleNetworkConnecting = 2,
};
typedef SWIFT_ENUM(NSInteger, BluetoothState, open) {
  BluetoothStateBluetoothOpen = 0,
  BluetoothStateBluetoothClose = 1,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK15BookSearchModel")
@interface BookSearchModel : NSObject
@property (nonatomic, copy) NSString * _Nullable announcer;
@property (nonatomic, copy) NSString * _Nullable author;
@property (nonatomic, copy) NSString * _Nullable cover;
@property (nonatomic, copy) NSString * _Nullable desc;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable musicId;
@property (nonatomic, copy) NSString * _Nullable typeName;
@property (nonatomic, copy) NSString * _Nullable typeId;
@property (nonatomic) NSInteger state;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22BookTypeReadStatsModel")
@interface BookTypeReadStatsModel : NSObject <NSCoding, YYModel>
@property (nonatomic) double ratio;
@property (nonatomic, copy) NSString * _Nullable bookTypeName;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK21ChildAlbumBrowseModel")
@interface ChildAlbumBrowseModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable musicId;
@property (nonatomic, copy) NSString * _Nullable musicTitle;
@property (nonatomic, copy) NSString * _Nullable musicType;
@property (nonatomic, copy) NSString * _Nullable artistsName;
@property (nonatomic, copy) NSString * _Nullable albumName;
@property (nonatomic) double duration;
@property (nonatomic, copy) NSString * _Nullable play_url;
@property (nonatomic) BOOL isfav;
@property (nonatomic) BOOL isplay;
@property (nonatomic, copy) NSString * _Nullable cover_url_middle;
@property (nonatomic, copy) NSString * _Nullable cover_url_large;
@property (nonatomic, copy) NSString * _Nullable sort;
@property (nonatomic) BOOL isOwn;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK21ChildBatchDetailModel")
@interface ChildBatchDetailModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable aboumId;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable front_url;
@property (nonatomic, copy) NSString * _Nullable author;
@property (nonatomic) double duration;
@property (nonatomic, copy) NSString * _Nullable des;
@property (nonatomic, copy) NSString * _Nullable source;
@property (nonatomic, copy) NSString * _Nullable type;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK19ChildBatchListModel")
@interface ChildBatchListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable ID;
@property (nonatomic, copy) NSString * _Nullable mouldName;
@property (nonatomic, copy) NSString * _Nullable mouldType;
@property (nonatomic, copy) NSString * _Nullable albumType;
@property (nonatomic, copy) NSArray<ChildBatchDetailModel *> * _Nullable data;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18ChildCarouselModel")
@interface ChildCarouselModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable imgUrl;
@property (nonatomic) NSInteger position;
@property (nonatomic, copy) NSString * _Nullable redirection;
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic, copy) NSString * _Nullable information;
@property (nonatomic, copy) NSString * _Nullable source;
@property (nonatomic, copy) NSString * _Nullable stype;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK14CommandRequest")
@interface CommandRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable text;
@property (nonatomic, copy) NSString * _Nullable type;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, ConnectStatus, open) {
  ConnectStatusCONNECT_SUCCESS = 1,
  ConnectStatusCONNECT_FAIL = 2,
  ConnectStatusSUBSCRIBE_SUCCESS = 3,
  ConnectStatusUNSUBSCRIBE_SUCCESS = 4,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK18CourseAlbumRequest")
@interface CourseAlbumRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable grade;
@property (nonatomic, copy) NSString * _Nullable subject;
@property (nonatomic, copy) NSString * _Nullable version;
@property (nonatomic, copy) NSString * _Nullable term;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class NSDictionary;
SWIFT_CLASS("_TtC11iOS_DCA_SDK15DCAAPNetManager")
@interface DCAAPNetManager : NSObject
@property (nonatomic, copy) NSString * _Nonnull urlStr;
@property (nonatomic, copy) NSString * _Nonnull deviceWifiName;
- (void)startAPNetworkWithWifiStr:(NSString * _Nonnull)wifiStr pwd:(NSString * _Nonnull)pwd apNetResult:(void (^ _Nullable)(enum APNetworkState, NSString * _Nonnull, NSDictionary * _Nonnull))apNetResult;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class WeChatLoginRequest;
@class LinkPhoneRequest;
@class GetCodeRequestModel;
@class LoginRequest;
@class VerifyRequest;
@class InitPasswordRequest;
@class SetPasswordRequest;
@class NSError;
@class QuickLoginRequest;
SWIFT_CLASS("_TtC11iOS_DCA_SDK17DCAAccountManager")
@interface DCAAccountManager : NSObject
- (NSString * _Nonnull)getUserId SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nonnull)getAccessToken SWIFT_WARN_UNUSED_RESULT;
- (void)loginOut;
- (void)loginByWeChatWithRequest:(WeChatLoginRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AccountModel * _Nullable))callBack;
- (void)linkPhoneNumWithRequest:(LinkPhoneRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AccountModel * _Nullable))callBack;
- (void)getVerifyCodeWithRequestModel:(GetCodeRequestModel * _Nonnull)requestModel callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)loginWithRequest:(LoginRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AccountModel * _Nullable))callBack;
- (void)verifyUserNameBySmsCodeWithRequest:(VerifyRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AccountModel * _Nullable))callBack;
- (void)initPasswordWithRequest:(InitPasswordRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack SWIFT_METHOD_FAMILY(none);
- (void)setPasswordWithRequest:(SetPasswordRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)linkAcountWithThirdPlatformUid:(NSString * _Nonnull)thirdPlatformUid thirdPlatformToken:(NSString * _Nonnull)thirdPlatformToken manufactureSecret:(NSString * _Nonnull)manufactureSecret callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AccountModel * _Nullable))callBack;
- (void)refreshTokenWithCallBack:(void (^ _Nonnull)(BOOL))callBack;
- (void)getWeChatAuthDataWithWxAppId:(NSString * _Nonnull)wxAppId wxAppSecret:(NSString * _Nonnull)wxAppSecret code:(NSString * _Nonnull)code callBack:(void (^ _Nonnull)(NSDictionary * _Nullable, NSError * _Nullable))callBack;
- (void)getWeChatLoginUserInfoWithAccessToken:(NSString * _Nonnull)accessToken openId:(NSString * _Nonnull)openId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable, NSError * _Nullable))callBack;
- (void)phoneQuickLoginWithRequest:(QuickLoginRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AccountModel * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13DCAAppManager")
@interface DCAAppManager : NSObject
- (void)getAdvertisementListDataWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AdvertisementModel * _Nullable))callBack;
- (void)getCarouselDataWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ChildCarouselModel *> * _Nullable))callBack;
- (void)feedBackWithType:(NSString * _Nonnull)type userPhone:(NSString * _Nonnull)userPhone content:(NSString * _Nonnull)content imageUrl:(NSString * _Nonnull)imageUrl callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)loadAboutUsMsgDataWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, AboutUsH5UrlModel * _Nullable))callBack;
- (void)checkAppVersionWithVersion:(NSString * _Nonnull)version callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class CBPeripheral;
@class UIViewController;
enum ReceiveState : NSInteger;
SWIFT_CLASS("_TtC11iOS_DCA_SDK16DCABleNetManager")
@interface DCABleNetManager : NSObject
- (void)getDeviceIdWithBleDeviceID:(void (^ _Nullable)(NSString * _Nonnull))bleDeviceID;
- (void)initBleNetworkWithBleState:(void (^ _Nullable)(enum BluetoothState))bleState SWIFT_METHOD_FAMILY(none);
- (void)startDiscoverBleWithBleData:(void (^ _Nullable)(NSDictionary * _Nonnull))bleData;
- (void)sendDataToDeviceWithPeripheral:(CBPeripheral * _Nonnull)peripheral ssid:(NSString * _Nonnull)ssid pwd:(NSString * _Nonnull)pwd vc:(UIViewController * _Nonnull)vc bleNetResult:(void (^ _Nonnull)(enum BleNetworkState, NSString * _Nonnull, NSDictionary * _Nonnull))bleNetResult;
- (void)sendWifiInfoToDeviceWithPeripheral:(CBPeripheral * _Nonnull)peripheral ssid:(NSString * _Nonnull)ssid pwd:(NSString * _Nonnull)pwd vc:(UIViewController * _Nonnull)vc receiveResult:(void (^ _Nonnull)(enum ReceiveState, NSString * _Nonnull))receiveResult;
- (void)stopDiscoverBle;
- (void)deallocBleNetwork;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
enum PlayStatus : NSInteger;
SWIFT_CLASS("_TtC11iOS_DCA_SDK23DCADeviceControlManager")
@interface DCADeviceControlManager : NSObject
@property (nonatomic) BOOL isConnect;
- (void)connectWithConnectStatus:(void (^ _Nullable)(enum ConnectStatus))connectStatus;
- (void)subscribeTopicWithTopic:(NSString * _Nullable)topic;
- (void)sendDataWithTopic:(NSString * _Nullable)topic jsonStr:(NSString * _Nullable)jsonStr isRetain:(BOOL)isRetain;
- (void)unSubscribeTopicWithTopic:(NSString * _Nullable)topic;
- (void)disconnect;
- (void)onReceiveControlMessageWithReceiveMessage:(void (^ _Nullable)(enum PlayStatus, NSDictionary * _Nonnull))receiveMessage;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@interface DCADeviceControlManager (SWIFT_EXTENSION(iOS_DCA_SDK))
- (void)pausePlayWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)continuePlayWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)playPreviousMusicWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)playNextMusicWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getPlayListWithPage:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSInteger, NSArray<ChildAlbumBrowseModel *> * _Nullable))callBack;
- (void)cleanPlayListWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getCurrentPlayIndexWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getCurrentPlayModelWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)setPlayModelWithCurmodel:(NSString * _Nonnull)curmodel callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)playMusicFromPlayListWithSort:(NSString * _Nonnull)sort callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getVolumeWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)setVolumeWithVolume:(NSInteger)volume callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)playMuiscFromListWithModel:(ChildAlbumBrowseModel * _Nonnull)model callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)playMuiscFromAlbumListWithInformation:(NSString * _Nonnull)information model:(ChildBatchDetailModel * _Nonnull)model index:(NSInteger)index callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)pushTolistAndPlayWithIndex:(NSInteger)index musicType:(NSString * _Nonnull)musicType list:(NSArray<ChildAlbumBrowseModel *> * _Nonnull)list callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)playCollectionListWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
@end
@class EquipDeviceInfoModel;
@class EquipAlarmModel;
@class NSArray;
@class EquipRemindModel;
@class EquipVoiceMessageModel;
@class NSData;
@class EquCallRecordListModel;
@class FamilyGroupChatListModel;
@class FGCDetailListModel;
@class QuickCreateRequest;
@class InstructionModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK16DCADeviceManager")
@interface DCADeviceManager : NSObject
@property (nonatomic, copy) NSString * _Nonnull codeVerifier;
- (void)requestAuthCodeWithRedirectUrl:(NSString * _Nonnull)redirectUrl clientId:(NSString * _Nonnull)clientId isScan:(BOOL)isScan callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)bindDeviceWithDeviceData:(NSDictionary * _Nullable)deviceData callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)unbindDeviceWithCallBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)getBindDeviceListWithCallBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)getDialogRecordWithProductId:(NSString * _Nonnull)productId seqId:(NSString * _Nullable)seqId count:(NSInteger)count callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)sendAuthCodeWithDeviceId:(NSString * _Nonnull)deviceId authCode:(NSString * _Nonnull)authCode isScan:(BOOL)isScan callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getQueryDeviceStatusWithUid:(NSString * _Nonnull)uid callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getDeviceCurrentStateWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getDeviceBasicInfoWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, EquipDeviceInfoModel * _Nullable))callBack;
- (void)getAlarmListWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<EquipAlarmModel *> * _Nullable))callBack;
- (void)addAlarmWithAlarmDate:(NSString * _Nonnull)alarmDate alarmTime:(NSString * _Nonnull)alarmTime repeatStr:(NSString * _Nonnull)repeatStr callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)deleteAlarmWithAlarmIds:(NSArray * _Nonnull)alarmIds callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getRemindListWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<EquipRemindModel *> * _Nullable))callBack;
- (void)addRemindWithRemindDate:(NSString * _Nonnull)remindDate remindTime:(NSString * _Nonnull)remindTime event:(NSString * _Nonnull)event repeatStr:(NSString * _Nonnull)repeatStr callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)deleteRemindWithRemindIds:(NSArray * _Nonnull)remindIds callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)setBleActivatedWithModel:(BOOL)model callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)setWakeUpFunctionWithState:(NSInteger)state callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getchatAndMsgUnReadCountWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSInteger))callBack;
- (void)getMessagesWithPage:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<EquipVoiceMessageModel *> * _Nullable))callBack;
- (void)sendVoiceMessageWithData:(NSData * _Nonnull)data callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)getUnReadMessageCountWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)readVoiceMessageWithChatId:(NSString * _Nonnull)chatId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)addCallRecordWithSrcId:(NSString * _Nonnull)srcId targetId:(NSString * _Nonnull)targetId state:(NSInteger)state talkTime:(NSString * _Nonnull)talkTime type:(NSString * _Nonnull)type callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getCallRecordListWithAccId:(NSString * _Nonnull)accId page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<EquCallRecordListModel *> * _Nullable))callBack;
- (void)getGroupChatsWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<FamilyGroupChatListModel *> * _Nullable))callBack;
- (void)createGroupChatWithGroupName:(NSString * _Nonnull)groupName userIds:(NSArray * _Nonnull)userIds callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getGroupChatMessagesWithChatId:(NSString * _Nonnull)chatId page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray * _Nonnull, NSArray<FGCDetailListModel *> * _Nullable))callBack;
- (void)sendGroupChatMessageWithChatId:(NSString * _Nonnull)chatId data:(NSData * _Nonnull)data callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)readGroupChatMessageWithChatId:(NSString * _Nonnull)chatId recordId:(NSString * _Nonnull)recordId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)addSceneWithProductId:(NSString * _Nonnull)productId quickCreateRequest:(QuickCreateRequest * _Nonnull)quickCreateRequest callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)deleteSceneWithProductId:(NSString * _Nonnull)productId sceneId:(NSString * _Nonnull)sceneId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)updateSceneWithProductId:(NSString * _Nonnull)productId sceneId:(NSString * _Nonnull)sceneId quickCreateRequest:(QuickCreateRequest * _Nonnull)quickCreateRequest callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getSceneWithProductId:(NSString * _Nonnull)productId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSArray<InstructionModel *> * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@protocol DCAManagerDelegate;
@class DCAUserManager;
@class DCAMediaResourceManager;
@class DCASmartHomeManager;
@class DCASkillManager;
@class DCASonicNetManager;
@class DCAVoiceCopyManager;
SWIFT_CLASS("_TtC11iOS_DCA_SDK10DCAManager")
@interface DCAManager : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) DCAManager * _Nonnull shared;)
+ (DCAManager * _Nonnull)shared SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, weak) id <DCAManagerDelegate> _Nullable delegate;
@property (nonatomic, copy) NSString * _Nonnull deviceId;
@property (nonatomic, strong) DCAAccountManager * _Nonnull accountManager;
@property (nonatomic, strong) DCAAppManager * _Nonnull appManager;
@property (nonatomic, strong) DCAUserManager * _Nonnull userManager;
@property (nonatomic, strong) DCAMediaResourceManager * _Nonnull mediaResourceManager;
@property (nonatomic, strong) DCADeviceManager * _Nonnull deviceManager;
@property (nonatomic, strong) DCASmartHomeManager * _Nonnull smartHomeManager;
@property (nonatomic, strong) DCASkillManager * _Nonnull skillManager;
@property (nonatomic, strong) DCADeviceControlManager * _Nonnull deviceControlManager;
@property (nonatomic, strong) DCABleNetManager * _Nonnull bleNetManager;
@property (nonatomic, strong) DCASonicNetManager * _Nonnull sonicNetManager;
@property (nonatomic, strong) DCAAPNetManager * _Nonnull apNetManager;
@property (nonatomic, strong) DCAVoiceCopyManager * _Nonnull voiceCopyManager;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
enum EvnType : NSInteger;
@interface DCAManager (SWIFT_EXTENSION(iOS_DCA_SDK))
- (void)setEnvWithEvn:(enum EvnType)evn;
- (void)sdkPrintLogWithIsPrint:(BOOL)isPrint;
- (void)initializeWithApiKey:(NSString * _Nonnull)apiKey apiSecret:(NSString * _Nonnull)apiSecret;
- (NSString * _Nonnull)getSDKVersion SWIFT_WARN_UNUSED_RESULT;
@end
SWIFT_PROTOCOL("_TtP11iOS_DCA_SDK18DCAManagerDelegate_")
@protocol DCAManagerDelegate <NSObject>
@optional
- (void)onNeedLogin;
@end
@class TVShowModel;
@class TVBatchListModel;
@class TVDetailModel;
@class PBRecommendTypeModel;
@class PBRecommendListModel;
@class PBRecommendDetailModel;
@class PBReadRecordModel;
@class PBReadRecordDetailModel;
enum ResCommType : NSInteger;
@class ResAlbumModel;
@class ResMusicModel;
@class ResNewsCateListModel;
@class ResNewsListModel;
@class ResRadioCateListModel;
@class ResRadioListModel;
@class LetingCateModel;
@class GetVideoRequest;
@class LetingVideoModel;
@class SearchVideoRequest;
@class FeedBack;
@class ResIdaddyCatesModel;
@class IDaddyAlbumRequest;
@class IDaddyTrackRequest;
@class IDaddySearchAlbumRequest;
@class IDaddySearchTrackRequest;
SWIFT_CLASS("_TtC11iOS_DCA_SDK23DCAMediaResourceManager")
@interface DCAMediaResourceManager : NSObject
- (void)getBatchListWithType:(NSString * _Nonnull)type page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ChildBatchListModel *> * _Nullable))callBack;
- (void)getBatchDetailWithType:(NSString * _Nonnull)type moduleID:(NSString * _Nonnull)moduleID page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<ChildBatchDetailModel *> * _Nullable))callBack;
- (void)getAlbumBrowseWithBatchModel:(ChildBatchListModel * _Nonnull)batchModel albumModel:(ChildBatchDetailModel * _Nonnull)albumModel page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<ChildAlbumBrowseModel *> * _Nullable))callBack;
- (void)getSearchDataWithQ:(NSString * _Nonnull)q page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<ChildAlbumBrowseModel *> * _Nullable))callBack;
- (void)getTVShowListWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<TVShowModel *> * _Nullable))callBack;
- (void)getTVBatchListWithType:(NSString * _Nonnull)type callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<TVBatchListModel *> * _Nullable))callBack;
- (void)getTVBatchDetailWithTag:(NSString * _Nonnull)tag type:(NSString * _Nonnull)type page:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<TVDetailModel *> * _Nullable))callBack;
- (void)getCompleteSystemRecommendWithAge:(NSString * _Nonnull)age callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<PBRecommendTypeModel *> * _Nullable))callBack;
- (void)getRecommendDetailedWithRecommendId:(NSString * _Nonnull)recommendId type:(NSInteger)type callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<PBRecommendListModel *> * _Nullable))callBack;
- (void)getMiniProgramBookInfoWithRecommendId:(NSString * _Nonnull)recommendId picBookId:(NSString * _Nonnull)picBookId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, PBRecommendDetailModel * _Nullable))callBack;
- (void)getUserReadRcordWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, PBReadRecordModel * _Nullable))callBack;
- (void)getUserReadDetailWithDateStr:(NSString * _Nonnull)dateStr callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, PBReadRecordDetailModel * _Nullable))callBack;
- (void)savePicBookReadRecordWithModel:(PBRecommendListModel * _Nonnull)model beginTimeStr:(NSString * _Nonnull)beginTimeStr endTimeStr:(NSString * _Nonnull)endTimeStr pageTimeList:(NSArray * _Nonnull)pageTimeList callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)getCommResAlbumsWithType:(enum ResCommType)type page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResAlbumModel *> * _Nullable))callBack;
- (void)getCommResTracksWithType:(enum ResCommType)type albumId:(NSString * _Nonnull)albumId page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResMusicModel *> * _Nullable))callBack;
- (void)getNewsCategoryWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResNewsCateListModel *> * _Nullable))callBack;
- (void)getNewsWithCatId:(NSString * _Nonnull)catId pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResNewsListModel *> * _Nullable))callBack;
- (void)getRadioCategoryWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResRadioCateListModel *> * _Nullable))callBack;
- (void)getRadioWithCatId:(NSString * _Nonnull)catId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResRadioListModel *> * _Nullable))callBack;
- (void)searchAlbumsWithTitle:(NSString * _Nonnull)title page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResAlbumModel *> * _Nullable))callBack;
- (void)getTracksBySearchAlbumIdWithAlbumId:(NSString * _Nonnull)albumId page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResMusicModel *> * _Nullable))callBack;
- (void)searchTracksWithTitle:(NSString * _Nonnull)title page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResMusicModel *> * _Nullable))callBack;
- (void)searchStoryWithTitle:(NSString * _Nonnull)title tags:(NSString * _Nonnull)tags page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResMusicModel *> * _Nullable))callBack;
- (void)getLetingCatalogsWithUid:(NSString * _Nonnull)uid productId:(NSString * _Nonnull)productId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<LetingCateModel *> * _Nullable))callBack;
- (void)getLetingVideoByCatalogIdWithRequest:(GetVideoRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<LetingVideoModel *> * _Nullable))callBack;
- (void)searchLetingVideoWithRequest:(SearchVideoRequest * _Nonnull)request callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<LetingVideoModel *> * _Nullable))callBack;
- (void)letingFeedbackWithUid:(NSString * _Nonnull)uid productId:(NSString * _Nonnull)productId feedback:(FeedBack * _Nonnull)feedback callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getIDaddyCategoryWithProductId:(NSString * _Nonnull)productId deviceId:(NSString * _Nonnull)deviceId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResIdaddyCatesModel *> * _Nullable))callBack;
- (void)getIDaddyAlbumWithAlbumRequest:(IDaddyAlbumRequest * _Nonnull)albumRequest callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResAlbumModel *> * _Nullable))callBack;
- (void)getIDaddyTrackWithTrackRequest:(IDaddyTrackRequest * _Nonnull)trackRequest callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResMusicModel *> * _Nullable))callBack;
- (void)searchIDaddyAlbumWithSearchRequest:(IDaddySearchAlbumRequest * _Nonnull)searchRequest callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResAlbumModel *> * _Nullable))callBack;
- (void)searchIDaddyTrackWithSearchRequest:(IDaddySearchTrackRequest * _Nonnull)searchRequest callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<ResMusicModel *> * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, DCASDKEBTYPE, open) {
  DCASDKEBTYPESMARTHOME = 0,
  DCASDKEBTYPESMARTHOME_DEVICE_LIST = 1,
  DCASDKEBTYPEDIALOG_MESSGAE = 2,
  DCASDKEBTYPESKILL_CENTER = 3,
  DCASDKEBTYPEPRODUCT_SKILL = 4,
  DCASDKEBTYPESEARCH_SKILL = 5,
  DCASDKEBTYPECOMMON_PAGE = 6,
  DCASDKEBTYPESKILL_INSTALL = 7,
  DCASDKEBTYPECUSTOME_DIALOG = 8,
  DCASDKEBTYPECUSTOME_DIALOGCREATE = 9,
  DCASDKEBTYPESKILL_STORE = 10,
};
@class DCAWebViewInfo;
@protocol DCASDKWebViewControllerDelegate;
@class NSBundle;
SWIFT_CLASS("_TtC11iOS_DCA_SDK23DCASDKWebViewController")
@interface DCASDKWebViewController : UIViewController
@property (nonatomic, strong) DCAWebViewInfo * _Nullable webInfo;
@property (nonatomic, weak) id <DCASDKWebViewControllerDelegate> _Nullable delegate;
- (void)viewDidLoad;
- (void)observeValueForKeyPath:(NSString * _Nullable)keyPath ofObject:(id _Nullable)object change:(NSDictionary<NSKeyValueChangeKey, id> * _Nullable)change context:(void * _Nullable)context;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end
@class WKUserContentController;
@class WKScriptMessage;
@interface DCASDKWebViewController (SWIFT_EXTENSION(iOS_DCA_SDK)) <WKScriptMessageHandler>
- (void)userContentController:(WKUserContentController * _Nonnull)userContentController didReceiveScriptMessage:(WKScriptMessage * _Nonnull)message;
@end
@class WKWebView;
@class WKNavigationAction;
@class WKNavigation;
@interface DCASDKWebViewController (SWIFT_EXTENSION(iOS_DCA_SDK)) <UIWebViewDelegate, WKNavigationDelegate>
- (void)webView:(WKWebView * _Nonnull)webView decidePolicyForNavigationAction:(WKNavigationAction * _Nonnull)navigationAction decisionHandler:(void (^ _Nonnull)(WKNavigationActionPolicy))decisionHandler;
- (void)webView:(WKWebView * _Nonnull)webView didStartProvisionalNavigation:(WKNavigation * _Null_unspecified)navigation;
- (void)webView:(WKWebView * _Nonnull)webView didFinishNavigation:(WKNavigation * _Null_unspecified)navigation;
- (void)webView:(WKWebView * _Nonnull)webView didFailNavigation:(WKNavigation * _Null_unspecified)navigation withError:(NSError * _Nonnull)error;
@end
@interface DCASDKWebViewController (SWIFT_EXTENSION(iOS_DCA_SDK))
- (void)loadH5;
- (void)loadH5WithUrlWithUrlStr:(NSString * _Nonnull)urlStr;
- (void)setAccessTokenWithToken:(NSString * _Nonnull)token;
- (void)registerThemeWithTheme:(NSString * _Nonnull)theme;
- (BOOL)webViewCanGoBack SWIFT_WARN_UNUSED_RESULT;
- (void)webViewBack;
- (void)setWebViewFrameWithFrame:(CGRect)frame;
@end
SWIFT_PROTOCOL("_TtP11iOS_DCA_SDK31DCASDKWebViewControllerDelegate_")
@protocol DCASDKWebViewControllerDelegate <NSObject>
@optional
- (void)quitDCASDKWebViewViewController;
- (void)onTitleChangeWithTitle:(NSString * _Nonnull)title;
- (void)webViewHasDeviceWithParam:(BOOL)param;
- (void)webViewOpenNewTabWithParam:(NSString * _Nonnull)param;
@end
@class SkillDetailRequest;
SWIFT_CLASS("_TtC11iOS_DCA_SDK15DCASkillManager")
@interface DCASkillManager : NSObject
- (void)querySkillListByProductVersionWithProductId:(NSString * _Nonnull)productId productVersion:(NSString * _Nonnull)productVersion callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)querySkillListByAliasKeyWithProductId:(NSString * _Nonnull)productId aliasKey:(NSString * _Nonnull)aliasKey callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)querySkillDetailWithSkillId:(NSString * _Nonnull)skillId skillVersion:(NSString * _Nonnull)skillVersion callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)querySkillDetailsWithList:(NSArray<SkillDetailRequest *> * _Nonnull)list callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class SmartHomeTokenRequest;
@class SkillRequest;
SWIFT_CLASS("_TtC11iOS_DCA_SDK19DCASmartHomeManager")
@interface DCASmartHomeManager : NSObject
- (void)querySmartHomeSkillWithCallBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)querySmartHomeAccountStatusWithSkillId:(NSString * _Nonnull)skillId skillVersion:(NSString * _Nonnull)skillVersion productId:(NSString * _Nonnull)productId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)querySmartHomeApplianceWithSkillId:(NSString * _Nonnull)skillId skillVersion:(NSString * _Nonnull)skillVersion productId:(NSString * _Nonnull)productId group:(NSString * _Nonnull)group callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)queryAllSmartHomeApplianceWithProductId:(NSString * _Nonnull)productId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)queryAppliancePositionWithApplianceId:(NSString * _Nonnull)applianceId skillId:(NSString * _Nonnull)skillId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)updateApplianceCustomPositionWithApplianceId:(NSString * _Nonnull)applianceId skillId:(NSString * _Nonnull)skillId productId:(NSString * _Nonnull)productId position:(NSString * _Nonnull)position group:(NSString * _Nonnull)group callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)updateApplianceAliasWithApplianceId:(NSString * _Nonnull)applianceId skillId:(NSString * _Nonnull)skillId productId:(NSString * _Nonnull)productId alias:(NSString * _Nonnull)alias group:(NSString * _Nonnull)group callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)applianceAliasSyncWithProductId:(NSString * _Nonnull)productId group:(NSString * _Nonnull)group iotSkillId:(NSString * _Nonnull)iotSkillId skillList:(NSArray<ApplianceAliasSyncModel *> * _Nullable)skillList callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)updateSmartHomeTokenInfoWithSmartHomeTokenRequest:(SmartHomeTokenRequest * _Nonnull)smartHomeTokenRequest callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)bindSmartHomeAccountWithUrl:(NSString * _Nonnull)url productId:(NSString * _Nonnull)productId skillVersion:(NSString * _Nonnull)skillVersion callBack:(void (^ _Nonnull)(BOOL))callBack;
- (void)unbindSmartHomeAccountWithSkillId:(NSString * _Nonnull)skillId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)getSmartHomeDetailWithSkillId:(NSString * _Nonnull)skillId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)getSupportDeviceWithSkillId:(NSString * _Nonnull)skillId page:(NSInteger)page pageSize:(NSInteger)pageSize callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)batchQuerySmartHomeAccountStatusWithProductId:(NSString * _Nonnull)productId list:(NSArray<SkillRequest *> * _Nonnull)list callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)batchQueryAppliancePositionWithProductId:(NSString * _Nonnull)productId list:(NSArray<BatchPosRequest *> * _Nonnull)list callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
enum SonicNetworkState : NSInteger;
SWIFT_CLASS("_TtC11iOS_DCA_SDK18DCASonicNetManager")
@interface DCASonicNetManager : NSObject
- (void)initSonicNetwork SWIFT_METHOD_FAMILY(none);
- (void)startSonicNetworkWithWifiStr:(NSString * _Nonnull)wifiStr pwd:(NSString * _Nonnull)pwd sonicNetResult:(void (^ _Nullable)(enum SonicNetworkState, NSString * _Nonnull, NSDictionary * _Nonnull))sonicNetResult;
- (void)stopSonicNetwork;
- (void)deallocSonicNetwork;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class UserInfoModel;
enum GENDER : NSInteger;
@class FamilyAddressBookListModel;
@class EquipDeviceListModel;
@class QaInitModel;
@class QaInfoModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK14DCAUserManager")
@interface DCAUserManager : NSObject
- (void)getUserInfoWithUserId:(NSString * _Nonnull)userId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, UserInfoModel * _Nullable))callBack;
- (void)registerFirstWithNickname:(NSString * _Nonnull)nickname phone:(NSString * _Nonnull)phone gender:(enum GENDER)gender headUrl:(NSString * _Nonnull)headUrl callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, UserInfoModel * _Nullable))callBack;
- (void)setHeadImgWithData:(NSData * _Nonnull)data callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)setNicknameWithNickname:(NSString * _Nonnull)nickname callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)setGenderWithGender:(enum GENDER)gender callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getBabyDataWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, BabyDataModel * _Nullable))callBack;
- (void)saveBabyDataWithBorn:(NSString * _Nonnull)born relation:(NSString * _Nonnull)relation gender:(enum GENDER)gender babyInfoId:(NSString * _Nonnull)babyInfoId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)addModelInCollectionWithModel:(ChildAlbumBrowseModel * _Nonnull)model callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)deleteModelInCollectionWithModel:(ChildAlbumBrowseModel * _Nonnull)model callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)getCollectionListWithPage:(NSInteger)page count:(NSInteger)count callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<ChildAlbumBrowseModel *> * _Nullable))callBack;
- (void)getContactsWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSArray<FamilyAddressBookListModel *> * _Nullable))callBack;
- (void)addContactWithNickname:(NSString * _Nonnull)nickname relation:(NSString * _Nonnull)relation phone:(NSString * _Nonnull)phone callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)getUserQRCodeWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nullable))callBack;
- (void)addQRContactWithNickname:(NSString * _Nonnull)nickname relation:(NSString * _Nonnull)relation userId:(NSString * _Nonnull)userId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)getNewFriendsWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<FamilyAddressBookListModel *> * _Nullable))callBack;
- (void)agreeContactRequestWithModel:(FamilyAddressBookListModel * _Nonnull)model callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)editContactWithNickname:(NSString * _Nonnull)nickname relation:(NSString * _Nonnull)relation editId:(NSString * _Nonnull)editId fbId:(NSString * _Nonnull)fbId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)deleteContactWithFbId:(NSString * _Nonnull)fbId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)getFriendDeviceListWithUserID:(NSString * _Nonnull)userID callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<EquipDeviceListModel *> * _Nullable))callBack;
- (void)initQaWithCallBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, QaInitModel * _Nullable))callBack SWIFT_METHOD_FAMILY(none);
- (void)queryQaInfoWithQaInitModel:(QaInitModel * _Nonnull)qaInitModel callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<QaInfoModel *> * _Nullable))callBack;
- (void)queryQaInfoDetailWithKid:(NSString * _Nonnull)kid callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, QaInfoModel * _Nullable))callBack;
- (void)addQaInfoWithQaInitModel:(QaInitModel * _Nonnull)qaInitModel questionNameArr:(NSArray * _Nonnull)questionNameArr answerNameArr:(NSArray * _Nonnull)answerNameArr callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, QaInfoModel * _Nullable))callBack;
- (void)deleteQaInfoWithKid:(NSString * _Nonnull)kid callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (void)updateQaInfoWithQaInfoModel:(QaInfoModel * _Nonnull)qaInfoModel callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, QaInfoModel * _Nullable))callBack;
- (void)effectiveQaOperationWithQaInitModel:(QaInitModel * _Nonnull)qaInitModel callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class VoiceCopyTextModel;
@class UploadRequestModel;
@class TrainRequestModel;
@class DeleteRequestModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK19DCAVoiceCopyManager")
@interface DCAVoiceCopyManager : NSObject
- (void)getTextWithProductId:(NSString * _Nonnull)productId callBack:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull, NSArray<VoiceCopyTextModel *> * _Nullable))callBack;
- (void)uploadWithRequest:(UploadRequestModel * _Nonnull)request callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)trainingWithRequest:(TrainRequestModel * _Nonnull)request callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)queryTaskWithProductId:(NSString * _Nonnull)productId callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)deleteToneWithRequest:(DeleteRequestModel * _Nonnull)request callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (void)updateCustomInfoWithProductId:(NSString * _Nonnull)productId taskId:(NSString * _Nonnull)taskId customInfo:(NSString * _Nonnull)customInfo callBack:(void (^ _Nonnull)(NSDictionary * _Nullable))callBack;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class UIColor;
SWIFT_CLASS("_TtC11iOS_DCA_SDK14DCAWebViewInfo")
@interface DCAWebViewInfo : NSObject
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSString * _Nullable productVersion;
@property (nonatomic) enum DCASDKEBTYPE webType;
@property (nonatomic, copy) NSString * _Nullable aliasKey;
@property (nonatomic, copy) NSString * _Nullable manufacture;
@property (nonatomic) BOOL isHiddenTitle;
@property (nonatomic) BOOL isUseCustomWebViewFrame;
@property (nonatomic) CGRect webViewFrame;
@property (nonatomic, copy) NSString * _Nullable searchContent;
@property (nonatomic, copy) NSString * _Nullable urlContent;
@property (nonatomic, copy) NSString * _Nullable theme;
@property (nonatomic, strong) UIColor * _Nullable themeColor;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18DeleteRequestModel")
@interface DeleteRequestModel : NSObject
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable taskId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22DeviceConfigScopeModel")
@interface DeviceConfigScopeModel : NSObject
@property (nonatomic) NSInteger bind_ble;
@property (nonatomic) NSInteger bind_sound;
@property (nonatomic) NSInteger bind_wifiap;
@property (nonatomic) NSInteger bind_scan;
@property (nonatomic) NSInteger res_children;
@property (nonatomic) NSInteger res_fm;
@property (nonatomic) NSInteger res_book;
@property (nonatomic) NSInteger res_shows;
@property (nonatomic) NSInteger res_tv_play;
@property (nonatomic) NSInteger res_movie;
@property (nonatomic) NSInteger setting_wifi_rest;
@property (nonatomic) NSInteger setting_ble;
@property (nonatomic) NSInteger setting_sound;
@property (nonatomic) NSInteger setting_dev_name;
@property (nonatomic) NSInteger setting_unbind;
@property (nonatomic) NSInteger setting_reset;
@property (nonatomic) NSInteger setting_reconnect;
@property (nonatomic) NSInteger dev_talklog;
@property (nonatomic) NSInteger dev_im;
@property (nonatomic) NSInteger dev_contact_video;
@property (nonatomic) NSInteger dev_contact_voice;
@property (nonatomic) NSInteger dev_contact_chat;
@property (nonatomic) NSInteger dev_family_list;
@property (nonatomic) NSInteger dev_custom_qa;
@property (nonatomic) NSInteger dev_custom_command;
@property (nonatomic) NSInteger dev_remind;
@property (nonatomic) NSInteger dev_clock;
@property (nonatomic) NSInteger device_info;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15DeviceInfoModel")
@interface DeviceInfoModel : NSObject
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable appId;
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic, copy) NSString * _Nullable platform;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK24DeviceProductConfigModel")
@interface DeviceProductConfigModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable subtitle;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, strong) DeviceConfigScopeModel * _Nullable scope;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22EquCallRecordListModel")
@interface EquCallRecordListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable recordId;
@property (nonatomic, copy) NSString * _Nullable srcId;
@property (nonatomic, copy) NSString * _Nullable targetId;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic) NSInteger talkTime;
@property (nonatomic) NSInteger state;
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic) BOOL isRead;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class OdmConfigModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK23EquSmartDeviceListModel")
@interface EquSmartDeviceListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable productType;
@property (nonatomic, copy) NSString * _Nullable productTypeCode;
@property (nonatomic, copy) NSString * _Nullable image;
@property (nonatomic, copy) NSString * _Nullable deviceName;
@property (nonatomic, copy) NSString * _Nullable appId;
@property (nonatomic, copy) NSString * _Nullable secret;
@property (nonatomic, copy) NSString * _Nullable company;
@property (nonatomic) NSInteger hide;
@property (nonatomic, strong) DeviceProductConfigModel * _Nullable config;
@property (nonatomic, strong) OdmConfigModel * _Nullable odmConfig;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15EquipAlarmModel")
@interface EquipAlarmModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable alarmId;
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSString * _Nullable date;
@property (nonatomic, copy) NSString * _Nullable time;
@property (nonatomic, copy) NSString * _Nullable timestamp;
@property (nonatomic, copy) NSString * _Nullable event;
@property (nonatomic, copy) NSString * _Nullable repeatS;
@property (nonatomic) BOOL isSelected;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20EquipDeviceInfoModel")
@interface EquipDeviceInfoModel : NSObject <NSCoding, YYModel>
@property (nonatomic) float volume;
@property (nonatomic) BOOL bluetooth;
@property (nonatomic) BOOL hasBattery;
@property (nonatomic) BOOL wifiState;
@property (nonatomic, copy) NSString * _Nullable wifiSsid;
@property (nonatomic) NSInteger battery;
@property (nonatomic) NSInteger playlistCount;
@property (nonatomic, copy) NSString * _Nullable version;
@property (nonatomic) NSInteger wakeUp;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20EquipDeviceListModel")
@interface EquipDeviceListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable deviceType;
@property (nonatomic, copy) NSString * _Nullable deviceAlias;
@property (nonatomic, copy) NSString * _Nullable deviceName;
@property (nonatomic, strong) DeviceInfoModel * _Nullable deviceInfo;
@property (nonatomic, copy) NSString * _Nullable apiKey;
@property (nonatomic) BOOL isDefault;
@property (nonatomic, copy) NSString * _Nullable accId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16EquipRemindModel")
@interface EquipRemindModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic, copy) NSString * _Nullable date;
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSString * _Nullable event;
@property (nonatomic, copy) NSString * _Nullable remindId;
@property (nonatomic, copy) NSString * _Nullable object;
@property (nonatomic, copy) NSString * _Nullable repeatS;
@property (nonatomic, copy) NSString * _Nullable time;
@property (nonatomic, copy) NSString * _Nullable timestamp;
@property (nonatomic, copy) NSString * _Nullable vid;
@property (nonatomic) BOOL isSelected;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22EquipVoiceMessageModel")
@interface EquipVoiceMessageModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger voiceId;
@property (nonatomic, copy) NSString * _Nullable senderId;
@property (nonatomic, copy) NSString * _Nullable senderAvatarUrl;
@property (nonatomic, copy) NSString * _Nullable senderName;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable text;
@property (nonatomic, copy) NSString * _Nullable voiceUrl;
@property (nonatomic) NSInteger duration;
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic) NSInteger readed;
@property (nonatomic, copy) NSString * _Nullable content;
@property (nonatomic) NSInteger groupType;
@property (nonatomic) BOOL isPlayAnimation;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
typedef SWIFT_ENUM(NSInteger, EvnType, open) {
  EvnTypeDEV = 1,
  EvnTypeTEST = 2,
  EvnTypeBETA = 3,
  EvnTypeDUI = 4,
};
@class FBExt;
SWIFT_CLASS("_TtC11iOS_DCA_SDK6FBData")
@interface FBData : NSObject
@property (nonatomic, copy) NSString * _Nonnull sid;
@property (nonatomic, copy) NSString * _Nonnull category;
@property (nonatomic) NSInteger duration;
@property (nonatomic, strong) NSDictionary * _Nonnull ext;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (NSDictionary * _Nonnull)initializWithRExt:(FBExt * _Nullable)rExt SWIFT_WARN_UNUSED_RESULT;
- (NSDictionary * _Nonnull)getDataDic SWIFT_WARN_UNUSED_RESULT;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK5FBExt")
@interface FBExt : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable district;
@property (nonatomic, copy) NSString * _Nullable city;
@property (nonatomic, copy) NSString * _Nullable province;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18FGCDetailListModel")
@interface FGCDetailListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable voiceUrl;
@property (nonatomic, copy) NSString * _Nullable targetId;
@property (nonatomic) NSInteger fgcId;
@property (nonatomic, copy) NSString * _Nullable srcId;
@property (nonatomic) NSInteger duration;
@property (nonatomic) NSInteger groupId;
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic) NSInteger groupTalk;
@property (nonatomic, strong) UserInfoModel * _Nullable srcUser;
@property (nonatomic) BOOL isPlayAnimation;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK26FamilyAddressBookListModel")
@interface FamilyAddressBookListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic, copy) NSString * _Nullable ownerId;
@property (nonatomic, copy) NSString * _Nullable relation;
@property (nonatomic, copy) NSString * _Nullable fbId;
@property (nonatomic, copy) NSString * _Nullable nickname;
@property (nonatomic, copy) NSString * _Nullable state;
@property (nonatomic, copy) NSString * _Nullable phone;
@property (nonatomic, copy) NSString * _Nullable head;
@property (nonatomic) BOOL isSelected;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK24FamilyGroupChatListModel")
@interface FamilyGroupChatListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic) NSInteger chatId;
@property (nonatomic, copy) NSString * _Nullable ownerId;
@property (nonatomic) NSInteger number;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK27FamilyRelationshipListModel")
@interface FamilyRelationshipListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable frId;
@property (nonatomic, copy) NSString * _Nullable name;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK8FeedBack")
@interface FeedBack : NSObject
@property (nonatomic, copy) NSString * _Nonnull action_type;
@property (nonatomic, copy) NSString * _Nonnull timestamp;
@property (nonatomic, copy) NSString * _Nonnull imei;
@property (nonatomic, copy) NSString * _Nonnull os;
@property (nonatomic, copy) NSString * _Nonnull client_ip;
@property (nonatomic, copy) NSString * _Nonnull brand;
@property (nonatomic, copy) NSString * _Nonnull clarity;
@property (nonatomic, copy) NSString * _Nonnull log_id;
@property (nonatomic, strong) NSArray * _Nullable data;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, GENDER, open) {
  GENDERMALE = 1,
  GENDERFAMALE = 2,
  GENDERUNKNOWN = 3,
};
enum SMSCODETYPE : NSInteger;
SWIFT_CLASS("_TtC11iOS_DCA_SDK19GetCodeRequestModel")
@interface GetCodeRequestModel : NSObject
@property (nonatomic, copy) NSString * _Nullable userName;
@property (nonatomic) enum SMSCODETYPE type;
@property (nonatomic, copy) NSString * _Nonnull channel;
@property (nonatomic, copy) NSString * _Nonnull signName;
@property (nonatomic, copy) NSString * _Nonnull templateCode;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15GetVideoRequest")
@interface GetVideoRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull catalogId;
@property (nonatomic, copy) NSString * _Nonnull uid;
@property (nonatomic, copy) NSString * _Nonnull productId;
@property (nonatomic, copy) NSString * _Nonnull province;
@property (nonatomic, copy) NSString * _Nonnull city;
@property (nonatomic, copy) NSString * _Nonnull keyword;
@property (nonatomic) NSInteger distinct;
@property (nonatomic) NSInteger size;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK14HiFiAlbumModel")
@interface HiFiAlbumModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable cn_name;
@property (nonatomic, copy) NSString * _Nullable smallimg;
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic, copy) NSString * _Nullable artist;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable recordingTime;
@property (nonatomic, copy) NSString * _Nullable musicListId;
@property (nonatomic, copy) NSString * _Nullable introduce;
@property (nonatomic, copy) NSString * _Nullable smallImg;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16HiFiHotListModel")
@interface HiFiHotListModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable bigimg;
@property (nonatomic, copy) NSString * _Nullable smallimg;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic) NSInteger trackstotal;
@property (nonatomic, copy) NSString * _Nullable packId;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18HiFiMenuAlbumModel")
@interface HiFiMenuAlbumModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable imgurl;
@property (nonatomic, copy) NSString * _Nullable artistname;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic, copy) NSString * _Nullable cn_name;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK24HiFiMenuTypeContentModel")
@interface HiFiMenuTypeContentModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable imgurl;
@property (nonatomic, copy) NSString * _Nullable artistname;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable albumId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK17HiFiMenuTypeModel")
@interface HiFiMenuTypeModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable menuid;
@property (nonatomic, copy) NSString * _Nullable menuname;
@property (nonatomic, copy) NSString * _Nullable image;
@property (nonatomic, copy) NSArray<HiFiMenuTypeContentModel *> * _Nullable menuContent;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class HiFiSliderContentModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK14HiFiMenusModel")
@interface HiFiMenusModel : HiFiBaseModel
@property (nonatomic) NSInteger tagid;
@property (nonatomic, copy) NSString * _Nullable sliderid;
@property (nonatomic, copy) NSString * _Nullable menuid;
@property (nonatomic) NSInteger displayorder;
@property (nonatomic) NSInteger hasmore;
@property (nonatomic, copy) NSString * _Nullable pattern;
@property (nonatomic) NSInteger isnew;
@property (nonatomic, copy) NSString * _Nullable menutype;
@property (nonatomic, copy) NSString * _Nullable menuname;
@property (nonatomic, copy) NSString * _Nullable moretype;
@property (nonatomic, copy) NSArray<HiFiSliderContentModel *> * _Nullable sliderContent;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
@class HiFiMusicModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK17HiFiMusicArrModel")
@interface HiFiMusicArrModel : HiFiBaseModel
@property (nonatomic, copy) NSArray<HiFiMusicModel *> * _Nullable musics;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20HiFiMusicDetailModel")
@interface HiFiMusicDetailModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable introduction;
@property (nonatomic, copy) NSString * _Nullable companyname;
@property (nonatomic, copy) NSString * _Nullable productid;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable publishtime;
@property (nonatomic, copy) NSString * _Nullable bigimg;
@property (nonatomic, copy) NSString * _Nullable sliderid;
@property (nonatomic, copy) NSString * _Nullable size;
@property (nonatomic, copy) NSString * _Nullable cn_name;
@property (nonatomic) NSInteger musiccount;
@property (nonatomic, copy) NSString * _Nullable smallimg;
@property (nonatomic) NSInteger prize;
@property (nonatomic, copy) NSString * _Nullable reference;
@property (nonatomic, copy) NSString * _Nullable technology;
@property (nonatomic) NSInteger isfullflac;
@property (nonatomic, copy) NSString * _Nullable musicId;
@property (nonatomic, copy) NSString * _Nullable language;
@property (nonatomic, copy) NSString * _Nullable artists;
@property (nonatomic, copy) NSArray<HiFiMusicArrModel *> * _Nullable disks;
@property (nonatomic, copy) NSArray<HiFiMusicModel *> * _Nullable musicListItems;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK14HiFiMusicModel")
@interface HiFiMusicModel : HiFiBaseModel
@property (nonatomic) NSInteger price;
@property (nonatomic, copy) NSString * _Nullable productid;
@property (nonatomic, copy) NSString * _Nullable albumid;
@property (nonatomic, copy) NSString * _Nullable artistid;
@property (nonatomic, copy) NSString * _Nullable musicId;
@property (nonatomic, copy) NSString * _Nullable artist;
@property (nonatomic, copy) NSString * _Nullable totaltime;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic) NSInteger trackno;
@property (nonatomic, copy) NSString * _Nullable albumimg;
@property (nonatomic, copy) NSString * _Nullable albumname;
@property (nonatomic, copy) NSArray<AudioFileListModel *> * _Nullable audioFileList;
@property (nonatomic, copy) NSString * _Nullable listenurl;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22HiFiSearchContentModel")
@interface HiFiSearchContentModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable Imgurl;
@property (nonatomic, copy) NSString * _Nullable albumname;
@property (nonatomic, copy) NSString * _Nullable artistname;
@property (nonatomic, copy) NSString * _Nullable contentid;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic) NSInteger type;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15HiFiSearchModel")
@interface HiFiSearchModel : NSObject
@property (nonatomic, copy) NSString * _Nullable Imgurl;
@property (nonatomic, copy) NSString * _Nullable albumname;
@property (nonatomic, copy) NSString * _Nullable artistname;
@property (nonatomic, copy) NSString * _Nullable contentid;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic) NSInteger type;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, HiFiSearchType, open) {
  HiFiSearchTypeALL = 0,
  HiFiSearchTypeALBUM = 1,
  HiFiSearchTypeSONG = 5,
  HiFiSearchTypeARTIST = 10,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK22HiFiSliderContentModel")
@interface HiFiSliderContentModel : HiFiBaseModel
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable contentTitle;
@property (nonatomic, copy) NSString * _Nullable albumName;
@property (nonatomic, copy) NSString * _Nullable ImgUrl;
@property (nonatomic) NSInteger displayOrder;
@property (nonatomic, copy) NSString * _Nullable artistName;
@property (nonatomic, copy) NSString * _Nullable linkUrl;
@property (nonatomic, copy) NSString * _Nullable contentId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18IDaddyAlbumRequest")
@interface IDaddyAlbumRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull deviceId;
@property (nonatomic, copy) NSString * _Nonnull productId;
@property (nonatomic, copy) NSString * _Nonnull categoryId;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger limit;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK24IDaddySearchAlbumRequest")
@interface IDaddySearchAlbumRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull deviceId;
@property (nonatomic, copy) NSString * _Nonnull productId;
@property (nonatomic, copy) NSString * _Nonnull keyword;
@property (nonatomic) NSInteger matching;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger limit;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK24IDaddySearchTrackRequest")
@interface IDaddySearchTrackRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull deviceId;
@property (nonatomic, copy) NSString * _Nonnull productId;
@property (nonatomic, copy) NSString * _Nonnull keyword;
@property (nonatomic) NSInteger matching;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger limit;
@property (nonatomic, copy) NSString * _Nonnull cat_ids;
@property (nonatomic) NSInteger scoped;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18IDaddyTrackRequest")
@interface IDaddyTrackRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull deviceId;
@property (nonatomic, copy) NSString * _Nonnull productId;
@property (nonatomic, copy) NSString * _Nonnull albumId;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger limit;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK19InitPasswordRequest")
@interface InitPasswordRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable userName;
@property (nonatomic, copy) NSString * _Nullable password;
@property (nonatomic, copy) NSString * _Nullable pwCredential;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16InstructionModel")
@interface InstructionModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable instructionId;
@property (nonatomic, strong) NSArray * _Nullable sentences;
@property (nonatomic, strong) NSArray * _Nullable commands;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15LetingCateModel")
@interface LetingCateModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable catalog_id;
@property (nonatomic, copy) NSString * _Nullable catalog_name;
@property (nonatomic, copy) NSString * _Nullable user_subscribe;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16LetingVideoModel")
@interface LetingVideoModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable audio;
@property (nonatomic, copy) NSString * _Nullable catalog_id;
@property (nonatomic, copy) NSString * _Nullable catalog_name;
@property (nonatomic, copy) NSString * _Nullable content;
@property (nonatomic) NSInteger duration;
@property (nonatomic, copy) NSString * _Nullable hms;
@property (nonatomic, copy) NSString * _Nullable hot;
@property (nonatomic, copy) NSString * _Nullable human_time;
@property (nonatomic, copy) NSString * _Nullable image;
@property (nonatomic, copy) NSString * _Nullable pub_time;
@property (nonatomic, copy) NSString * _Nullable sid;
@property (nonatomic, copy) NSString * _Nullable source;
@property (nonatomic, copy) NSString * _Nullable tags;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable updated_at;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16LinkPhoneRequest")
@interface LinkPhoneRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable unionId;
@property (nonatomic, copy) NSString * _Nullable openId;
@property (nonatomic, copy) NSString * _Nullable nickName;
@property (nonatomic, copy) NSString * _Nullable headImgUrl;
@property (nonatomic, copy) NSString * _Nonnull channel;
@property (nonatomic, copy) NSString * _Nullable mobile;
@property (nonatomic, copy) NSString * _Nullable smsCode;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK12LoginRequest")
@interface LoginRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable userName;
@property (nonatomic, copy) NSString * _Nullable password;
@property (nonatomic, copy) NSString * _Nullable smsCode;
@property (nonatomic, copy) NSString * _Nonnull channel;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15NewsSearchModel")
@interface NewsSearchModel : NSObject
@property (nonatomic, copy) NSString * _Nullable audio;
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic) double duration;
@property (nonatomic, copy) NSString * _Nullable human_time;
@property (nonatomic, copy) NSString * _Nullable image;
@property (nonatomic, copy) NSString * _Nullable sid;
@property (nonatomic, copy) NSString * _Nullable source;
@property (nonatomic, copy) NSString * _Nullable title;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18ODMFunctiongsModel")
@interface ODMFunctiongsModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger funId;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable icon;
@property (nonatomic) NSInteger type;
@property (nonatomic, copy) NSString * _Nullable url;
@property (nonatomic, copy) NSString * _Nullable text;
@property (nonatomic) NSInteger page;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK21ODMPagesCategoryModel")
@interface ODMPagesCategoryModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger catId;
@property (nonatomic, copy) NSString * _Nullable name;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16ODMSettingsModel")
@interface ODMSettingsModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger setId;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable icon;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class PersonalityModel;
@class PagesModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK14OdmConfigModel")
@interface OdmConfigModel : NSObject <NSCoding, YYModel>
@property (nonatomic, strong) PersonalityModel * _Nullable personality;
@property (nonatomic, copy) NSArray<PagesModel *> * _Nullable pages;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16OtherSearchModel")
@interface OtherSearchModel : NSObject
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic, copy) NSString * _Nullable albumTitle;
@property (nonatomic, copy) NSString * _Nullable artist;
@property (nonatomic, copy) NSString * _Nullable author;
@property (nonatomic, copy) NSString * _Nullable coverUrlLarge;
@property (nonatomic, copy) NSString * _Nullable coverUrlMiddle;
@property (nonatomic, copy) NSString * _Nullable coverUrlSmall;
@property (nonatomic) double duration;
@property (nonatomic, copy) NSString * _Nullable episode;
@property (nonatomic, copy) NSString * _Nullable playUrl64;
@property (nonatomic, copy) NSString * _Nullable source;
@property (nonatomic, copy) NSString * _Nullable sourceId;
@property (nonatomic, copy) NSString * _Nullable trackIntro;
@property (nonatomic, copy) NSString * _Nullable trackTags;
@property (nonatomic, copy) NSString * _Nullable trackTitle;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable musicId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class PBRecordListModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK19PBDetailedListModel")
@interface PBDetailedListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable dataStr;
@property (nonatomic) NSInteger readBookCount;
@property (nonatomic, copy) NSArray<PBRecordListModel *> * _Nullable bookCountList;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK11PBListModel")
@interface PBListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic, copy) NSString * _Nullable audioUrl;
@property (nonatomic) NSInteger pageNum;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class ReadTrendModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK23PBReadRecordDetailModel")
@interface PBReadRecordDetailModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger days;
@property (nonatomic) NSInteger exceedRatio;
@property (nonatomic, copy) NSString * _Nullable poster;
@property (nonatomic, copy) NSString * _Nullable qrCode;
@property (nonatomic, strong) ReadTrendModel * _Nullable readTrend;
@property (nonatomic, copy) NSArray<BookTypeReadStatsModel *> * _Nullable bookTypeReadStats;
@property (nonatomic) NSInteger readBookCount;
@property (nonatomic) NSInteger readDuration;
@property (nonatomic, copy) NSArray<PBDetailedListModel *> * _Nullable detailedList;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK17PBReadRecordModel")
@interface PBReadRecordModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger readBookCount;
@property (nonatomic) NSInteger readFrequency;
@property (nonatomic) NSInteger readDuration;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK22PBRecommendDetailModel")
@interface PBRecommendDetailModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable author;
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic, copy) NSString * _Nullable recommendReason;
@property (nonatomic, copy) NSString * _Nullable desc;
@property (nonatomic, copy) NSString * _Nullable typeName;
@property (nonatomic) NSInteger readFrequency;
@property (nonatomic) NSInteger languageType;
@property (nonatomic, copy) NSString * _Nullable picBookName;
@property (nonatomic, copy) NSArray<PBListModel *> * _Nullable picBookList;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20PBRecommendListModel")
@interface PBRecommendListModel : NSObject <NSCoding, YYModel>
@property (nonatomic) float discountPrice;
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic, copy) NSString * _Nullable recommendId;
@property (nonatomic, copy) NSString * _Nullable picBookName;
@property (nonatomic) float originalPrice;
@property (nonatomic, copy) NSString * _Nullable recommendReason;
@property (nonatomic, copy) NSString * _Nullable picBookId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20PBRecommendTypeModel")
@interface PBRecommendTypeModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable recommendId;
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger viewType;
@property (nonatomic, copy) NSString * _Nullable themeValue;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK17PBRecordListModel")
@interface PBRecordListModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger correctQaCount;
@property (nonatomic) NSInteger qaCount;
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic, copy) NSString * _Nullable picBookName;
@property (nonatomic, copy) NSString * _Nullable picBookId;
@property (nonatomic) NSInteger readFrequency;
@property (nonatomic) NSInteger readDuration;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK10PagesModel")
@interface PagesModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable defaultIcon;
@property (nonatomic, copy) NSString * _Nullable selectIcon;
@property (nonatomic) NSInteger page;
@property (nonatomic, copy) NSArray<ODMPagesCategoryModel *> * _Nullable category;
@property (nonatomic, copy) NSArray<ODMFunctiongsModel *> * _Nullable functions;
@property (nonatomic, copy) NSArray<ODMSettingsModel *> * _Nullable settings;
@property (nonatomic, copy) NSArray<ODMFunctiongsModel *> * _Nullable personalCenter;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16PersonalityModel")
@interface PersonalityModel : NSObject
@property (nonatomic, copy) NSString * _Nullable icon;
@property (nonatomic, copy) NSString * _Nullable subColor;
@property (nonatomic, strong) NSArray * _Nullable network;
@property (nonatomic, copy) NSString * _Nullable viceTitle;
@property (nonatomic, copy) NSString * _Nullable title;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, PlayStatus, open) {
  PlayStatusAPP_OTHER_TYPE = -1,
  PlayStatusAPP_OFFLINE = 0,
  PlayStatusAPP_ONLINE = 1,
  PlayStatusAPP_PLAY = 2,
  PlayStatusAPP_SUSPEND = 3,
  PlayStatusAPP_CONTINUE_PLAY = 4,
  PlayStatusAPP_NEXT = 5,
  PlayStatusAPP_PREV = 6,
  PlayStatusAPP_SOUND = 7,
  PlayStatusAPP_DOWNLOAD_STATE = 8,
  PlayStatusAPP_PLAY_MODE = 9,
  PlayStatusAPP_BLUETOOTH_NEXT = 10,
  PlayStatusAPP_BLUETOOTH_PREV = 11,
  PlayStatusAPP_BLUETOOTH_SUSPEND = 12,
  PlayStatusAPP_BLUETOOTH_CONTINUE = 13,
  PlayStatusAPP_BLUETOOTH = 14,
  PlayStatusAPP_DRAG = 15,
  PlayStatusAPP_UNBIND = 16,
  PlayStatusAPP_STATE = 17,
  PlayStatusAPP_LIKE = 18,
  PlayStatusAPP_CANCEL_LIKE = 19,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK13QaAnswerModel")
@interface QaAnswerModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable aID;
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable skillId;
@property (nonatomic, copy) NSString * _Nullable topicId;
@property (nonatomic, copy) NSString * _Nullable kId;
@property (nonatomic, copy) NSString * _Nullable answerId;
@property (nonatomic, copy) NSString * _Nullable answerName;
@property (nonatomic) BOOL mobileClient;
@property (nonatomic) BOOL pcClient;
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic, copy) NSString * _Nullable linkUrl;
@property (nonatomic, copy) NSString * _Nullable weight;
@property (nonatomic) BOOL primaryFlag;
@property (nonatomic, copy) NSString * _Nullable createBy;
@property (nonatomic, copy) NSString * _Nullable createDate;
@property (nonatomic, copy) NSString * _Nullable updateBy;
@property (nonatomic, copy) NSString * _Nullable updateDate;
@property (nonatomic, copy) NSString * _Nullable deleteBy;
@property (nonatomic, copy) NSString * _Nullable deleteDate;
@property (nonatomic) BOOL deleteFlag;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class QaTopicKnowledgeModel;
@class QaQuestionModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK11QaInfoModel")
@interface QaInfoModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable skillId;
@property (nonatomic, copy) NSString * _Nullable topicId;
@property (nonatomic, copy) NSString * _Nullable kId;
@property (nonatomic, strong) QaTopicKnowledgeModel * _Nullable topicKnowledgeModel;
@property (nonatomic, copy) NSArray<QaQuestionModel *> * _Nullable question;
@property (nonatomic, copy) NSArray<QaAnswerModel *> * _Nullable answer;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK11QaInitModel")
@interface QaInitModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable productName;
@property (nonatomic, copy) NSString * _Nullable productType;
@property (nonatomic, copy) NSString * _Nullable publicKey;
@property (nonatomic, copy) NSString * _Nullable secretKey;
@property (nonatomic, strong) NSArray * _Nullable skillIds;
@property (nonatomic, strong) NSArray * _Nullable topicIds;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15QaQuestionModel")
@interface QaQuestionModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable qID;
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable skillId;
@property (nonatomic, copy) NSString * _Nullable topicId;
@property (nonatomic, copy) NSString * _Nullable kId;
@property (nonatomic, copy) NSString * _Nullable questionId;
@property (nonatomic, copy) NSString * _Nullable questionName;
@property (nonatomic) BOOL primaryFlag;
@property (nonatomic) BOOL diffusionFlag;
@property (nonatomic, copy) NSString * _Nullable createBy;
@property (nonatomic, copy) NSString * _Nullable createDate;
@property (nonatomic, copy) NSString * _Nullable updateBy;
@property (nonatomic, copy) NSString * _Nullable updateDate;
@property (nonatomic, copy) NSString * _Nullable deleteBy;
@property (nonatomic, copy) NSString * _Nullable deleteDate;
@property (nonatomic) BOOL deleteFlag;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK21QaTopicKnowledgeModel")
@interface QaTopicKnowledgeModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable topicKnowledgeId;
@property (nonatomic, copy) NSString * _Nullable topicId;
@property (nonatomic, copy) NSString * _Nullable kId;
@property (nonatomic) BOOL kType;
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable skillId;
@property (nonatomic, copy) NSString * _Nullable weight;
@property (nonatomic, copy) NSString * _Nullable createBy;
@property (nonatomic, copy) NSString * _Nullable createDate;
@property (nonatomic, copy) NSString * _Nullable updateBy;
@property (nonatomic, copy) NSString * _Nullable updateDate;
@property (nonatomic, copy) NSString * _Nullable deleteBy;
@property (nonatomic, copy) NSString * _Nullable deleteDate;
@property (nonatomic) BOOL deleteFlag;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18QuickCreateRequest")
@interface QuickCreateRequest : NSObject
@property (nonatomic, strong) NSArray * _Nullable sentences;
@property (nonatomic, strong) NSArray * _Nullable commands;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK17QuickLoginRequest")
@interface QuickLoginRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable accesToken;
@property (nonatomic, copy) NSString * _Nonnull channel;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK14ReadTrendModel")
@interface ReadTrendModel : NSObject
@property (nonatomic) NSInteger Monday;
@property (nonatomic) NSInteger Tuesday;
@property (nonatomic) NSInteger Wednesday;
@property (nonatomic) NSInteger Thursday;
@property (nonatomic) NSInteger Friday;
@property (nonatomic) NSInteger Saturday;
@property (nonatomic) NSInteger Sunday;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, ReceiveState, open) {
  ReceiveStateReceiveSuccess = 0,
  ReceiveStateReceiveFailure = 1,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK13ResAlbumModel")
@interface ResAlbumModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable coverUrlLarge;
@property (nonatomic) NSInteger trackCount;
@property (nonatomic, copy) NSString * _Nullable releaseTime;
@property (nonatomic, copy) NSString * _Nullable artist;
@property (nonatomic, copy) NSString * _Nullable coverUrlSmall;
@property (nonatomic, copy) NSString * _Nullable coverUrlMiddle;
@property (nonatomic, copy) NSString * _Nullable author;
@property (nonatomic, copy) NSString * _Nullable intro;
@property (nonatomic, copy) NSString * _Nullable resAlbumId;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable languageName;
@property (nonatomic, copy) NSString * _Nullable tags;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable source;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
typedef SWIFT_ENUM(NSInteger, ResCommType, open) {
  ResCommTypeSTORY = 1,
  ResCommTypeGUO_XUE = 2,
  ResCommTypeCHILD_SONG = 3,
  ResCommTypePOETRY = 4,
  ResCommTypeXIANG_SHENG = 5,
  ResCommTypeXIAO_PIN = 6,
  ResCommTypePING_SHU = 7,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK19ResIdaddyCatesModel")
@interface ResIdaddyCatesModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable catId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13ResMusicModel")
@interface ResMusicModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable musicId;
@property (nonatomic, copy) NSString * _Nullable coverUrlLarge;
@property (nonatomic, copy) NSString * _Nullable artist;
@property (nonatomic, copy) NSString * _Nullable coverUrlSmall;
@property (nonatomic, copy) NSString * _Nullable author;
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic, copy) NSString * _Nullable trackIntro;
@property (nonatomic, copy) NSString * _Nullable coverUrlMiddle;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable languageName;
@property (nonatomic, copy) NSString * _Nullable trackTitle;
@property (nonatomic, copy) NSString * _Nullable playUrl;
@property (nonatomic, copy) NSString * _Nullable playSize;
@property (nonatomic) NSInteger duration;
@property (nonatomic, copy) NSString * _Nullable albumTitle;
@property (nonatomic, copy) NSString * _Nullable trackTags;
@property (nonatomic, copy) NSString * _Nullable source;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20ResNewsCateListModel")
@interface ResNewsCateListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable newsId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK16ResNewsListModel")
@interface ResNewsListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable newsListId;
@property (nonatomic, copy) NSString * _Nullable category;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable image_url;
@property (nonatomic, copy) NSString * _Nullable audio_url;
@property (nonatomic, copy) NSString * _Nullable duration;
@property (nonatomic, copy) NSString * _Nullable source;
@property (nonatomic, copy) NSString * _Nullable human_time;
@property (nonatomic, copy) NSString * _Nullable updated_at;
@property (nonatomic, copy) NSString * _Nullable tags;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK21ResRadioCateListModel")
@interface ResRadioCateListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable radioId;
@property (nonatomic, copy) NSString * _Nullable icon;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class ResRadioProgramModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK17ResRadioListModel")
@interface ResRadioListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable logo;
@property (nonatomic, copy) NSString * _Nullable play_url;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable fm;
@property (nonatomic, strong) ResRadioProgramModel * _Nullable program;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK20ResRadioProgramModel")
@interface ResRadioProgramModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable start_time;
@property (nonatomic, copy) NSString * _Nullable end_time;
@property (nonatomic, copy) NSString * _Nullable dj;
@property (nonatomic, copy) NSString * _Nullable week;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
typedef SWIFT_ENUM(NSInteger, SMSCODETYPE, open) {
  SMSCODETYPELOGIN = 1,
  SMSCODETYPEFORGETPW = 2,
  SMSCODETYPEBINDINGPHONE = 4,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK11SearchModel")
@interface SearchModel : NSObject
@property (nonatomic, copy) NSArray<HiFiSearchModel *> * _Nullable hifiSearchModel;
@property (nonatomic, copy) NSArray<OtherSearchModel *> * _Nullable otherSearchModel;
@property (nonatomic, copy) NSArray<NewsSearchModel *> * _Nullable newsSearchModel;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, SearchType, open) {
  SearchTypeHIFISONG = 1,
  SearchTypeHIFIALBUM = 2,
  SearchTypeQUYI = 3,
  SearchTypeBOOK = 4,
  SearchTypeNEWS = 5,
  SearchTypeSTORY = 6,
  SearchTypeGUOXUE = 7,
  SearchTypeCHILDSONG = 8,
  SearchTypePOETRY = 9,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK18SearchVideoRequest")
@interface SearchVideoRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull catalogId;
@property (nonatomic, copy) NSString * _Nonnull uid;
@property (nonatomic, copy) NSString * _Nonnull productId;
@property (nonatomic, copy) NSString * _Nonnull province;
@property (nonatomic, copy) NSString * _Nonnull city;
@property (nonatomic, copy) NSString * _Nonnull keyword;
@property (nonatomic) NSInteger distinct;
@property (nonatomic) NSInteger size;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18SetPasswordRequest")
@interface SetPasswordRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable token;
@property (nonatomic, copy) NSString * _Nullable password;
@property (nonatomic, copy) NSString * _Nonnull channel;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18SkillDetailRequest")
@interface SkillDetailRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull skillId;
@property (nonatomic, copy) NSString * _Nonnull skillVersion;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK12SkillRequest")
@interface SkillRequest : NSObject
@property (nonatomic, copy) NSString * _Nonnull skillId;
@property (nonatomic, copy) NSString * _Nonnull skillVersion;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK21SmartHomeTokenRequest")
@interface SmartHomeTokenRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable skillId;
@property (nonatomic, copy) NSString * _Nullable skillVersion;
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable smartHomeAccessToken;
@property (nonatomic, copy) NSString * _Nullable smartHomeRefreshToken;
@property (nonatomic) NSInteger accessTokenExpiresIn;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
typedef SWIFT_ENUM(NSInteger, SonicNetworkState, open) {
  SonicNetworkStateSonicNetworkSuccess = 0,
  SonicNetworkStateSonicNetworkFailure = 1,
  SonicNetworkStateSonicNetworkConnecting = 2,
};
SWIFT_CLASS("_TtC11iOS_DCA_SDK16TVBatchListModel")
@interface TVBatchListModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSArray<TVDetailModel *> * _Nullable data;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
@class iqiyiMediaModel;
@class vstMediaModel;
SWIFT_CLASS("_TtC11iOS_DCA_SDK13TVDetailModel")
@interface TVDetailModel : NSObject <NSCoding, YYModel>
@property (nonatomic, strong) NSArray * _Nullable screenwriter;
@property (nonatomic, strong) NSArray * _Nullable artist;
@property (nonatomic, strong) iqiyiMediaModel * _Nullable iqiyi_media;
@property (nonatomic, strong) vstMediaModel * _Nullable vst_media;
@property (nonatomic, copy) NSString * _Nullable iqiyi_score;
@property (nonatomic, copy) NSString * _Nullable douban_score;
@property (nonatomic, copy) NSString * _Nullable year;
@property (nonatomic, strong) NSArray * _Nullable director;
@property (nonatomic, strong) NSArray * _Nullable participator;
@property (nonatomic, copy) NSString * _Nullable hot;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, strong) NSArray * _Nullable union_styles;
@property (nonatomic, copy) NSString * _Nullable category;
@property (nonatomic, strong) NSArray * _Nullable region;
@property (nonatomic, copy) NSString * _Nullable tvId;
@property (nonatomic, strong) NSArray * _Nullable iqiyi_tags;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK11TVShowModel")
@interface TVShowModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable beginTime;
@property (nonatomic, copy) NSString * _Nullable detail;
@property (nonatomic, copy) NSString * _Nullable endTime;
@property (nonatomic) NSInteger showId;
@property (nonatomic, copy) NSString * _Nullable img;
@property (nonatomic, copy) NSString * _Nullable introduction;
@property (nonatomic) NSInteger state;
@property (nonatomic, copy) NSString * _Nullable title;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK17TrainRequestModel")
@interface TrainRequestModel : NSObject
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable gender;
@property (nonatomic, copy) NSString * _Nullable age;
@property (nonatomic, copy) NSString * _Nullable customInfo;
@property (nonatomic, copy) NSArray<NSString *> * _Nullable audio_list;
@property (nonatomic, copy) NSArray<NSString *> * _Nullable pre_tts_text;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18UploadRequestModel")
@interface UploadRequestModel : NSObject
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, copy) NSString * _Nullable textId;
@property (nonatomic, copy) NSString * _Nullable gender;
@property (nonatomic, copy) NSString * _Nonnull age;
@property (nonatomic, copy) NSData * _Nullable data;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13UserInfoModel")
@interface UserInfoModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable createdTime;
@property (nonatomic, copy) NSString * _Nullable phone;
@property (nonatomic, copy) NSString * _Nullable pId;
@property (nonatomic) NSInteger sex;
@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable token;
@property (nonatomic, copy) NSString * _Nullable qrCode;
@property (nonatomic, copy) NSString * _Nullable accId;
@property (nonatomic, copy) NSString * _Nullable address;
@property (nonatomic, copy) NSString * _Nullable nickName;
@property (nonatomic, copy) NSString * _Nullable head;
@property (nonatomic, copy) NSString * _Nullable appId;
@property (nonatomic, copy) NSString * _Nullable birthday;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelCustomPropertyMapper SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13VerifyRequest")
@interface VerifyRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable userName;
@property (nonatomic, copy) NSString * _Nullable smsCode;
@property (nonatomic, copy) NSString * _Nonnull channel;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK14VoiceCopyModel")
@interface VoiceCopyModel : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18VoiceCopyTextModel")
@interface VoiceCopyTextModel : NSObject
@property (nonatomic, copy) NSString * _Nullable textId;
@property (nonatomic, copy) NSString * _Nullable text;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK18WeChatLoginRequest")
@interface WeChatLoginRequest : NSObject
@property (nonatomic, copy) NSString * _Nullable unionId;
@property (nonatomic, copy) NSString * _Nullable openId;
@property (nonatomic, copy) NSString * _Nullable nickName;
@property (nonatomic, copy) NSString * _Nullable headImgUrl;
@property (nonatomic, copy) NSString * _Nonnull channel;
@property (nonatomic) BOOL allowCreate;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK11epInfoModel")
@interface epInfoModel : NSObject <NSCoding, YYModel>
@property (nonatomic) NSInteger epOrder;
@property (nonatomic, copy) NSString * _Nullable year;
@property (nonatomic) NSInteger epIsVip;
@property (nonatomic) NSInteger epLen;
@property (nonatomic, copy) NSString * _Nullable epPicUrl;
@property (nonatomic, copy) NSString * _Nullable videoId;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable epName;
@property (nonatomic) NSInteger epType;
@property (nonatomic, copy) NSString * _Nullable epFocus;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK15iqiyiMediaModel")
@interface iqiyiMediaModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable albumId;
@property (nonatomic, copy) NSString * _Nullable videoId;
@property (nonatomic) NSInteger hot;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic) NSInteger isVip;
@property (nonatomic) NSInteger effective;
@property (nonatomic, copy) NSString * _Nullable picUrl;
@property (nonatomic) NSInteger playCount;
@property (nonatomic) NSInteger sourceCode;
@property (nonatomic, copy) NSString * _Nullable focusName;
@property (nonatomic, copy) NSString * _Nullable posterUrl;
@property (nonatomic) NSInteger epProbation;
@property (nonatomic) NSInteger series;
@property (nonatomic) NSInteger channelId;
@property (nonatomic, copy) NSString * _Nullable desc;
@property (nonatomic, copy) NSArray<epInfoModel *> * _Nullable epInfo;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
+ (NSDictionary<NSString *, id> * _Nullable)modelContainerPropertyGenericClass SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
SWIFT_CLASS("_TtC11iOS_DCA_SDK13vstMediaModel")
@interface vstMediaModel : NSObject <NSCoding, YYModel>
@property (nonatomic, copy) NSString * _Nullable playCount;
@property (nonatomic, copy) NSString * _Nullable posterUrl;
@property (nonatomic, copy) NSString * _Nullable videoId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end
#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif
#endif