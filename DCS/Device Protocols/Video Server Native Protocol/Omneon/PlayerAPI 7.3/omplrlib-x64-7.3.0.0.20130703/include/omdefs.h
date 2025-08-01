/*********************************************************************
 Filename:    omdefs.h

 Description:  Some basic type definitions

 Copyright (c) 2001-2007 Omneon Video Networks (TM)

 OMNEON VIDEO NETWORKS CONFIDENTIAL
***********************************************************************/

#ifndef _OMDEFS_H_
#define _OMDEFS_H_

#ifdef __unix__
#include <sys/types.h>
#else
#ifndef UINT_DEFINED
typedef unsigned int uint;
#endif
#endif

#ifdef _WIN32
#if defined (_MSC_VER) || defined (__BORLANDC__)
typedef __int64 int_64;
typedef unsigned __int64 uint_64;
#else

#ifndef __TCHAR_DEFINED
#ifdef UNICODE
#define TCHAR unsigned short
#else
#define TCHAR char 
#endif /* UNICODE */
#endif /* __TCHAR_DEFINED */
#endif /* _MSC_VER */
#endif /* _WIN32 */

#if defined(__GNUC__) && !defined(__OMNEONTYPES_H)
#ifdef __MACH__
#include <stdint.h>
typedef int64_t  int_64;
typedef uint64_t uint_64;
#else
#ifndef _LP64
typedef long long int_64;
typedef unsigned long long uint_64;
#else
typedef long int_64;
typedef unsigned long uint_64;
#endif
#endif
#endif

#endif
