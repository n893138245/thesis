#ifndef _NET_ROUTE_H_
#define _NET_ROUTE_H_
#include <stdint.h>
#include <sys/appleapiopts.h>
#include <sys/socket.h>
#include <sys/types.h>
#ifdef PRIVATE
struct rtentry;
struct route {
  struct rtentry *ro_rt;
  uint32_t ro_flags; 
  struct sockaddr ro_dst;
};
#define ROF_SRCIF_SELECTED 0x1 
#else
struct route;
#endif 
struct rt_metrics {
  u_int32_t rmx_locks;     
  u_int32_t rmx_mtu;       
  u_int32_t rmx_hopcount;  
  int32_t rmx_expire;      
  u_int32_t rmx_recvpipe;  
  u_int32_t rmx_sendpipe;  
  u_int32_t rmx_ssthresh;  
  u_int32_t rmx_rtt;       
  u_int32_t rmx_rttvar;    
  u_int32_t rmx_pksent;    
  u_int32_t rmx_filler[4]; 
};
#define RTM_RTTUNIT 1000000 
#ifdef KERNEL_PRIVATE
#include <kern/locks.h>
#ifndef RNF_NORMAL
#include <net/radix.h>
#endif
struct rtentry {
  struct radix_node rt_nodes[2]; 
#define rt_key(r) ((struct sockaddr *)((r)->rt_nodes->rn_key))
#define rt_mask(r) ((struct sockaddr *)((r)->rt_nodes->rn_mask))
  struct sockaddr *rt_gateway;    
  int32_t rt_refcnt;              
  uint32_t rt_flags;              
  struct ifnet *rt_ifp;           
  struct ifaddr *rt_ifa;          
  struct sockaddr *rt_genmask;    
  void *rt_llinfo;                
  void (*rt_llinfo_free)(void *); 
  struct rt_metrics rt_rmx;       
  struct rtentry *rt_gwroute;     
  struct rtentry *rt_parent;      
  uint32_t generation_id;         
  decl_lck_mtx_data(, rt_lock);   
};
#endif 
#ifdef KERNEL_PRIVATE
#define rt_use rt_rmx.rmx_pksent
#endif 
#define RTF_UP 0x1           
#define RTF_GATEWAY 0x2      
#define RTF_HOST 0x4         
#define RTF_REJECT 0x8       
#define RTF_DYNAMIC 0x10     
#define RTF_MODIFIED 0x20    
#define RTF_DONE 0x40        
#define RTF_DELCLONE 0x80    
#define RTF_CLONING 0x100    
#define RTF_XRESOLVE 0x200   
#define RTF_LLINFO 0x400     
#define RTF_STATIC 0x800     
#define RTF_BLACKHOLE 0x1000 
#define RTF_PROTO2 0x4000    
#define RTF_PROTO1 0x8000    
#define RTF_PRCLONING 0x10000 
#define RTF_WASCLONED 0x20000 
#define RTF_PROTO3 0x40000    
#define RTF_PINNED 0x100000     
#define RTF_LOCAL 0x200000      
#define RTF_BROADCAST 0x400000  
#define RTF_MULTICAST 0x800000  
#define RTF_IFSCOPE 0x1000000   
#define RTF_CONDEMNED 0x2000000 
struct rtstat {
  short rts_badredirect; 
  short rts_dynamic;     
  short rts_newgateway;  
  short rts_unreach;     
  short rts_wildcard;    
};
struct rt_msghdr {
  u_short rtm_msglen;        
  u_char rtm_version;        
  u_char rtm_type;           
  u_short rtm_index;         
  int rtm_flags;             
  int rtm_addrs;             
  pid_t rtm_pid;             
  int rtm_seq;               
  int rtm_errno;             
  int rtm_use;               
  u_int32_t rtm_inits;       
  struct rt_metrics rtm_rmx; 
};
struct rt_msghdr2 {
  u_short rtm_msglen;        
  u_char rtm_version;        
  u_char rtm_type;           
  u_short rtm_index;         
  int rtm_flags;             
  int rtm_addrs;             
  int32_t rtm_refcnt;        
  int rtm_parentflags;       
  int rtm_reserved;          
  int rtm_use;               
  u_int32_t rtm_inits;       
  struct rt_metrics rtm_rmx; 
};
#define RTM_VERSION 5 
#define RTM_ADD 0x1       
#define RTM_DELETE 0x2    
#define RTM_CHANGE 0x3    
#define RTM_GET 0x4       
#define RTM_LOSING 0x5    
#define RTM_REDIRECT 0x6  
#define RTM_MISS 0x7      
#define RTM_LOCK 0x8      
#define RTM_OLDADD 0x9    
#define RTM_OLDDEL 0xa    
#define RTM_RESOLVE 0xb   
#define RTM_NEWADDR 0xc   
#define RTM_DELADDR 0xd   
#define RTM_IFINFO 0xe    
#define RTM_NEWMADDR 0xf  
#define RTM_DELMADDR 0x10 
#ifdef PRIVATE
#define RTM_GET_SILENT 0x11
#endif                     
#define RTM_IFINFO2 0x12   
#define RTM_NEWMADDR2 0x13 
#define RTM_GET2 0x14      
#define RTV_MTU 0x1       
#define RTV_HOPCOUNT 0x2  
#define RTV_EXPIRE 0x4    
#define RTV_RPIPE 0x8     
#define RTV_SPIPE 0x10    
#define RTV_SSTHRESH 0x20 
#define RTV_RTT 0x40      
#define RTV_RTTVAR 0x80   
#define RTA_DST 0x1     
#define RTA_GATEWAY 0x2 
#define RTA_NETMASK 0x4 
#define RTA_GENMASK 0x8 
#define RTA_IFP 0x10    
#define RTA_IFA 0x20    
#define RTA_AUTHOR 0x40 
#define RTA_BRD 0x80    
#define RTAX_DST 0     
#define RTAX_GATEWAY 1 
#define RTAX_NETMASK 2 
#define RTAX_GENMASK 3 
#define RTAX_IFP 4     
#define RTAX_IFA 5     
#define RTAX_AUTHOR 6  
#define RTAX_BRD 7     
#define RTAX_MAX 8     
struct rt_addrinfo {
  int rti_addrs;
  struct sockaddr *rti_info[RTAX_MAX];
};
struct route_cb {
  int ip_count;
  int ip6_count;
  int ipx_count;
  int ns_count;
  int iso_count;
  int any_count;
};
#ifdef PRIVATE
#define IFSCOPE_NONE 0
#endif 
#ifdef KERNEL_PRIVATE
#define CTRACE_STACK_SIZE 8 
#define CTRACE_HIST_SIZE 4  
typedef struct ctrace {
  void *th;                    
  void *pc[CTRACE_STACK_SIZE]; 
} ctrace_t;
extern void ctrace_record(ctrace_t *);
#define RT_LOCK_ASSERT_HELD(_rt)                                               \
  lck_mtx_assert(&(_rt)->rt_lock, LCK_MTX_ASSERT_OWNED)
