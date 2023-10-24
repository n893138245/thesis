#ifndef light_hashmap_hpp
#define light_hashmap_hpp
#include <stdio.h>
namespace instrument {
    #define MAP_MISSING -3  
    #define MAP_FULL -2 	
    #define MAP_OMEM -1 	
    #define MAP_OK 0 	
    typedef void *any_t;
    typedef int (*PFany)(any_t, any_t, unsigned long);
    typedef any_t map_t;
    map_t hashmap_new();
    extern int hashmap_iterate(map_t in, PFany f, any_t item);
    extern int hashmap_put(map_t in, unsigned long key, any_t value);
    extern int hashmap_get(map_t in, unsigned long key, any_t *arg);
    extern int hashmap_remove(map_t in, unsigned long key);
    extern int hashmap_get_one(map_t in, any_t *arg, int remove);
    extern void hashmap_free(map_t in);
    extern int hashmap_length(map_t in);
}
#endif 