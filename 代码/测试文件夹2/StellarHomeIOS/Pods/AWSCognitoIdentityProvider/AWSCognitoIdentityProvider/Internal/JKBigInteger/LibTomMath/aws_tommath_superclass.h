#define AWS_LTM_ALL
#ifdef AWS_SC_RSA_1
   #define AWS_BN_MP_SHRINK_C
   #define AWS_BN_MP_LCM_C
   #define AWS_BN_MP_PRIME_RANDOM_EX_C
   #define AWS_BN_MP_INVMOD_C
   #define AWS_BN_MP_GCD_C
   #define AWS_BN_MP_MOD_C
   #define AWS_BN_MP_MULMOD_C
   #define AWS_BN_MP_ADDMOD_C
   #define AWS_BN_MP_EXPTMOD_C
   #define AWS_BN_MP_SET_INT_C
   #define AWS_BN_MP_INIT_MULTI_C
   #define AWS_BN_MP_CLEAR_MULTI_C
   #define AWS_BN_MP_UNSIGNED_BIN_SIZE_C
   #define AWS_BN_MP_TO_UNSIGNED_BIN_C
   #define AWS_BN_MP_MOD_D_C
   #define AWS_BN_MP_PRIME_RABIN_MILLER_TRIALS_C
   #define AWS_BN_REVERSE_C
   #define AWS_BN_PRIME_TAB_C
   #define AWS_BN_MP_DIV_SMALL                    
#ifdef AWS_LTM_LAST
   #undef  AWS_BN_MP_TOOM_MUL_C
   #undef  AWS_BN_MP_TOOM_SQR_C
   #undef  AWS_BN_MP_KARATSUBA_MUL_C
   #undef  AWS_BN_MP_KARATSUBA_SQR_C
   #undef  AWS_BN_MP_REDUCE_C
   #undef  AWS_BN_MP_REDUCE_SETUP_C
   #undef  AWS_BN_MP_DR_IS_MODULUS_C
   #undef  AWS_BN_MP_DR_SETUP_C
   #undef  AWS_BN_MP_DR_REDUCE_C
   #undef  AWS_BN_MP_REDUCE_IS_2K_C
   #undef  AWS_BN_MP_REDUCE_2K_SETUP_C
   #undef  AWS_BN_MP_REDUCE_2K_C
   #undef  AWS_BN_S_MP_EXPTMOD_C
   #undef  AWS_BN_MP_DIV_3_C
   #undef  AWS_BN_S_MP_MUL_HIGH_DIGS_C
   #undef  AWS_BN_FAST_S_MP_MUL_HIGH_DIGS_C
   #undef  AWS_BN_FAST_MP_INVMOD_C
   #undef  AWS_BN_S_MP_MUL_DIGS_C
   #undef  AWS_BN_S_MP_SQR_C
   #undef  AWS_BN_MP_MONTGOMERY_REDUCE_C
#endif
#endif