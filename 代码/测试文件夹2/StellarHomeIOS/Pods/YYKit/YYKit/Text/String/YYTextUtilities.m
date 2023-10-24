#import "YYTextUtilities.h"
NSCharacterSet *YYTextVerticalFormRotateCharacterSet() {
    static NSMutableCharacterSet *set;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSMutableCharacterSet new];
        [set addCharactersInRange:NSMakeRange(0x1100, 256)]; 
        [set addCharactersInRange:NSMakeRange(0x2460, 160)]; 
        [set addCharactersInRange:NSMakeRange(0x2600, 256)]; 
        [set addCharactersInRange:NSMakeRange(0x2700, 192)]; 
        [set addCharactersInRange:NSMakeRange(0x2E80, 128)]; 
        [set addCharactersInRange:NSMakeRange(0x2F00, 224)]; 
        [set addCharactersInRange:NSMakeRange(0x2FF0, 16)]; 
        [set addCharactersInRange:NSMakeRange(0x3000, 64)]; 
        [set removeCharactersInRange:NSMakeRange(0x3008, 10)];
        [set removeCharactersInRange:NSMakeRange(0x3014, 12)];
        [set addCharactersInRange:NSMakeRange(0x3040, 96)]; 
        [set addCharactersInRange:NSMakeRange(0x30A0, 96)]; 
        [set addCharactersInRange:NSMakeRange(0x3100, 48)]; 
        [set addCharactersInRange:NSMakeRange(0x3130, 96)]; 
        [set addCharactersInRange:NSMakeRange(0x3190, 16)]; 
        [set addCharactersInRange:NSMakeRange(0x31A0, 32)]; 
        [set addCharactersInRange:NSMakeRange(0x31C0, 48)]; 
        [set addCharactersInRange:NSMakeRange(0x31F0, 16)]; 
        [set addCharactersInRange:NSMakeRange(0x3200, 256)]; 
        [set addCharactersInRange:NSMakeRange(0x3300, 256)]; 
        [set addCharactersInRange:NSMakeRange(0x3400, 2582)]; 
        [set addCharactersInRange:NSMakeRange(0x4E00, 20941)]; 
        [set addCharactersInRange:NSMakeRange(0xAC00, 11172)]; 
        [set addCharactersInRange:NSMakeRange(0xD7B0, 80)]; 
        [set addCharactersInString:@""]; 
        [set addCharactersInRange:NSMakeRange(0xF900, 512)]; 
        [set addCharactersInRange:NSMakeRange(0xFE10, 16)]; 
        [set addCharactersInRange:NSMakeRange(0xFF00, 240)]; 
        [set addCharactersInRange:NSMakeRange(0x1F200, 256)]; 
        [set addCharactersInRange:NSMakeRange(0x1F300, 768)]; 
        [set addCharactersInRange:NSMakeRange(0x1F600, 80)]; 
        [set addCharactersInRange:NSMakeRange(0x1F680, 128)]; 
    });
    return set;
}
NSCharacterSet *YYTextVerticalFormRotateAndMoveCharacterSet() {
    static NSMutableCharacterSet *set;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSMutableCharacterSet new];
        [set addCharactersInString:@"，。、．"];
    });
    return set;
}