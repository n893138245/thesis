#import "AWSEXTRuntimeExtensions.h"
#import <Foundation/Foundation.h>
awsmtl_propertyAttributes *awsmtl_copyPropertyAttributes (objc_property_t property) {
    const char * const attrString = property_getAttributes(property);
    if (!attrString) {
        fprintf(stderr, "ERROR: Could not get attribute string from property %s\n", property_getName(property));
        return NULL;
    }
    if (attrString[0] != 'T') {
        fprintf(stderr, "ERROR: Expected attribute string \"%s\" for property %s to start with 'T'\n", attrString, property_getName(property));
        return NULL;
    }
    const char *typeString = attrString + 1;
    const char *next = NSGetSizeAndAlignment(typeString, NULL, NULL);
    if (!next) {
        fprintf(stderr, "ERROR: Could not read past type in attribute string \"%s\" for property %s\n", attrString, property_getName(property));
        return NULL;
    }
    size_t typeLength = next - typeString;
    if (!typeLength) {
        fprintf(stderr, "ERROR: Invalid type in attribute string \"%s\" for property %s\n", attrString, property_getName(property));
        return NULL;
    }
    awsmtl_propertyAttributes *attributes = calloc(1, sizeof(awsmtl_propertyAttributes) + typeLength + 1);
    if (!attributes) {
        fprintf(stderr, "ERROR: Could not allocate awsmtl_propertyAttributes structure for attribute string \"%s\" for property %s\n", attrString, property_getName(property));
        return NULL;
    }
    strncpy(attributes->type, typeString, typeLength);
    attributes->type[typeLength] = '\0';
    if (typeString[0] == *(@encode(id)) && typeString[1] == '"') {
        const char *className = typeString + 2;
        next = strchr(className, '"');
        if (!next) {
            fprintf(stderr, "ERROR: Could not read class name in attribute string \"%s\" for property %s\n", attrString, property_getName(property));
            return NULL;
        }
        if (className != next) {
            size_t classNameLength = next - className;
            char trimmedName[classNameLength + 1];
            strncpy(trimmedName, className, classNameLength);
            trimmedName[classNameLength] = '\0';
            attributes->objectClass = objc_getClass(trimmedName);
        }
    }
    if (*next != '\0') {
        next = strchr(next, ',');
    }
    while (next && *next == ',') {
        char flag = next[1];
        next += 2;
        switch (flag) {
        case '\0':
            break;
        case 'R':
            attributes->readonly = YES;
            break;
        case 'C':
            attributes->memoryManagementPolicy = awsmtl_propertyMemoryManagementPolicyCopy;
            break;
        case '&':
            attributes->memoryManagementPolicy = awsmtl_propertyMemoryManagementPolicyRetain;
            break;
        case 'N':
            attributes->nonatomic = YES;
            break;
        case 'G':
        case 'S':
            {
                const char *nextFlag = strchr(next, ',');
                SEL name = NULL;
                if (!nextFlag) {
                    const char *selectorString = next;
                    next = "";
                    name = sel_registerName(selectorString);
                } else {
                    size_t selectorLength = nextFlag - next;
                    if (!selectorLength) {
                        fprintf(stderr, "ERROR: Found zero length selector name in attribute string \"%s\" for property %s\n", attrString, property_getName(property));
                        goto errorOut;
                    }
                    char selectorString[selectorLength + 1];
                    strncpy(selectorString, next, selectorLength);
                    selectorString[selectorLength] = '\0';
                    name = sel_registerName(selectorString);
                    next = nextFlag;
                }
                if (flag == 'G')
                    attributes->getter = name;
                else
                    attributes->setter = name;
            }
            break;
        case 'D':
            attributes->dynamic = YES;
            attributes->ivar = NULL;
            break;
        case 'V':
            if (*next == '\0') {
                attributes->ivar = NULL;
            } else {
                attributes->ivar = next;
                next = "";
            }
            break;
        case 'W':
            attributes->weak = YES;
            break;
        case 'P':
            attributes->canBeCollected = YES;
            break;
        case 't':
            fprintf(stderr, "ERROR: Old-style type encoding is unsupported in attribute string \"%s\" for property %s\n", attrString, property_getName(property));
            while (*next != ',' && *next != '\0')
                ++next;
            break;
        default:
            fprintf(stderr, "ERROR: Unrecognized attribute string flag '%c' in attribute string \"%s\" for property %s\n", flag, attrString, property_getName(property));
        }
    }
    if (next && *next != '\0') {
        fprintf(stderr, "Warning: Unparsed data \"%s\" in attribute string \"%s\" for property %s\n", next, attrString, property_getName(property));
    }
    if (!attributes->getter) {
        attributes->getter = sel_registerName(property_getName(property));
    }
    if (!attributes->setter) {
        const char *propertyName = property_getName(property);
        size_t propertyNameLength = strlen(propertyName);
        size_t setterLength = propertyNameLength + 4;
        char setterName[setterLength + 1];
        strncpy(setterName, "set", 3);
        strncpy(setterName + 3, propertyName, propertyNameLength);
        setterName[3] = (char)toupper(setterName[3]);
        setterName[setterLength - 1] = ':';
        setterName[setterLength] = '\0';
        attributes->setter = sel_registerName(setterName);
    }
    return attributes;
errorOut:
    free(attributes);
    return NULL;
}