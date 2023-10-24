#import <Foundation/Foundation.h>
enum { 
  BLOCK_HAS_COPY_DISPOSE =  (1 << 25),
  BLOCK_HAS_CTOR =          (1 << 26), 
  BLOCK_IS_GLOBAL =         (1 << 28),
  BLOCK_HAS_STRET =         (1 << 29), 
  BLOCK_HAS_SIGNATURE =     (1 << 30),
};
struct BlockDescriptor {
  unsigned long int reserved;                
  unsigned long int size;
  void (*copy_helper)(void *dst, void *src); 
  void (*dispose_helper)(void *src);         
  const char *signature;                     
};
struct BlockLiteral {
  void *isa;  
  int flags;
  int reserved;
  void (*invoke)(void *, ...);
  struct BlockDescriptor *descriptor;
};