#define RT_LOCK_ASSERT_NOTHELD(_rt)                                            \
  lck_mtx_assert(&(_rt)->rt_lock, LCK_MTX_ASSERT_NOTOWNED)
#define RT_LOCK(_rt)                                                           \
  do {                                                                         \
    if (!rte_debug)                                                            \
      lck_mtx_lock(&(_rt)->rt_lock);                                           \
    else                                                                       \
      rt_lock(_rt, FALSE);                                                     \
  } while (0)
#define RT_LOCK_SPIN(_rt)                                                      \
  do {                                                                         \
    if (!rte_debug)                                                            \
      lck_mtx_lock_spin(&(_rt)->rt_lock);                                      \
    else                                                                       \
      rt_lock(_rt, TRUE);                                                      \
  } while (0)
#define RT_CONVERT_LOCK(_rt)                                                   \
  do {                                                                         \
    RT_LOCK_ASSERT_HELD(_rt);                                                  \
    lck_mtx_convert_spin(&(_rt)->rt_lock);                                     \
  } while (0)
#define RT_UNLOCK(_rt)                                                         \
  do {                                                                         \
    if (!rte_debug)                                                            \
      lck_mtx_unlock(&(_rt)->rt_lock);                                         \
    else                                                                       \
      rt_unlock(_rt);                                                          \
  } while (0)
#define RT_ADDREF_LOCKED(_rt)                                                  \
  do {                                                                         \
    if (!rte_debug) {                                                          \
      RT_LOCK_ASSERT_HELD(_rt);                                                \
      if (++(_rt)->rt_refcnt == 0)                                             \
        panic("RT_ADDREF(%p) bad refcnt\n", _rt);                              \
    } else {                                                                   \
      rtref(_rt);                                                              \
    }                                                                          \
  } while (0)
