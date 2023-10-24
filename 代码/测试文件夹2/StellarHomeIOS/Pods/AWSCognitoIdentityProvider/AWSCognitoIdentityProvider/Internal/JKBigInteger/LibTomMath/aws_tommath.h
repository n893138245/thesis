#ifndef AWS_BN_H_
#define AWS_BN_H_
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <limits.h>
#include "aws_tommath_class.h"
#ifndef AWS_MIN
   #define AWS_MIN(x,y) ((x)<(y)?(x):(y))
#endif
#ifndef AWS_MAX
   #define AWS_MAX(x,y) ((x)>(y)?(x):(y))
#endif
#ifdef __cplusplus
extern "C" {
#define  AWS_OPT_CAST(x)  (x *)
#else
#define  AWS_OPT_CAST(x)
#endif
#if defined(__x86_64__) 
   #if !(defined(AWS_MP_64BIT) && defined(AWS_MP_16BIT) && defined(AWS_MP_8BIT))
      #define AWS_MP_64BIT
   #endif
#endif
#ifdef AWS_MP_8BIT
   typedef unsigned char      aws_mp_digit;
   typedef unsigned short     aws_mp_word;
#elif defined(AWS_MP_16BIT)
   typedef unsigned short     aws_mp_digit;
   typedef unsigned long      aws_mp_word;
#elif defined(AWS_MP_64BIT)
#ifndef CRYPT
   typedef unsigned long long ulong64;
   typedef signed long long   long64;
#endif
   typedef unsigned long      aws_mp_digit;
   typedef unsigned long      aws_mp_word __attribute__ ((mode(TI)));
   #define AWS_DIGIT_BIT          60
#else
#ifndef CRYPT
   #if defined(_MSC_VER) || defined(__BORLANDC__) 
      typedef unsigned __int64   ulong64;
      typedef signed __int64     long64;
   #else
      typedef unsigned long long ulong64;
      typedef signed long long   long64;
   #endif
#endif
   typedef unsigned long      aws_mp_digit;
   typedef ulong64            aws_mp_word;
#ifdef AWS_MP_31BIT
   #define AWS_DIGIT_BIT          31
#else
   #define AWS_DIGIT_BIT          28
   #define AWS_MP_28BIT
#endif   
#endif
#ifndef CRYPT
   #ifndef AWS_XMALLOC
       #define AWS_XMALLOC  malloc
       #define AWS_XFREE    free
       #define AWS_XREALLOC realloc
       #define AWS_XCALLOC  calloc
   #else
      extern void *AWS_XMALLOC(size_t n);
      extern void *AWS_XREALLOC(void *p, size_t n);
      extern void *AWS_XCALLOC(size_t n, size_t s);
      extern void AWS_XFREE(void *p);
   #endif
#endif
#ifndef AWS_DIGIT_BIT
   #define AWS_DIGIT_BIT     ((int)((AWS_CHAR_BIT * sizeof(aws_mp_digit) - 1)))  
#endif
#define AWS_MP_DIGIT_BIT     AWS_DIGIT_BIT
#define AWS_MP_MASK          ((((aws_mp_digit)1)<<((aws_mp_digit)AWS_DIGIT_BIT))-((aws_mp_digit)1))
#define AWS_MP_DIGIT_MAX     AWS_MP_MASK
#define AWS_MP_LT        -1   
#define AWS_MP_EQ         0   
#define AWS_MP_GT         1   
#define AWS_MP_ZPOS       0   
#define AWS_MP_NEG        1   
#define AWS_MP_OKAY       0   
#define AWS_MP_MEM        -2  
#define AWS_MP_VAL        -3  
#define AWS_MP_RANGE      AWS_MP_VAL
#define AWS_MP_YES        1   
#define AWS_MP_NO         0   
#define AWS_LTM_PRIME_BBS      0x0001 
#define AWS_LTM_PRIME_SAFE     0x0002 
#define AWS_LTM_PRIME_2MSB_ON  0x0008 
typedef int aws_mp_err;
extern int AWS_KARATSUBA_MUL_CUTOFF,
        AWS_KARATSUBA_SQR_CUTOFF,
        AWS_TOOM_MUL_CUTOFF,
        AWS_TOOM_SQR_CUTOFF;
#ifndef AWS_MP_PREC
   #ifndef AWS_MP_LOW_MEM
      #define AWS_MP_PREC                 32     
   #else
      #define AWS_MP_PREC                 8      
   #endif   
#endif
#define AWS_MP_WARRAY               (1 << (sizeof(aws_mp_word) * CHAR_BIT - 2 * AWS_DIGIT_BIT + 1))
typedef struct  {
    int used, alloc, sign;
    aws_mp_digit *dp;
} aws_mp_int;
typedef int aws_ltm_prime_callback(unsigned char *dst, int len, void *dat);
#define AWS_JKTM_USED(m)    ((m)->used)
#define AWS_JKTM_DIGIT(m,k) ((m)->dp[(k)])
#define AWS_JKTM_SIGN(m)    ((m)->sign)
char *aws_mp_error_to_string(int code);
int aws_mp_init(aws_mp_int *a);
void aws_mp_clear(aws_mp_int *a);
int aws_mp_init_multi(aws_mp_int *mp, ...);
void aws_mp_clear_multi(aws_mp_int *mp, ...);
void aws_mp_exch(aws_mp_int *a, aws_mp_int *b);
int aws_mp_shrink(aws_mp_int *a);
int aws_mp_grow(aws_mp_int *a, int size);
int aws_mp_init_size(aws_mp_int *a, int size);
#define aws_mp_iszero(a) (((a)->used == 0) ? AWS_MP_YES : AWS_MP_NO)
#define aws_mp_iseven(a) (((a)->used > 0 && (((a)->dp[0] & 1) == 0)) ? AWS_MP_YES : AWS_MP_NO)
#define aws_mp_isodd(a)  (((a)->used > 0 && (((a)->dp[0] & 1) == 1)) ? AWS_MP_YES : AWS_MP_NO)
void aws_mp_zero(aws_mp_int *a);
void aws_mp_set(aws_mp_int *a, aws_mp_digit b);
int aws_mp_set_int(aws_mp_int *a, unsigned long b);
unsigned long aws_mp_get_int(aws_mp_int *a);
int aws_mp_init_set(aws_mp_int *a, aws_mp_digit b);
int aws_mp_init_set_int(aws_mp_int *a, unsigned long b);
int aws_mp_copy(aws_mp_int *a, aws_mp_int *b);
int aws_mp_init_copy(aws_mp_int *a, aws_mp_int *b);
void aws_mp_clamp(aws_mp_int *a);
void aws_mp_rshd(aws_mp_int *a, int b);
int aws_mp_lshd(aws_mp_int *a, int b);
int aws_mp_div_2d(aws_mp_int *a, int b, aws_mp_int *c, aws_mp_int *d);
int aws_mp_div_2(aws_mp_int *a, aws_mp_int *b);
int aws_mp_mul_2d(aws_mp_int *a, int b, aws_mp_int *c);
int aws_mp_mul_2(aws_mp_int *a, aws_mp_int *b);
int aws_mp_mod_2d(aws_mp_int *a, int b, aws_mp_int *c);
int aws_mp_2expt(aws_mp_int *a, int b);
int aws_mp_cnt_lsb(aws_mp_int *a);
int aws_mp_rand(aws_mp_int *a, int digits);
int aws_mp_xor(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_or(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_and(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_neg(aws_mp_int *a, aws_mp_int *b);
int aws_mp_abs(aws_mp_int *a, aws_mp_int *b);
int aws_mp_cmp(aws_mp_int *a, aws_mp_int *b);
int aws_mp_cmp_mag(aws_mp_int *a, aws_mp_int *b);
int aws_mp_add(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_sub(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_mul(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_sqr(aws_mp_int *a, aws_mp_int *b);
int aws_mp_div(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c, aws_mp_int *d);
int aws_mp_mod(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_cmp_d(aws_mp_int *a, aws_mp_digit b);
int aws_mp_add_d(aws_mp_int *a, aws_mp_digit b, aws_mp_int *c);
int aws_mp_sub_d(aws_mp_int *a, aws_mp_digit b, aws_mp_int *c);
int aws_mp_mul_d(aws_mp_int *a, aws_mp_digit b, aws_mp_int *c);
int aws_mp_div_d(aws_mp_int *a, aws_mp_digit b, aws_mp_int *c, aws_mp_digit *d);
int aws_mp_div_3(aws_mp_int *a, aws_mp_int *c, aws_mp_digit *d);
int aws_mp_expt_d(aws_mp_int *a, aws_mp_digit b, aws_mp_int *c);
int aws_mp_mod_d(aws_mp_int *a, aws_mp_digit b, aws_mp_digit *c);
int aws_mp_addmod(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c, aws_mp_int *d);
int aws_mp_submod(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c, aws_mp_int *d);
int aws_mp_mulmod(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c, aws_mp_int *d);
int aws_mp_sqrmod(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_invmod(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_gcd(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_exteuclid(aws_mp_int *a, aws_mp_int *b, aws_mp_int *U1, aws_mp_int *U2, aws_mp_int *U3);
int aws_aws_mp_lcm(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_n_root(aws_mp_int *a, aws_mp_digit b, aws_mp_int *c);
int aws_mp_sqrt(aws_mp_int *arg, aws_mp_int *ret);
int aws_mp_is_square(aws_mp_int *arg, int *ret);
int aws_mp_jacobi(aws_mp_int *a, aws_mp_int *n, int *c);
int aws_mp_reduce_setup(aws_mp_int *a, aws_mp_int *b);
int aws_mp_reduce(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_montgomery_setup(aws_mp_int *a, aws_mp_digit *mp);
int aws_mp_montgomery_calc_normalization(aws_mp_int *a, aws_mp_int *b);
int aws_mp_montgomery_reduce(aws_mp_int *a, aws_mp_int *m, aws_mp_digit mp);
int aws_mp_dr_is_modulus(aws_mp_int *a);
void aws_mp_dr_setup(aws_mp_int *a, aws_mp_digit *d);
int aws_mp_dr_reduce(aws_mp_int *a, aws_mp_int *b, aws_mp_digit mp);
int aws_mp_reduce_is_2k(aws_mp_int *a);
int aws_mp_reduce_2k_setup(aws_mp_int *a, aws_mp_digit *d);
int aws_mp_reduce_2k(aws_mp_int *a, aws_mp_int *n, aws_mp_digit d);
int aws_mp_reduce_is_2k_l(aws_mp_int *a);
int aws_mp_reduce_2k_setup_l(aws_mp_int *a, aws_mp_int *d);
int aws_mp_reduce_2k_l(aws_mp_int *a, aws_mp_int *n, aws_mp_int *d);
int aws_mp_exptmod(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c, aws_mp_int *d);
#ifdef AWS_MP_8BIT
   #define AWS_JKTM_PRIME_SIZE      31
#else
   #define AWS_JKTM_PRIME_SIZE      256
#endif
extern const aws_mp_digit aws_ltm_prime_tab[];
int aws_mp_prime_is_divisible(aws_mp_int *a, int *result);
int aws_mp_prime_fermat(aws_mp_int *a, aws_mp_int *b, int *result);
int aws_mp_prime_miller_rabin(aws_mp_int *a, aws_mp_int *b, int *result);
int aws_mp_prime_rabin_miller_trials(int size);
int aws_mp_prime_is_prime(aws_mp_int *a, int t, int *result);
int aws_mp_prime_next_prime(aws_mp_int *a, int t, int bbs_style);
#define mp_prime_random(a, t, size, bbs, cb, dat) mp_prime_random_ex(a, t, ((size) * 8) + 1, (bbs==1)?AWS_LTM_PRIME_BBS:0, cb, dat)
int aws_mp_prime_random_ex(aws_mp_int *a, int t, int size, int flags, aws_ltm_prime_callback cb, void *dat);
int aws_mp_count_bits(aws_mp_int *a);
int aws_mp_unsigned_bin_size(aws_mp_int *a);
int aws_mp_read_unsigned_bin(aws_mp_int *a, const unsigned char *b, int c);
int aws_mp_to_unsigned_bin(aws_mp_int *a, unsigned char *b);
int aws_mp_to_unsigned_bin_n(aws_mp_int *a, unsigned char *b, unsigned long *outlen);
int aws_mp_signed_bin_size(aws_mp_int *a);
int aws_mp_read_signed_bin(aws_mp_int *a, const unsigned char *b, int c);
int aws_mp_to_signed_bin(aws_mp_int *a, unsigned char *b);
int aws_mp_to_signed_bin_n(aws_mp_int *a, unsigned char *b, unsigned long *outlen);
int aws_mp_read_radix(aws_mp_int *a, const char *str, int radix);
int aws_mp_toradix(aws_mp_int *a, char *str, int radix);
int aws_mp_toradix_n(aws_mp_int *a, char *str, int radix, int maxlen);
int aws_mp_radix_size(aws_mp_int *a, int radix, int *size);
int aws_mp_fread(aws_mp_int *a, int radix, FILE *stream);
int aws_mp_fwrite(aws_mp_int *a, int radix, FILE *stream);
#define mp_read_raw(mp, str, len) mp_read_signed_bin((mp), (str), (len))
#define mp_raw_size(mp)           mp_signed_bin_size(mp)
#define mp_toraw(mp, str)         mp_to_signed_bin((mp), (str))
#define mp_read_mag(mp, str, len) mp_read_unsigned_bin((mp), (str), (len))
#define mp_mag_size(mp)           mp_unsigned_bin_size(mp)
#define mp_tomag(mp, str)         mp_to_unsigned_bin((mp), (str))
#define mp_tobinary(M, S)  mp_toradix((M), (S), 2)
#define mp_tooctal(M, S)   mp_toradix((M), (S), 8)
#define mp_todecimal(M, S) mp_toradix((M), (S), 10)
#define mp_tohex(M, S)     mp_toradix((M), (S), 16)
int aws_s_mp_add(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_s_mp_sub(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
#define aws_s_mp_mul(a, b, c) aws_s_mp_mul_digs(a, b, c, (a)->used + (b)->used + 1)
int aws_fast_s_mp_mul_digs(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c, int digs);
int aws_s_mp_mul_digs(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c, int digs);
int aws_fast_s_mp_mul_high_digs(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c, int digs);
int aws_s_mp_mul_high_digs(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c, int digs);
int aws_fast_s_mp_sqr(aws_mp_int *a, aws_mp_int *b);
int aws_s_mp_sqr(aws_mp_int *a, aws_mp_int *b);
int aws_mp_karatsuba_mul(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_toom_mul(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_karatsuba_sqr(aws_mp_int *a, aws_mp_int *b);
int aws_mp_toom_sqr(aws_mp_int *a, aws_mp_int *b);
int aws_fast_mp_invmod(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_mp_invmod_slow(aws_mp_int *a, aws_mp_int *b, aws_mp_int *c);
int aws_fast_mp_montgomery_reduce(aws_mp_int *a, aws_mp_int *m, aws_mp_digit mp);
int aws_mp_exptmod_fast(aws_mp_int *G, aws_mp_int *X, aws_mp_int *P, aws_mp_int *Y, int mode);
int aws_s_mp_exptmod(aws_mp_int *G, aws_mp_int *X, aws_mp_int *P, aws_mp_int *Y, int mode);
void aws_bn_reverse(unsigned char *s, int len);
extern const char *aws_mp_s_rmap;
#ifdef __cplusplus
   }
#endif
#endif