#define RT_ADDREF(_rt)                                                         \
  do {                                                                         \
    RT_LOCK_SPIN(_rt);                                                         \
    RT_ADDREF_LOCKED(_rt);                                                     \
    RT_UNLOCK(_rt);                                                            \
  } while (0)
#define RT_REMREF_LOCKED(_rt)                                                  \
  do {                                                                         \
    if (!rte_debug) {                                                          \
      RT_LOCK_ASSERT_HELD(_rt);                                                \
      if ((_rt)->rt_refcnt == 0)                                               \
        panic("RT_REMREF(%p) bad refcnt\n", _rt);                              \
      --(_rt)->rt_refcnt;                                                      \
    } else {                                                                   \
      (void)rtunref(_rt);                                                      \
    }                                                                          \
  } while (0)
#define RT_REMREF(_rt)                                                         \
  do {                                                                         \
    RT_LOCK_SPIN(_rt);                                                         \
    RT_REMREF_LOCKED(_rt);                                                     \
    RT_UNLOCK(_rt);                                                            \
  } while (0)
#define RTFREE(_rt) rtfree(_rt)
#define RTFREE_LOCKED(_rt) rtfree_locked(_rt)
extern struct route_cb route_cb;
extern struct radix_node_head *rt_tables[AF_MAX + 1];
__private_extern__ lck_mtx_t *rnh_lock;
__private_extern__ int use_routegenid;
__private_extern__ uint32_t route_generation;
__private_extern__ int rttrash;
__private_extern__ unsigned int rte_debug;
struct ifmultiaddr;
struct proc;
extern void route_init(void) __attribute__((section("__TEXT, initcode")));
extern void routegenid_update(void);
extern void rt_ifmsg(struct ifnet *);
extern void rt_missmsg(int, struct rt_addrinfo *, int, int);
extern void rt_newaddrmsg(int, struct ifaddr *, int, struct rtentry *);
extern void rt_newmaddrmsg(int, struct ifmultiaddr *);
extern int rt_setgate(struct rtentry *, struct sockaddr *, struct sockaddr *);
extern void set_primary_ifscope(unsigned int);
extern unsigned int get_primary_ifscope(void);
extern boolean_t rt_inet_default(struct rtentry *, struct sockaddr *);
extern struct rtentry *rt_lookup(boolean_t, struct sockaddr *,
                                 struct sockaddr *, struct radix_node_head *,
                                 unsigned int);
extern void rtalloc(struct route *);
extern void rtalloc_ign(struct route *, uint32_t);
extern void rtalloc_ign_locked(struct route *, uint32_t);
extern void rtalloc_scoped_ign(struct route *, uint32_t, unsigned int);
extern void rtalloc_scoped_ign_locked(struct route *, uint32_t, unsigned int);
extern struct rtentry *rtalloc1(struct sockaddr *, int, uint32_t);
extern struct rtentry *rtalloc1_locked(struct sockaddr *, int, uint32_t);
extern struct rtentry *rtalloc1_scoped(struct sockaddr *, int, uint32_t,
                                       unsigned int);
extern struct rtentry *rtalloc1_scoped_locked(struct sockaddr *, int, uint32_t,
                                              unsigned int);
extern void rtfree(struct rtentry *);
extern void rtfree_locked(struct rtentry *);
extern void rtref(struct rtentry *);
extern int rtunref(struct rtentry *);
extern void rtsetifa(struct rtentry *, struct ifaddr *);
extern int rtinit(struct ifaddr *, int, int);
extern int rtinit_locked(struct ifaddr *, int, int);
extern int rtioctl(unsigned long, caddr_t, struct proc *);
extern void rtredirect(struct ifnet *, struct sockaddr *, struct sockaddr *,
                       struct sockaddr *, int, struct sockaddr *,
                       struct rtentry **);
extern int rtrequest(int, struct sockaddr *, struct sockaddr *,
                     struct sockaddr *, int, struct rtentry **);
extern int rtrequest_locked(int, struct sockaddr *, struct sockaddr *,
                            struct sockaddr *, int, struct rtentry **);
extern int rtrequest_scoped_locked(int, struct sockaddr *, struct sockaddr *,
                                   struct sockaddr *, int, struct rtentry **,
                                   unsigned int);
extern unsigned int sa_get_ifscope(struct sockaddr *);
extern void rt_lock(struct rtentry *, boolean_t);
extern void rt_unlock(struct rtentry *);
extern struct sockaddr *rtm_scrub_ifscope(int, struct sockaddr *,
                                          struct sockaddr *,
                                          struct sockaddr_storage *);
#endif 
#endif