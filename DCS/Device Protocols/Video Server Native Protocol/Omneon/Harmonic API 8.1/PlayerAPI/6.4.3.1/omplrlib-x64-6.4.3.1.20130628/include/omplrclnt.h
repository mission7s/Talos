/*********************************************************************
 Filename:    omplayerclnt.h

 Description: Prototypes for client remote player interface.

 Revision History:

 Copyright (c) 1998-2012, Harmonic Inc. All rights reserved.
***********************************************************************/

/* Note: This header is used to auto-generate API documentation using Doxygen.
   For more, read README.OmneonUseOfDoxygen in this directory. */

/*! \file omplrclnt.h
 *  \brief Main Player API Header */

/*! \mainpage
 *
 * <b>Change Log</b>
 */

/*! \cond OmneonIgnore */

#ifndef _OMPLRCLNT_H_
#define _OMPLRCLNT_H_

#ifndef OMPLRLIB_C_API
#  ifndef _MSC_VER
#    define OMPLRLIB_C_API extern "C"
#  else
#    define OMPLRLIB_C_API
#  endif
#endif

#include <omdefs.h>
#include <omplrdefs.h>
#include <omtcdata.h>

#ifndef _WCHAR_T_DEFINED
typedef unsigned short wchar_t;
#define _WCHAR_T_DEFINED
#endif

// Convert a player error to a string
OMPLRLIB_C_API const char *OmPlrGetErrorStringA(OmPlrError error);
OMPLRLIB_C_API const wchar_t *OmPlrGetErrorStringW(OmPlrError error);

#ifdef UNICODE
#define OmPlrGetErrorString OmPlrGetErrorStringW
#else
#define OmPlrGetErrorString OmPlrGetErrorStringA
#endif

// **************************************************************************
// Clip functions. These functions operate on clips. The name of the functions
// all start with OmPlrClip

// Copy part or all of a clip into another clip. The copy is an
// asynchronous deep copy (the media is copied). A copy handle is returned
// in pCcHandle. This handle must be freed with OmPlrClipCopyFree().
// A srcStartFrame of ~0 means start at the first frame in the clip.
// A copyLength of ~0 means a length of start to the last frame in the clip.
// A clip being recorded can be copied while it is recording. The copy
// process will follow behind the record point and not exceed it. The copy
// will terminate when the source clip stops growing.
// Use srcStartFrame = ~0, copyLength = ~0, and dstStartFrame = ~0 to make an
// exact copy.
// Use srcStartFrame = ~0, copyLength = ~0, and dstStartFrame = 0 to copy
// entire clip to 0 offset into dst clip.
// ** NOTE ** copyUserData is ignored(user data is always copied)
OMPLRLIB_C_API OmPlrError OmPlrClipCopyW(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const wchar_t *pSrcClipName, // name of clip to copy
    const wchar_t *pDstClipName, // name of destination clip
    uint srcStartFrame,       // first frame of source clip to copy
    uint copyLength,          // length (in frames) to copy
    uint dstStartFrame,       // position of first copied frame in dst clip
    bool copyUserData,        // true to copy clip user data
    OmPlrClipCopyHandle *pCcHandle);// clip copy handle

OMPLRLIB_C_API OmPlrError OmPlrClipCopyA(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const char *pSrcClipName, // name of clip to copy
    const char *pDstClipName, // name of destination clip
    uint srcStartFrame,       // first frame of source clip to copy
    uint copyLength,          // length (in frames) to copy
    uint dstStartFrame,       // position of first copied frame in dst clip
    bool copyUserData,        // true to copy clip user data
    OmPlrClipCopyHandle *pCcHandle);// clip copy handle

#ifdef UNICODE
#define OmPlrClipCopy OmPlrClipCopyW
#else
#define OmPlrClipCopy OmPlrClipCopyA
#endif


// Abort a clip copy. This does NOT free the copy handle.
OMPLRLIB_C_API OmPlrError OmPlrClipCopyAbort(
    OmPlrHandle plrHandle,         // handle returned from OmPlrOpen()
    OmPlrClipCopyHandle ccHandle); // clip copy handle


// Enumerate clip copy handles.
OMPLRLIB_C_API OmPlrError OmPlrClipCopyEnumerate(
    OmPlrHandle plrHandle,          // handle returned from OmPlrOpen()
    OmPlrClipCopyHandle ccHandle[], // returned array of clip copy handles
    uint numHandles,                // size (number of handles) of above buffer
    uint *pNumRetHandles);          // returned number of handles


// Free a clip copy handle. Returns an error if copy is in progress.
OMPLRLIB_C_API OmPlrError OmPlrClipCopyFree(
    OmPlrHandle plrHandle,          // handle returned from OmPlrOpen()
    OmPlrClipCopyHandle ccHandle);  // clip copy handle


// Get a clip copy setup parameters.
OMPLRLIB_C_API OmPlrError OmPlrClipCopyGetParamsW(
    OmPlrHandle plrHandle,        // handle returned from OmPlrOpen()
    OmPlrClipCopyHandle ccHandle, // clip copy handle
    wchar_t *pSrcClipName,        // returned name of clip being copied
    uint srcClipNameSize,         // size of above buffer in characters
                                  // including terminating 0 (not in bytes)
    wchar_t *pDstClipName,        // returned name of clip being copied to
    uint dstClipNameSize,         // size of above buffer in characters
                                  // including terminating 0 (not in bytes)
    uint *pSrcStartFrame,         // returned source clip copy start frame
    uint *pCopyLength,            // returned copy length (in frames)
    uint *pDstStartFrame,         // returned dst clip copy start frame
    bool *pCopyUserData);         // returned true if copy user data

// Get a clip copy setup parameters.
OMPLRLIB_C_API OmPlrError OmPlrClipCopyGetParamsA(
    OmPlrHandle plrHandle,        // handle returned from OmPlrOpen()
    OmPlrClipCopyHandle ccHandle, // clip copy handle
    char *pSrcClipName,           // returned name of clip being copied
    uint srcClipNameSize,         // size of above buffer in characters
                                  // including terminating 0 (not in bytes)
    char *pDstClipName,           // returned name of clip being copied to
    uint dstClipNameSize,         // size of above buffer in characters
                                  // including terminating 0 (not in bytes)
    uint *pSrcStartFrame,         // returned source clip copy start frame
    uint *pCopyLength,            // returned copy length (in frames)
    uint *pDstStartFrame,         // returned dst clip copy start frame
    bool *pCopyUserData);         // returned true if copy user data

#ifdef UNICODE
#define OmPlrClipCopyGetParams OmPlrClipCopyGetParamsW
#else
#define OmPlrClipCopyGetParams OmPlrClipCopyGetParamsA
#endif    

// Get a clip copy status.
OMPLRLIB_C_API OmPlrError OmPlrClipCopyGetStatus(
    OmPlrHandle plrHandle,        // handle returned from OmPlrOpen()
    OmPlrClipCopyHandle ccHandle, // clip copy handle
    uint *pNumFramesCopied,       // returned number of frames copied
    uint *pCopyLength,            // returned total number of frames in copy
    bool *pDone,                  // returned true when done
    OmPlrError *pDoneStatus);     // returned error code(valid when done)
    

// Delete a clip.
OMPLRLIB_C_API OmPlrError OmPlrClipDeleteA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const char *pClipName); // name of clip to delete (in current clip dir)

OMPLRLIB_C_API OmPlrError OmPlrClipDeleteW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const wchar_t *pClipName); // name of clip to delete (in current clip dir)

#ifdef UNICODE
#define OmPlrClipDelete OmPlrClipDeleteW
#else
#define OmPlrClipDelete OmPlrClipDeleteA
#endif

// Get the current clip directory name. The clip directory is an attribute
// of the connection to the Director, not an attribute of the player.
// Clip names specified in other functions are relative to this directory.
// Set clipDirSize to the size in characters (not bytes) including the
// terminating 0 of clipDir buffer
OMPLRLIB_C_API OmPlrError OmPlrClipGetDirectoryA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    char *pClipDir,         // buffer to store the returned directory name
    uint clipDirSize);      // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrClipGetDirectoryW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    wchar_t *pClipDir,      // buffer to store the returned directory name
    uint clipDirSize);      // size of the above buffer

#ifdef UNICODE
#define OmPlrClipGetDirectory OmPlrClipGetDirectoryW
#else
#define OmPlrClipGetDirectory OmPlrClipGetDirectoryA
#endif


// Get clip extension list for this network connection. The extension list is a
// concatenated list of filename extensions that are used as clip identifiers.
// For example: for quicktime files and dv files the list would look like
// ".mov.dv"
// This clip extension list is an attribute of the network connection to the
// MediaServer, not an attribute of the player.
// Clip names specified in other functions use this list of extensions.
// Set extListSize to the size in characters (not bytes) including the
// terminating 0 of pExtList buffer
OMPLRLIB_C_API OmPlrError OmPlrClipGetExtListA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    char *pExtList,         // buffer to store the returned extension list
    uint extListSize);      // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrClipGetExtListW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    wchar_t *pExtList,      // buffer to store the returned extension list
    uint extListSize);      // size of the above buffer
#ifdef UNICODE
#define OmPlrClipGetExtList OmPlrClipGetExtListW
#else
#define OmPlrClipGetExtList OmPlrClipGetExtListA
#endif


// Returns file system total and free space (in bytes).
// The total space is all bytes allocated plus unallocated.
// The free space is the amount unallocated.
OMPLRLIB_C_API OmPlrError OmPlrClipGetFsSpace(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    uint_64 *pTotalBytes,   // size of the file system in bytes
    uint_64 *pFreeBytes);   // available size of the file system in bytes


// Check for clip existence.
OMPLRLIB_C_API OmPlrError OmPlrClipExistsA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const char *pClipName,  // name of the clip
    bool *pClipExists);     // returned true if clip exists

OMPLRLIB_C_API OmPlrError OmPlrClipExistsW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const wchar_t *pClipName, // name of the clip
    bool *pClipExists);     // returned true if clip exists

#ifdef UNICODE
#define OmPlrClipExists OmPlrClipExistsW
#else
#define OmPlrClipExists OmPlrClipExistsA
#endif

// Extract data from a clip, for example closed caption data.
// Extract data of type dataType from clip pClipName. Start at frame
// startFrame. Extract numFrames frames. Extract data into buffer pData.
// Set pDataSize to the size of the pData buffer. Upon successful return,
// pDataSize returns the amount of data extracted.
OMPLRLIB_C_API OmPlrError OmPlrClipExtractDataA(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const char *pClipName,    // name of clip
    uint startFrame,          // frame number to start extraction
    uint numFrames,           // number of frames to extract
    OmPlrClipDataType dataType, // type of data to extract
    unsigned char *pData,     // buffer to receive extracted data
    uint *pDataSize);         // size of buffer or data (in bytes)

OMPLRLIB_C_API OmPlrError OmPlrClipExtractDataW(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const wchar_t *pClipName, // name of clip
    uint startFrame,          // frame number to start extraction
    uint numFrames,           // number of frames to extract
    OmPlrClipDataType dataType, // type of data to extract
    unsigned char *pData,     // buffer to receive extracted data
    uint *pDataSize);         // size of buffer or data (in bytes)

#ifdef UNICODE
#define OmPlrClipExtractData OmPlrClipExtractDataW
#else
#define OmPlrClipExtractData OmPlrClipExtractDataA
#endif

// Get the first clip in the clip list.
// Set clipNameSize to the size in characters (not bytes) including the
// terminating 0 of clipName buffer.
// The clips are sorted in ascending creation order.
OMPLRLIB_C_API OmPlrError OmPlrClipGetFirstA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    char *pClipName,        // buffer to store returned clip name
    uint clipNameSize);     // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrClipGetFirstW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    wchar_t *pClipName,     // buffer to store returned clip name
    uint clipNameSize);     // size of the above buffer

#ifdef UNICODE
#define OmPlrClipGetFirst OmPlrClipGetFirstW
#else
#define OmPlrClipGetFirst OmPlrClipGetFirstA
#endif


// Get clip information. Old version.
OMPLRLIB_C_API OmPlrError OmPlrClipGetInfoA(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const char *pClipName,    // name of the clip
    OmPlrClipInfo *pClipInfo);// pointer to a user supplied clipInfo structure
                              // clipInfo.maxMsTracks and clipInfo.ms MUST
                              // be initialized before calling.

OMPLRLIB_C_API OmPlrError OmPlrClipGetInfoW(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const wchar_t *pClipName, // name of the clip
    OmPlrClipInfo *pClipInfo);// pointer to a user supplied clipInfo structure
                              // clipInfo.maxMsTracks and clipInfo.ms MUST
                              // be initialized before calling.
#ifdef UNICODE
#define OmPlrClipGetInfo OmPlrClipGetInfoW
#else
#define OmPlrClipGetInfo OmPlrClipGetInfoA
#endif

// Get clip information.
OMPLRLIB_C_API OmPlrError OmPlrClipGetInfo1A(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const char *pClipName,    // name of the clip
    OmPlrClipInfo1 *pClipInfo);// pointer to a user supplied clipInfo structure
                              // clipInfo.maxMsTracks and clipInfo.ms MUST
                              // be initialized before calling.

OMPLRLIB_C_API OmPlrError OmPlrClipGetInfo1W(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const wchar_t *pClipName, // name of the clip
    OmPlrClipInfo1 *pClipInfo);// pointer to a user supplied clipInfo structure
                              // clipInfo.maxMsTracks and clipInfo.ms MUST
                              // be initialized before calling.
#ifdef UNICODE
#define OmPlrClipGetInfo1 OmPlrClipGetInfo1W
#else
#define OmPlrClipGetInfo1 OmPlrClipGetInfo1A
#endif

// Get a full filename for a clip or a track within a clip.
// The tracks are numbered as follows. Track 0 is for the movie file.
// Tracks 1 to N are for the N video tracks. Tracks N+1 to N+M are for
// the M audio tracks. Use OmPlrClipGetInfo() to find the number of video
// and audio tracks. Each track may have more than one media file.
// These are accessed via the fileNum parameter. The first fileNum is 0.
// Set mediaNameSize to the size in characters (not bytes) including the
// terminating 0 of pMediaName buffer.
// This function returns omPlrEndOfList if the trackNum or fileNum are
// past the limits within the clip.
OMPLRLIB_C_API OmPlrError OmPlrClipGetMediaNameA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const char *pClipName,  // name of the clip
    uint trackNum,          // track selection
    uint fileNum,           // file selection, a track may have many files
    char *pMediaName,       // buffer to store returned media names
    uint mediaNameSize);    // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrClipGetMediaNameW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const wchar_t *pClipName, // name of the clip
    uint trackNum,          // track selection
    uint fileNum,           // file selection, a track may have many files
    wchar_t *pMediaName,    // buffer to store returned media names
    uint mediaNameSize);    // size of the above buffer

#ifdef UNICODE
#define OmPlrClipGetMediaName OmPlrClipGetMediaNameW
#else
#define OmPlrClipGetMediaName OmPlrClipGetMediaNameA
#endif

// Get the next clip in the clip list.
// Set clipNameSize to the size in characters (not bytes) including the
// terminating 0 of clipName buffer.
// The clips are sorted in ascending creation order.
OMPLRLIB_C_API OmPlrError OmPlrClipGetNextA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    char *pClipName,        // buffer to store returned clip name
    uint clipNameSize);     // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrClipGetNextW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    wchar_t *pClipName,     // buffer to store returned clip name
    uint clipNameSize);     // size of the above buffer

#ifdef UNICODE
#define OmPlrClipGetNext OmPlrClipGetNextW
#else
#define OmPlrClipGetNext OmPlrClipGetNextA
#endif


// Get the start timecode from a clip.
OMPLRLIB_C_API OmPlrError OmPlrClipGetStartTimecodeA(
    OmPlrHandle plrHandle,
    const char *clipName,
    OmTcData *startTc);

OMPLRLIB_C_API OmPlrError OmPlrClipGetStartTimecodeW(
    OmPlrHandle plrHandle,
    const wchar_t *clipName,
    OmTcData *startTc);

#ifdef UNICODE
#define OmPlrClipGetStartTimecode OmPlrClipGetStartTimecodeW
#else
#define OmPlrClipGetStartTimecode OmPlrClipGetStartTimecodeA
#endif


// Get track clip user data. Return the user data stored under pKey.
// Track 0 is for the movie file. Tracks 1 to N are for the N video tracks.
// Tracks N+1 to N+M are for the M audio tracks. Use OmPlrClipGetInfo()
// to find the number of video and audio tracks.
// Note, the returned data in *pData is not null terminated. *pRetDataSize
// is set to the size of the returned data in *pData.
OMPLRLIB_C_API OmPlrError OmPlrClipGetTrackUserDataA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const char *pClipName,  // name of clip
    int trackNum,           // track number
    const char *pKey,       // name of user data key
    unsigned char *pData,   // returned user data
    uint dataSize,          // size (in bytes) of the above buffer
    uint *pRetDataSize);    // size (in bytes) of the returned user data

OMPLRLIB_C_API OmPlrError OmPlrClipGetTrackUserDataW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const wchar_t *pClipName, // name of clip
    int trackNum,           // track number
    const char *pKey,       // name of user data key
    unsigned char *pData,   // returned user data
    uint dataSize,          // size (in bytes) of the above buffer
    uint *pRetDataSize);    // size (in bytes) of the returned user data

#ifdef UNICODE
#define OmPlrClipGetTrackUserData OmPlrClipGetTrackUserDataW
#else
#define OmPlrClipGetTrackUserData OmPlrClipGetTrackUserDataA
#endif

// Get track clip user data by index. Return the n'th user data/key pair.
// Track 0 is for the movie file. Tracks 1 to N are for the N video tracks.
// Tracks N+1 to N+M are for the M audio tracks. Use OmPlrClipGetInfo()
// to find the number of video and audio tracks.
// Note, the returned data in *data is not null terminated. *retDataSize
// is set to the size of the returned data in *data.
OMPLRLIB_C_API OmPlrError OmPlrClipGetTrackUserDataAndKeyW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const wchar_t *pClipName, // name of clip
    int trackNum,           // track number
    uint dataIdex,          // n (for n'th key/data pair) (0 - n-1)
    char *pKey,             // returned user data key
    uint keySize,           // size (in bytes) of the above buffer
    unsigned char *data,    // returned user data value
    uint dataSize,          // size (in bytes) of the above buffer
    uint *retDataSize);     // returned user data size

OMPLRLIB_C_API OmPlrError OmPlrClipGetTrackUserDataAndKeyA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const char *pClipName,  // name of clip
    int trackNum,           // track number
    uint dataIdex,          // n (for n'th key/data pair) (0 - n-1)
    char *pKey,             // returned user data key
    uint keySize,           // size (in bytes) of the above buffer
    unsigned char *data,    // returned user data value
    uint dataSize,          // size (in bytes) of the above buffer
    uint *retDataSize);     // returned user data size

#ifdef UNICODE
#define OmPlrClipGetTrackUserDataAndKey OmPlrClipGetTrackUserDataAndKeyW
#else
#define OmPlrClipGetTrackUserDataAndKey OmPlrClipGetTrackUserDataAndKeyA
#endif

// Get clip user data. Return the user data stored under pKey.
// Note, the returned data in *pData is not null terminated. *pRetDataSize
// is set to the size of the returned data in *pData.
OMPLRLIB_C_API OmPlrError OmPlrClipGetUserDataW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const wchar_t *pClipName, // name of clip
    const char *pKey,       // name of user data key
    unsigned char *pData,   // returned user data
    uint dataSize,          // size (in bytes) of the above buffer
    uint *pRetDataSize);    // size (in bytes) of the returned user data

OMPLRLIB_C_API OmPlrError OmPlrClipGetUserDataA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const char *pClipName,  // name of clip
    const char *pKey,       // name of user data key
    unsigned char *pData,   // returned user data
    uint dataSize,          // size (in bytes) of the above buffer
    uint *pRetDataSize);    // size (in bytes) of the returned user data

#ifdef UNICODE
#define OmPlrClipGetUserData OmPlrClipGetUserDataW
#else
#define OmPlrClipGetUserData OmPlrClipGetUserDataA
#endif

// Get clip user data by index. Return the n'th user data/key pair.
// Note, the returned data in *data is not null terminated. *retDataSize
// is set to the size of the returned data in *data.
OMPLRLIB_C_API OmPlrError OmPlrClipGetUserDataAndKeyW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const wchar_t *pClipName, // name of clip
    uint dataIndex,         // n (for n'th key/data pair) (0 - n-1)
    char *pKey,             // returned user data key
    uint keySize,           // size (in bytes) of the above buffer
    unsigned char *data,    // returned user data value
    uint dataSize,          // size (in bytes) of the above buffer
    uint *retDataSize);     // returned user data size

OMPLRLIB_C_API OmPlrError OmPlrClipGetUserDataAndKeyA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const char *pClipName,  // name of clip
    uint dataIndex,         // n (for n'th key/data pair) (0 - n-1)
    char *pKey,             // returned user data key
    uint keySize,           // size (in bytes) of the above buffer
    unsigned char *data,    // returned user data value
    uint dataSize,          // size (in bytes) of the above buffer
    uint *retDataSize);     // returned user data size

#ifdef UNICODE
#define OmPlrClipGetUserDataAndKey OmPlrClipGetUserDataAndKeyW
#else
#define OmPlrClipGetUserDataAndKey OmPlrClipGetUserDataAndKeyA
#endif

// Insert data into a clip, for example closed caption data.
// Insert data of type dataType into clip pClipName. Start at frame
// startFrame. Insert numFrames frames. Insert data from pData.
// Set pDataSize to the size of the pData buffer. Upon successful return,
// pDataSize returns the amount of data inserted.
OMPLRLIB_C_API OmPlrError OmPlrClipInsertDataW(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const wchar_t *pClipName, // name of clip
    uint startFrame,          // frame number to start insertion
    uint numFrames,           // number of frames to insert
    OmPlrClipDataType dataType, // type of data to insert
    unsigned char *pData,     // buffer containing insertion data
    uint *pDataSize);         // size of buffer or data (in bytes)

OMPLRLIB_C_API OmPlrError OmPlrClipInsertDataA(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const char *pClipName,    // name of clip
    uint startFrame,          // frame number to start insertion
    uint numFrames,           // number of frames to insert
    OmPlrClipDataType dataType, // type of data to insert
    unsigned char *pData,     // buffer containing insertion data
    uint *pDataSize);         // size of buffer or data (in bytes)

#ifdef UNICODE
#define OmPlrClipInsertData OmPlrClipInsertDataW
#else
#define OmPlrClipInsertData OmPlrClipInsertDataA
#endif

// Register callbacks for clip list changes. The added callback will be called
// for each clip added. The delete callback will be called for each clip
// deleted. Register 0 as the callback function to disable the callback.
// The callbacks execute in a thread created when OmPlrRegisterCallbacks()
// is called.
OMPLRLIB_C_API OmPlrError OmPlrClipRegisterCallbacksW(
    OmPlrHandle plrHandle,                 // handle returned from OmPlrOpen()
    void (*pAddedCallback)(const wchar_t *pClipName, int param),// add callback
    int addedParam,                                            // add parameter
    void (*pDeletedCallback)(const wchar_t *pClipName,int param),//del callback
    int deletedParam);                                         // del parameter

OMPLRLIB_C_API OmPlrError OmPlrClipRegisterCallbacksA(
    OmPlrHandle plrHandle,                 // handle returned from OmPlrOpen()
    void (*pAddedCallback)(const char *pClipName, int param),  // add callback
    int addedParam,                                            // add parameter
    void (*pDeletedCallback)(const char *pClipName, int param),// del callback
    int deletedParam);                                         // del parameter

#ifdef UNICODE
#define OmPlrClipRegisterCallbacks OmPlrClipRegisterCallbacksW
#else
#define OmPlrClipRegisterCallbacks OmPlrClipRegisterCallbacksA
#endif
                      

// Register callbacks for clip open/close for write changes. The openForWrite
// callback will be called when a clip file is opened for write. The 
// closeForWrite callback will be called for each clip file closed if it
// had been opened for write.
// Register 0 as the callback function to disable the callback.
OMPLRLIB_C_API OmPlrError OmPlrClipRegisterWriteCallbacksW(
    OmPlrHandle plrHandle,                 // handle returned from OmPlrOpen()
    void (*openForWriteCallback)(const wchar_t *name,int param),//open callback
    int openParam,                                            // open param
    void (*closeForWriteCallback)(const wchar_t *name,int param),//close callback 
    int closeParam);                                          // close param

OMPLRLIB_C_API OmPlrError OmPlrClipRegisterWriteCallbacksA(
    OmPlrHandle plrHandle,                 // handle returned from OmPlrOpen()
    void (*openForWriteCallback)(const char *name, int param),// open callback
    int openParam,                                            // open param
    void (*closeForWriteCallback)(const char *name,int param),//close callback 
    int closeParam);                                          // close param 

#ifdef UNICODE
#define OmPlrClipRegisterWriteCallbacks OmPlrClipRegisterWriteCallbacksW
#else
#define OmPlrClipRegisterWriteCallbacks OmPlrClipRegisterWriteCallbacksA
#endif
                      
// Rename a clip.
OMPLRLIB_C_API OmPlrError OmPlrClipRenameA(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const char *pOldClipName, // name of clip to rename
    const char *pNewClipName);// new name of clip

OMPLRLIB_C_API OmPlrError OmPlrClipRenameW(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const wchar_t *pOldClipName, // name of clip to rename
    const wchar_t *pNewClipName);// new name of clip

#ifdef UNICODE
#define OmPlrClipRename OmPlrClipRenameW
#else
#define OmPlrClipRename OmPlrClipRenameA
#endif

// Set clip default in and out point. This data is stored in the clip.
OMPLRLIB_C_API OmPlrError OmPlrClipSetDefaultInOutA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const char *pClipName,  // name of clip
    uint clipDefaultIn,     // new default in point
    uint clipDefaultOut);   // new default out point
OMPLRLIB_C_API OmPlrError OmPlrClipSetDefaultInOutW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const wchar_t *pClipName, // name of clip
    uint clipDefaultIn,     // new default in point
    uint clipDefaultOut);   // new default out point

#ifdef _UNICODE
#define OmPlrClipSetDefaultInOut OmPlrClipSetDefaultInOutW
#else
#define OmPlrClipSetDefaultInOut OmPlrClipSetDefaultInOutA
#endif


// Set clip directory for this network connection. This directory
// is used for loading, listing, and deleting clips.
OMPLRLIB_C_API OmPlrError OmPlrClipSetDirectoryA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const char *pClipDir);  // name of clip director (include leading /)

OMPLRLIB_C_API OmPlrError OmPlrClipSetDirectoryW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const wchar_t *pClipDir); // name of clip director (include leading /)

#ifdef _UNICODE
#define OmPlrClipSetDirectory OmPlrClipSetDirectoryW
#else
#define OmPlrClipSetDirectory OmPlrClipSetDirectoryA
#endif

// Set clip extension list for this network connection. The extension list is a
// concatenated list of filename extensions that are used as clip identifiers.
// For example: for quicktime files and dv files the list would look like
// ".mov.dv"
// This clip extension list is an attribute of the network connection to the
// MediaServer, not an attribute of the player.
// Clip names specified in other functions use this list of extensions.
OMPLRLIB_C_API OmPlrError OmPlrClipSetExtListW(
    OmPlrHandle plrHandle,         // handle returned from OmPlrOpen()
    const wchar_t *pClipExtList);  // clip extension list ex. ".mov.dv"

OMPLRLIB_C_API OmPlrError OmPlrClipSetExtListA(
    OmPlrHandle plrHandle,      // handle returned from OmPlrOpen()
    const char *pClipExtList);  // clip extension list ex. ".mov.dv"

#ifdef _UNICODE
#define OmPlrClipSetExtList OmPlrClipSetExtListW
#else
#define OmPlrClipSetExtList OmPlrClipSetExtListA
#endif

// Set clip protection. A protected clip cannot be deleted. Use
// OmPlrClipGetInfo() to determine if a clip is protected.
OMPLRLIB_C_API OmPlrError OmPlrClipSetProtectionW(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const wchar_t *pClipName, // name of clip
    bool clipProtection);     // set true to protect the clip

OMPLRLIB_C_API OmPlrError OmPlrClipSetProtectionA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const char *pClipName,  // name of clip
    bool clipProtection);   // set true to protect the clip

#ifdef _UNICODE
#define OmPlrClipSetProtection OmPlrClipSetProtectionW
#else
#define OmPlrClipSetProtection OmPlrClipSetProtectionA
#endif

// Set the start timecode from a clip.
OMPLRLIB_C_API OmPlrError OmPlrClipSetStartTimecodeA(
    OmPlrHandle plrHandle,
    const char *clipName,
    OmTcData startTc);

OMPLRLIB_C_API OmPlrError OmPlrClipSetStartTimecodeW(
    OmPlrHandle plrHandle,
    const wchar_t *clipName,
    OmTcData startTc);

#ifdef UNICODE
#define OmPlrClipSetStartTimecode OmPlrClipSetStartTimecodeW
#else
#define OmPlrClipSetStartTimecode OmPlrClipSetStartTimecodeA
#endif


// Set track clip user data. The pData is stored under the pKey. Omneon
// recommends using key strings that start with something unique to your
// company to avoid key collision.  Specify zero length data to delete a
// user data key. Note that pData must not be NULL even if dataSize is 0,
// or the call will fail.
// Tracks 1 to N are for the N video tracks. Tracks N+1 to N+M are for
// the M audio tracks. Use OmPlrClipGetInfo() to find the number of video
// and audio tracks.
OMPLRLIB_C_API OmPlrError OmPlrClipSetTrackUserDataA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const char *pClipName,  // name of clip
    int trackNum,           // track number (0..n-1)
    const char *pKey,       // name of user data key
    const unsigned char *pData,// user data
    uint dataSize);         // size (in bytes) of user data

OMPLRLIB_C_API OmPlrError OmPlrClipSetTrackUserDataW(
    OmPlrHandle plrHandle,      // handle returned from OmPlrOpen()
    const wchar_t *pClipName,   // name of clip
    int trackNum,               // track number (0..n-1)
    const char *pKey,           // name of user data key
    const unsigned char *pData, // user data
    uint dataSize);             // size (in bytes) of user data

#ifdef UNICODE
#define OmPlrClipSetTrackUserData OmPlrClipSetTrackUserDataW
#else
#define OmPlrClipSetTrackUserData OmPlrClipSetTrackUserDataA
#endif


// Set clip user data. The pData is stored under the pKey. Omneon recommends
// using key strings that start with something unique to your company to avoid
// key collision.  Specify zero length data to delete a user data key. Note
// that pData must not be NULL even if dataSize is 0, or the call will fail.
OMPLRLIB_C_API OmPlrError OmPlrClipSetUserDataA(
    OmPlrHandle plrHandle,      // handle returned from OmPlrOpen()
    const char *pClipName,      // name of clip
    const char *pKey,           // name of user data key
    const unsigned char *pData, // user data
    uint dataSize);             // size (in bytes) of user data

OMPLRLIB_C_API OmPlrError OmPlrClipSetUserDataW(
    OmPlrHandle plrHandle,      // handle returned from OmPlrOpen()
    const wchar_t *pClipName,   // name of clip
    const char *pKey,           // name of user data key
    const unsigned char *pData, // user data
    uint dataSize);             // size (in bytes) of user data
#ifdef UNICODE
#define OmPlrClipSetUserData OmPlrClipSetUserDataW
#else
#define OmPlrClipSetUserData OmPlrClipSetUserDataA
#endif


// Returns the serial number of the server recording the specified clip. The
// clip may not yet be actually recording even when reported as recording as
// it may only be queued up for recording. Further, the clip may never be 
// recorded if the player is stopped before the record begins.
// Returns a zero length string if not recording.
OMPLRLIB_C_API OmPlrError OmPlrClipWhereRecordingA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const char *pClipName,  // name of the clip
    char *pSerialNumber,    // buffer to store returned serial number
    uint serialNumberSize); // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrClipWhereRecordingW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    const wchar_t *pClipName, // name of the clip
    char *pSerialNumber,    // buffer to store returned serial number
    uint serialNumberSize); // size of the above buffer

#ifdef UNICODE
#define OmPlrClipWhereRecording OmPlrClipWhereRecordingW
#else
#define OmPlrClipWhereRecording OmPlrClipWhereRecordingA
#endif



// ***************************************************************************
// Player functions


// Attach a clip to the timeline. If the clip does not exist, it is created.
// If an empty clip is later detached (before recording into it), it is
// deleted. Returns a handle to the attached clip.
OMPLRLIB_C_API OmPlrError OmPlrAttachA(
    OmPlrHandle plrHandle,           // handle returned from OmPlrOpen()
    const char *pClipName,           // name of the clip
    uint clipIn,                     // clip in point (inclusive)
    uint clipOut,                    // clip out point (exclusive)
    OmPlrClipHandle beforeClipHandle,// attach the clip before this clip
    OmPlrShiftMode shiftMode,        // shift existing clips in this manner
    OmPlrClipHandle *pClipHandle);   // returned handle to attached clip

OMPLRLIB_C_API OmPlrError OmPlrAttachW(
    OmPlrHandle plrHandle,           // handle returned from OmPlrOpen()
    const wchar_t *pClipName,        // name of the clip
    uint clipIn,                     // clip in point (inclusive)
    uint clipOut,                    // clip out point (exclusive)
    OmPlrClipHandle beforeClipHandle,// attach the clip before this clip
    OmPlrShiftMode shiftMode,        // shift existing clips in this manner
    OmPlrClipHandle *pClipHandle);   // returned handle to attached clip

#ifdef _UNICODE
#define OmPlrAttach OmPlrAttachW
#else
#define OmPlrAttach OmPlrAttachA
#endif


// Another version of OmPlrAttch. This one adds a modified track match string.
// The string must start with "audioM:" followed by a track match string
// described below. An example string is "audioM:token1/token2,token3,token4".
//
// A track match string is used when attaching a clip. It is compared against
// user data in the clip to select which tracks from the clip to map to player
// channels.
// The string has the following format:
//   token1/token2/token3,token4/token5
// Matching occurs between a token and clip track user data value for key
// "ovn_trackmatch". See OmPlrClipGetTrackUserData() and 
// OmPlrClipSetTrackUserData(). For the above track match string, the system
// first tries to find a clip track labeled  token1, token2 or token3 in that
// order. The first match will be used. Then it will look for a clip track
// labeled token4 or token5. Again, the first match will be used.
// There are some special token names.
// The special name silenceX where X is a number will cause X channels of
// silence to be used. For example: a match string such as "english/silence2"
// will first look for a clip track labeled "english" and failing that will
// use 2 channels of silence.
// The special name tracknumX where X is a number will always match clip
// track number X.
// The special name tracknolX where X is a number will match clip track
// number X if the track has no label.
//
// A token may be a compound token which is a series of tokens separated by
// '&'. For example token1 above may be replaced by tokenA&tokenB. The '&'
// notation means both tokens must be present. The string tokenA&tokenB/token2 
// would first look for both tokenA and tokenB. If either one is not present
// then move on looking for token2. If all tokens are found then all matching
// tracks are mapped.
// 
// A token may have a modifier suffix of the form :XoY where X and Y are
// digits (the suffix is four characters long). If X is not zero and does not
// match the number of channels then the token is ignored. A zero X matches
// any number of channels. Y is the number of channels this token represents.
// Y must be a multiple of the number of channels or be 0. A zero Y represents
// the number of channels. As an example, ENG:2o4 matches a 2-channel track
// labeled ENG and represents four channels (the track is used twice).
//
// The track match string pointer may be 0 or the track match string may
// be zero length.
OMPLRLIB_C_API OmPlrError OmPlrAttach1A(
    OmPlrHandle plrHandle,           // handle returned from OmPlrOpen()
    const char *pClipName,           // name of the clip
    uint clipIn,                     // clip in point (inclusive)
    uint clipOut,                    // clip out point (exclusive)
    OmPlrClipHandle beforeClipHandle,// attach the clip before this clip
    OmPlrShiftMode shiftMode,        // shift existing clips in this manner
    const char *pTrackMatch,         // optional track match string
    OmPlrClipHandle *pClipHandle);   // returned handle to attached clip

OMPLRLIB_C_API OmPlrError OmPlrAttach1W(
    OmPlrHandle plrHandle,           // handle returned from OmPlrOpen()
    const wchar_t *pClipName,        // name of the clip
    uint clipIn,                     // clip in point (inclusive)
    uint clipOut,                    // clip out point (exclusive)
    OmPlrClipHandle beforeClipHandle,// attach the clip before this clip
    OmPlrShiftMode shiftMode,        // shift existing clips in this manner
    const char *pTrackMatch,         // optional track match string
    OmPlrClipHandle *pClipHandle);   // returned handle to attached clip

#ifdef _UNICODE
#define OmPlrAttach1 OmPlrAttach1W
#else
#define OmPlrAttach1 OmPlrAttach1A
#endif


// Yet another version of OmPlrAttach. This one starts with OmPlrAttach1 and
// adds a OmPlrVideoFrameConvert parameter for up/down video conversion.
// This conversion mode applies only to the attached clip and overrides
// the default conversion mode specified on the player.
// The conversion mode only applies to players with appropriate media ports.
OMPLRLIB_C_API OmPlrError OmPlrAttach2A(
    OmPlrHandle plrHandle,           // handle returned from OmPlrOpen()
    const char *pClipName,           // name of the clip
    uint clipIn,                     // clip in point (inclusive)
    uint clipOut,                    // clip out point (exclusive)
    OmPlrClipHandle beforeClipHandle,// attach the clip before this clip
    OmPlrShiftMode shiftMode,        // shift existing clips in this manner
    const char *pTrackMatch,         // optional track match string
    OmPlrVideoFrameConvert vfc,      // video frame conversion mode
    OmPlrClipHandle *pClipHandle);   // returned handle to attached clip

OMPLRLIB_C_API OmPlrError OmPlrAttach2W(
    OmPlrHandle plrHandle,           // handle returned from OmPlrOpen()
    const wchar_t *pClipName,        // name of the clip
    uint clipIn,                     // clip in point (inclusive)
    uint clipOut,                    // clip out point (exclusive)
    OmPlrClipHandle beforeClipHandle,// attach the clip before this clip
    OmPlrShiftMode shiftMode,        // shift existing clips in this manner
    const char *pTrackMatch,         // optional track match string
    OmPlrVideoFrameConvert vfc,      // video frame conversion mode
    OmPlrClipHandle *pClipHandle);   // returned handle to attached clip

#ifdef _UNICODE
#define OmPlrAttach2 OmPlrAttach2W
#else
#define OmPlrAttach2 OmPlrAttach2A
#endif


// Close a connection to a remote player.
OMPLRLIB_C_API OmPlrError OmPlrClose(
    OmPlrHandle plrHandle); // handle returned from OmPlrOpen()


// Readies the player for playing. OmPlrCuePlay() blocks until the player has
// prefetched enough data to play at the given rate without freeze framing.
OMPLRLIB_C_API OmPlrError OmPlrCuePlay(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    double playRate);       // initial play rate


// Readies the player for recording. CueRecord blocks until the player is
// ready to record.
OMPLRLIB_C_API OmPlrError OmPlrCueRecord(
    OmPlrHandle plrHandle); // handle returned from OmPlrOpen()


// Another version of OmPlrCueRecord that takes an option argument.
// See OmPlrRecordOptions in omplrdefs.h
OMPLRLIB_C_API OmPlrError OmPlrCueRecord1(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    uint recordOptions);    // record options


// Remove a clip from the timeline.
OMPLRLIB_C_API OmPlrError OmPlrDetach(
    OmPlrHandle plrHandle,     // handle returned from OmPlrOpen()
    OmPlrClipHandle clipHandle,// handle of clip to remove
    OmPlrShiftMode shiftMode); // shift existing clips in this manner


// Remove all clips from the timeline.
OMPLRLIB_C_API OmPlrError OmPlrDetachAllClips(
    OmPlrHandle plrHandle); // handle returned from OmPlrOpen()


// Enables/Disables a players ability to play/record.
// The inherent play and or record capability is set by the System Manager. A
// player can only play if configured for play and enabled. Likewise for
// record it must be configured for record and enabled.
// Use OmPlrPlayEnabled() and OmPlrRecordEnabled() (or OmPlrGetPlayerStatus())
// to determine if the player can play or record.
OMPLRLIB_C_API OmPlrError OmPlrEnable(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    bool enable);           // set true to enable player


// Returns the application type set to control the player.
OMPLRLIB_C_API OmPlrError OmPlrGetApp(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    OmPlrApp *pPlayerApp);  // Returned application type


// Get the current player clip directory name. This clip directory is an
// attribute of the player, not an attribute of the network connection.
// This clip directory is used for control from VDCP, AVC, etc.
// Set clipDirSize to the size in characters (not bytes) including the
// terminating 0 of clipDir buffer
OMPLRLIB_C_API OmPlrError OmPlrGetAppClipDirectoryA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    char *clipDir,          // buffer to store the returned clip directory
    uint clipDirSize);      // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrGetAppClipDirectoryW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    wchar_t *clipDir,       // buffer to store the returned clip directory
    uint clipDirSize);      // size of the above buffer
#ifdef UNICODE
#define OmPlrGetAppClipDirectory OmPlrGetAppClipDirectoryW
#else
#define OmPlrGetAppClipDirectory OmPlrGetAppClipDirectoryA
#endif


// Get the current player clip extension list. The extension list is a
// concatenated list of filename extensions that are used as clip identifiers.
// For example: for quicktime files and dv files the list would look like
// ".mov.dv"
// This clip extension list is an attribute of the player, not an attribute
// of the network connection.
// This clip extension list is used for control from VDCP, AVC, etc.
// Set extListSize to the size in characters (not bytes) including the
// terminating 0 of extList buffer
OMPLRLIB_C_API OmPlrError OmPlrGetAppClipExtListA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    char *extList,          // buffer to store the returned extension list
    uint extListSize);      // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrGetAppClipExtListW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    wchar_t *extList,       // buffer to store the returned extension list
    uint extListSize);      // size of the above buffer

#ifdef UNICODE
#define OmPlrGetAppClipExtList OmPlrGetAppClipExtListW
#else
#define OmPlrGetAppClipExtList OmPlrGetAppClipExtListA
#endif


// Returns the clip handle of the num'th clip on the timeline.
// Returns 0 if no num'th clips. The first clip is clip 0.
OMPLRLIB_C_API OmPlrError OmPlrGetClipAtNum(
    OmPlrHandle plrHandle,        // handle returned from OmPlrOpen()
    int num,                      // which clip (first is 0)
    OmPlrClipHandle *pClipHandle);// returned clip handle of num'th clip


// Returns the handle of the clip located at the given timeline position.
// Returns 0 if no clip at position.
OMPLRLIB_C_API OmPlrError OmPlrGetClipAtPos(
    OmPlrHandle plrHandle,       // handle returned from OmPlrOpen()
    int pos,                     // timeline position
    OmPlrClipHandle *pClipHandle,// returned clip handle at specified
                                 // timeline pos
    int *pClipStartPos);      // returned timeline pos of the start of the clip


// Returns information about a clip on the timeline.
// This data can be modified with OmPlrSetClipData().
OMPLRLIB_C_API OmPlrError OmPlrGetClipData(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    OmPlrClipHandle clipHandle,// clip handle
    int *pPos,              // returned timeline position of start of clip
    uint *pClipIn,          // returned in point of clip
    uint *pClipOut,         // returned out point of clip
    uint *pClipLen);        // returned length of clip (out - in)


// Returns clip full name information about attached clips.
// Set clipNameSize to the size of clipName buffer in characters including
// the terminating 0 (not size in bytes)
OMPLRLIB_C_API OmPlrError OmPlrGetClipFullNameA(
    OmPlrHandle plrHandle,     // handle returned from OmPlrOpen()
    OmPlrClipHandle clipHandle,// clip handle
    char *pClipName,           // buffer to store the returned name of the clip
    uint clipNameSize);        // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrGetClipFullNameW(
    OmPlrHandle plrHandle,     // handle returned from OmPlrOpen()
    OmPlrClipHandle clipHandle,// clip handle
    wchar_t *pClipName,        // buffer to store the returned name of the clip
    uint clipNameSize);        // size of the above buffer

#ifdef UNICODE
#define OmPlrGetClipFullName OmPlrGetClipFullNameW
#else
#define OmPlrGetClipFullName OmPlrGetClipFullNameA
#endif

// Returns clip name information about attached clips.
// Set clipNameSize to the size of clipName buffer in characters including
// the terminating 0 (not size in bytes)
OMPLRLIB_C_API OmPlrError OmPlrGetClipNameA(
    OmPlrHandle plrHandle,     // handle returned from OmPlrOpen()
    OmPlrClipHandle clipHandle,// clip handle
    char *pClipName,           // buffer to store the returned name of the clip
    uint clipNameSize);        // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrGetClipNameW(
    OmPlrHandle plrHandle,     // handle returned from OmPlrOpen()
    OmPlrClipHandle clipHandle,// clip handle
    wchar_t *pClipName,        // buffer to store the returned name of the clip
    uint clipNameSize);        // size of the above buffer

#ifdef UNICODE
#define OmPlrGetClipName OmPlrGetClipNameW
#else
#define OmPlrGetClipName OmPlrGetClipNameA
#endif

// Returns clip path information (does not include clip name)
// Set clipPathSize to the size of clipPath buffer in characters including
// the terminating 0 (not size in bytes)
OMPLRLIB_C_API OmPlrError OmPlrGetClipPathA(
    OmPlrHandle plrHandle,     // handle returned from OmPlrOpen()
    OmPlrClipHandle clipHandle,// clip handle
    char *pClipPath,           // buffer to store the returned path of the clip
    uint clipPathSize);        // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrGetClipPathW(
    OmPlrHandle plrHandle,     // handle returned from OmPlrOpen()
    OmPlrClipHandle clipHandle,// clip handle
    wchar_t *pClipPath,        // buffer to store the returned path of the clip
    uint clipPathSize);        // size of the above buffer

#ifdef UNICODE
#define OmPlrGetClipPath OmPlrGetClipPathW
#else
#define OmPlrGetClipPath OmPlrGetClipPathA
#endif

// Returns the player drop/nondrop frame mode.
OMPLRLIB_C_API OmPlrError OmPlrGetDropFrame(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    bool *pDropFrame);      // returned true if the player is set drop-frame


// Get the first of the list of players.
// Set playerNameSize to the size in characters (not bytes) including the
// terminating 0 of playerName buffer
OMPLRLIB_C_API OmPlrError OmPlrGetFirstPlayerA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    char *pPlayerName,      // buffer to store the returned name of a player
    uint playerNameSize);   // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrGetFirstPlayerW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    wchar_t *pPlayerName,      // buffer to store the returned name of a player
    uint playerNameSize);   // size of the above buffer
#ifdef UNICODE
#define OmPlrGetFirstPlayer OmPlrGetFirstPlayerW
#else
#define OmPlrGetFirstPlayer OmPlrGetFirstPlayerA
#endif


// Returns the player frame rate. Player frame rate does not need to
// match the reference frame rate. 
OMPLRLIB_C_API OmPlrError OmPlrGetFrameRate(
    OmPlrHandle plrHandle,   // handle returned from OmPlrOpen()
    OmFrameRate *pFrameRate);// returned frame rate


// Returns the values set by OmPlrLoop(). Loop mode is disabled if minLoopPos
// equals maxLoopPos.
OMPLRLIB_C_API OmPlrError OmPlrGetLoop(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    int *pMinLoopPos,       // returned min loop position (inclusive)
    int *pMaxLoopPos);      // returned max loop position (exclusive)


// Returns the maximum player position. The player position will not move
// past (including) this position. It is set with OmPlrSetMaxPos().
OMPLRLIB_C_API OmPlrError OmPlrGetMaxPos(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    int *pMaxPos);          // returned max timeline pos in non-loop mode


// Returns the minimum player position. The player position will not move
// before this position. It is set with OmPlrSetMinPos().
OMPLRLIB_C_API OmPlrError OmPlrGetMinPos(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    int *pMinPos);          // returned min timeline pos in non-loop mode


// Return the number of clips attached to the timeline. 
OMPLRLIB_C_API OmPlrError OmPlrGetNumClips(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    uint *pNumClips);       // returned number of attached clips


// Get the next of the list of players.
// Set playerNameSize to the size in characters (not bytes) including the
// terminating 0 of playerName buffer.
OMPLRLIB_C_API OmPlrError OmPlrGetNextPlayerA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    char *pPlayerName,      // buffer to store the returned name of a player
    uint playerNameSize);   // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrGetNextPlayerW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    wchar_t *pPlayerName,      // buffer to store the returned name of a player
    uint playerNameSize);   // size of the above buffer

#ifdef UNICODE
#define OmPlrGetNextPlayer OmPlrGetNextPlayerW
#else
#define OmPlrGetNextPlayer OmPlrGetNextPlayerA
#endif

// Get the name of the player.
// Set playerNameSize to the size of playerName buffer in characters including
// the terminating 0 (not size in bytes)
OMPLRLIB_C_API OmPlrError OmPlrGetPlayerNameA(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    char *pPlayerName,      // buffer to store the returned name of a player
    uint playerNameSize);   // size of the above buffer

OMPLRLIB_C_API OmPlrError OmPlrGetPlayerNameW(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    wchar_t *pPlayerName,      // buffer to store the returned name of a player
    uint playerNameSize);   // size of the above buffer

#ifdef UNICODE
#define OmPlrGetPlayerName OmPlrGetPlayerNameW
#else
#define OmPlrGetPlayerName OmPlrGetPlayerNameA
#endif

// Get player status information.
OMPLRLIB_C_API OmPlrError OmPlrGetPlayerStatusW(
    OmPlrHandle plrHandle,   // handle returned from OmPlrOpen()
    OmPlrStatusW *pPlrStatus);// pointer to user supplied OmPlrStatus struct

OMPLRLIB_C_API OmPlrError OmPlrGetPlayerStatusA(
    OmPlrHandle plrHandle,   // handle returned from OmPlrOpen()
    OmPlrStatusA *pPlrStatus);// pointer to user supplied OmPlrStatus struct

#ifdef UNICODE
#define OmPlrGetPlayerStatus OmPlrGetPlayerStatusW
#else
#define OmPlrGetPlayerStatus OmPlrGetPlayerStatusA
#endif

// Newer version of OmPlrGetPlayerStatus. This version fixes the 32 character
// limit in the old version and adds a few more data fields. See omplrdefs.h
// for differences between OmPlrStatus and OmPlrStatus1.
OMPLRLIB_C_API OmPlrError OmPlrGetPlayerStatus1W(
    OmPlrHandle plrHandle,   // handle returned from OmPlrOpen()
    OmPlrStatus1W *pPlrStatus);// pointer to user supplied OmPlrStatus struct

OMPLRLIB_C_API OmPlrError OmPlrGetPlayerStatus1A(
    OmPlrHandle plrHandle,   // handle returned from OmPlrOpen()
    OmPlrStatus1A *pPlrStatus);// pointer to user supplied OmPlrStatus struct

#ifdef UNICODE
#define OmPlrGetPlayerStatus1 OmPlrGetPlayerStatus1W
#else
#define OmPlrGetPlayerStatus1 OmPlrGetPlayerStatus1A
#endif

// Another newer version of OmPlrGetPlayerStatus. This version adds a
// portDown data field. See omplrdefs.h for differences between OmPlrStatus1
// and OmPlrStatus2.
OMPLRLIB_C_API OmPlrError OmPlrGetPlayerStatus2W(
    OmPlrHandle plrHandle,   // handle returned from OmPlrOpen()
    OmPlrStatus2W *pPlrStatus);// pointer to user supplied OmPlrStatus struct

OMPLRLIB_C_API OmPlrError OmPlrGetPlayerStatus2A(
    OmPlrHandle plrHandle,   // handle returned from OmPlrOpen()
    OmPlrStatus2A *pPlrStatus);// pointer to user supplied OmPlrStatus struct

#ifdef UNICODE
#define OmPlrGetPlayerStatus2 OmPlrGetPlayerStatus2W
#else
#define OmPlrGetPlayerStatus2 OmPlrGetPlayerStatus2A
#endif

// Another newer version of OmPlrGetPlayerStatus. This version adds
// recBlackCount and refLockedCount fields. See omplrdefs.h for differences
// between OmPlrStatus2 and OmPlrStatus3.
OMPLRLIB_C_API OmPlrError OmPlrGetPlayerStatus3W(
    OmPlrHandle plrHandle,   // handle returned from OmPlrOpen()
    OmPlrStatus3W *pPlrStatus);// pointer to user supplied OmPlrStatus struct

OMPLRLIB_C_API OmPlrError OmPlrGetPlayerStatus3A(
    OmPlrHandle plrHandle,   // handle returned from OmPlrOpen()
    OmPlrStatus3A *pPlrStatus);// pointer to user supplied OmPlrStatus struct

#ifdef UNICODE
#define OmPlrGetPlayerStatus3 OmPlrGetPlayerStatus3W
#else
#define OmPlrGetPlayerStatus3 OmPlrGetPlayerStatus3A
#endif

// Returns the player position (timeline position).
OMPLRLIB_C_API OmPlrError OmPlrGetPos(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    int *pPos);             // returned player timeline position

OMPLRLIB_C_API OmPlrError OmPlrGetPosD(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    double *pPos);          // returned player timeline position


// Returns position and handle of the clip at the current player position.
OMPLRLIB_C_API OmPlrError OmPlrGetPosAndClip(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    int *pPos,              // returned timeline position of start of clip
    OmPlrClipHandle *pClipHandle);// returned clip handle at current player pos


// Returns the offset into the current clip.
OMPLRLIB_C_API OmPlrError OmPlrGetPosInClip(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    uint *pPosInClip);      // returned player position relative to the start
                            // of the current clip


// Returns position of clip.
OMPLRLIB_C_API OmPlrError OmPlrGetPosOfClip(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    OmPlrClipHandle clipHandle,// clip handle 
    int *pPos);              // returned timeline pos of the start of the clip


// Returns the player timeline motion rate. 1.0 is normal rate. 0 is still.
OMPLRLIB_C_API OmPlrError OmPlrGetRate(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    double *pRate);         // returned player rate


// Returns the available recording time in seconds of this player as 
// currently configured.
OMPLRLIB_C_API OmPlrError OmPlrGetRecordTime(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    uint *pRecordTime);     // returned recording time


// Returns the player state.
OMPLRLIB_C_API OmPlrError OmPlrGetState(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    OmPlrState *pState);    // returned state of the player


// Returns the values set by OmPlrSetTcgInsertion()
OMPLRLIB_C_API OmPlrError OmPlrGetTcgInsertion(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    bool *pPlayInsert,      // returned true if insert on play is enabled
    bool *pRecordInsert);   // returned true if insert on record is enabled


// Returns the value set by OmPlrSetTcgMode()
OMPLRLIB_C_API OmPlrError OmPlrGetTcgMode(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    OmPlrTcgMode *pMode);   // returned mode of the timecode generator


// Returns the player position, system frame number, system fractional frame
// number, reference VITC data, timecode generator timecode, and video
// stream timecode.
// The system frame number is a 32-bit number that counts in frames
// starting a zero at power on. The fractional part is a 32-bit number
// representing the fractional part of the system frame count. A value of
// 0xC0000000 is 3/4 a frame. 
// A timecode value is set to all ones if the timecode data is missing or
// invalid.
OMPLRLIB_C_API OmPlrError OmPlrGetTime(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    int *pPos,              // returned player position
    uint *pSysFrame = 0,    // returned system frame count
    uint *pSysFrameFrac = 0,// returned system fractional frame
    OmTcData *pRefVitc = 0, // returned reference VITC data
    OmTcData *pTcg = 0,     // returned timecode generator timecode
    OmTcData *pVideoTc = 0);// returned video stream timecode

OMPLRLIB_C_API OmPlrError OmPlrGetTime1(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    int *pPos,              // returned player position
    uint *pSysFrame = 0,    // returned system frame count
    uint *pSysFrameFrac = 0,// returned system fractional frame
    OmTcData *pRefVitc = 0, // returned reference VITC data
    OmTcData *pTcg = 0,     // returned timecode generator timecode
    OmTcData *pVideoTc = 0, // returned video stream timecode
    uint *seconds = 0,      // Director time in seconds
    uint *milliseconds = 0);// Director time milliseconds portion


// Seek the player position to the given timecode
OMPLRLIB_C_API OmPlrError OmPlrGoToTimecode(OmPlrHandle plrHandle, OmTcData OmTcData,
                             uint timeoutMsecs);

// Controls loop mode. Use minLoopPos = maxLoopPos to disable loop mode.
OMPLRLIB_C_API OmPlrError OmPlrLoop(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    int minLoopPos,         // minimum loop timeline position (inclusive)
    int maxLoopPos);        // maximum loop timeline position (exclusive)


// Open a connection to a player on a Director.
// The player dll is thread safe. However, usage of a player handle is not
// thread safe. Multiple threads must either have their own player handle or
// serialze the usage of the player handle.
OMPLRLIB_C_API OmPlrError OmPlrOpenA(
    const char *pDirName,     // name of the Director (or dotted ip address)
    const char *pPlrName,     // name of the player on the director
    OmPlrHandle *pPlrHandle); // returned player handle

OMPLRLIB_C_API OmPlrError OmPlrOpenW(
    const wchar_t *pDirName,  // name of the Director (or dotted ip address)
    const wchar_t *pPlrName,  // name of the player on the director
    OmPlrHandle *pPlrHandle); // returned player handle

#ifdef UNICODE
#define OmPlrOpen OmPlrOpenW
#else
#define OmPlrOpen OmPlrOpenA
#endif

// Open a connection to a player on a Director.
// The connectCallback routine is called when a network connection to the
// Director is established or reestablished.
OMPLRLIB_C_API OmPlrError OmPlrOpen1A(
    const char *pDirName,    // name of the Director (or dotted ip address)
    const char *pPlrName,    // name of the player on the director
    OmPlrHandle *pPlrHandle, // returned player handle
    void(*pConnectCallback)(OmPlrHandle plrHand)); // connect callback

OMPLRLIB_C_API OmPlrError OmPlrOpen1W(
    const wchar_t *pDirName,   // name of the Director (or dotted ip address)
    const wchar_t *pPlrName,   // name of the player on the director
    OmPlrHandle *pPlrHandle,   // returned player handle
    void(*pConnectCallback)(OmPlrHandle plrHand)); // connect callback

#ifdef UNICODE
#define OmPlrOpen1 OmPlrOpen1W
#else
#define OmPlrOpen1 OmPlrOpen1A
#endif

// Sets the player in motion playing at the given rate. The rate is in
// frames per frame. For example, 1.0 is normal, 0.5 is 1/2, and -2.0
// is reverse 2x.
// Play starts as soon as possible and the first frame shows up on the
// output some "play latency" frames later. The play latency depends
// on the type of mediaPort. Play latency is currently about 3 to 12
// frames. Play latency is deterministic and repeatable given a set of
// hardware and software versions.
OMPLRLIB_C_API OmPlrError OmPlrPlay(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    double playRate);       // play rate


// Sets the player in motion playing at the given rate, at sysFrame time.
// The current system frame time (sysFrame) is obtained with OmPlrGetTime().
// Frame accurate dubbing between two mediaPorts is possible by using
// OmPlrPlayAt X to the source player and OmPlrRecordAt X to the record player.
// X must be a sytem frame time in the future.
OMPLRLIB_C_API OmPlrError OmPlrPlayAt(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    uint sysFrame,          // system frame time to start play
    double playRate = 1.0); // play rate


// Exactly like OmPlrPlayAt() but does not clear the queue of pending "At"
// operations.  Using this API several PlayAt operations can be stacked
// up without waiting for each one to take effect before sending the next.
OMPLRLIB_C_API OmPlrError OmPlrPlayAtQueue(
    OmPlrHandle plrHandle,
    uint sysFrame,
    double playRate = 1.0);


// Sets the player in motion playing at the given rate, in delay frames.
// If the delay is greater then the "play latency" of the system, then the
// play will show up on the output in delay frames.
// See the play command for "play latency."
// Frame accurate dubbing between two mediaPorts is possible by using
// OmPlrPlayDelay X to the source player and OmPlrRecordDelay X to the
// record player. Both commands must be issued in the same frame and X
// must be larger than the play latency.
OMPLRLIB_C_API OmPlrError OmPlrPlayDelay(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    uint delay,             // delay value in frames
    double playRate = 1.0); // play rate


// Returns a players ability to play.
OMPLRLIB_C_API OmPlrError OmPlrPlayEnabled(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    bool *pPlayEnabled);    // returned true if play is enabled


// Sets the player in motion recording incoming material.
// The first frame captured is the frame following the frame the command 
// arrived in.
OMPLRLIB_C_API OmPlrError OmPlrRecord(
    OmPlrHandle plrHandle); // handle returned from OmPlrOpen()


// Sets the player in motion recording incoming material at sysFrame time.
// The first frame captured is the frame at sysFrame time.
// The current system frame time (sysFrame) is obtained with OmPlrGetTime().
OMPLRLIB_C_API OmPlrError OmPlrRecordAt(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    uint sysFrame);         // system frame time to start record


// Sets the player in motion recording incoming material in delay frames.
// The first frame captured is the frame "delay" frames following the frame
// the command arrived in. A delay of 0 is the same as a OmPlrRecord().
OMPLRLIB_C_API OmPlrError OmPlrRecordDelay(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    uint delay);            // delay value in frames


// Returns a players ability to record.
OMPLRLIB_C_API OmPlrError OmPlrRecordEnabled(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    bool *pPlayEnabled);    // returned true if record is enabled


// Modifies how a clip is attached to the timeline.
OMPLRLIB_C_API OmPlrError OmPlrSetClipData(
    OmPlrHandle plrHandle,     // handle returned from OmPlrOpen()
    OmPlrClipHandle clipHandle,// handle of clip to modify
    uint clipIn,               // new clip in point
    uint clipOut,              // new clip out point
    uint clipLen,              // new clip len (set to out - in)
    OmPlrShiftMode shiftMode); // shift existing clips in this manner


// Sets the maximum player position. The player position will not
// move to a point at or after this timeline position.
OMPLRLIB_C_API OmPlrError OmPlrSetMaxPos(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    int maxPos);            // maximum player position (exclusive)


// Sets the maximum player position to the last frame of the last clip on
// the timeline. This setting will limit the player from moving past the
// last frame of the last clip on the timeline.
OMPLRLIB_C_API OmPlrError OmPlrSetMaxPosMax(
    OmPlrHandle plrHandle);   // handle returned from OmPlrOpen()


// Sets the min and max player positions to the specified clip. The min
// and max positions will be set to limit the player from moving outside
// the specified clip on the timeline.
OMPLRLIB_C_API OmPlrError OmPlrSetMinMaxPosToClip(
    OmPlrHandle plrHandle,      // handle returned from OmPlrOpen()
    OmPlrClipHandle clipHandle);// clip handle


// Sets the minimum player position. The player position will not
// move to a point before this timeline position.
OMPLRLIB_C_API OmPlrError OmPlrSetMinPos(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    int minPos);            // minimum player position (inclusive)


// Sets the minimum player position to the first frame of the first clip.
// This setting will limit the player from moving before the first frame
// of the first clip on the timeline.
OMPLRLIB_C_API OmPlrError OmPlrSetMinPosMin(
    OmPlrHandle plrHandle); // handle returned from OmPlrOpen()


// Enable automatic player switching.
// The connection may switch to another player when responding to OmPlrCuePlay,
// OmPlrCueRecord or OmPlrAttach.
// A player connection that has been auto switched to another player directs
// all player commands to the redirected player.
// By default this is on.
OMPLRLIB_C_API OmPlrError OmPlrSetPlayerSwitching(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    bool enable);            // set true to enable switching


// Sets the player position. This will jump the player position to the
// specified position. The player may temporarily freeze frame if this
// command is executed while the player is in motion. To guarantee against
// freeze frames, issue this command, issue a OmPlrCuePlay() command,
// followed by a OmPlrPlay(). The call to OmPlrCuePlay() will block
// untill the player has prefetched enough data to play.
OMPLRLIB_C_API OmPlrError OmPlrSetPos(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    int pos);               // new player position

OMPLRLIB_C_API OmPlrError OmPlrSetPosD(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    double pos);            // new player position


// Enable automatic reconnect when connection to the Director is lost.
// By default this is on.
OMPLRLIB_C_API OmPlrError OmPlrSetRetryOpen(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    bool retry);            // set true to enable retry


// Step the player position. Positive step moves the position forward
// "step" frames. Negative step moves the position backwards "step" frames.
// This function operates only in play.
OMPLRLIB_C_API OmPlrError OmPlrStep(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    int step);

OMPLRLIB_C_API OmPlrError OmPlrStepD(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    double step);


// Stop the player. If recording, the last frame captured is the current frame.
OMPLRLIB_C_API OmPlrError OmPlrStop(
    OmPlrHandle plrHandle); // handle returned from OmPlrOpen()


// Set the timecode generator value.
OMPLRLIB_C_API OmPlrError OmPlrSetTcgData(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    OmTcData tcData,        // new timecode generator value
    bool onlyUserbits);     // set true to only update the userbits


// Enable timecode generator insertion into video play or record stream.
OMPLRLIB_C_API OmPlrError OmPlrSetTcgInsertion(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    bool playInsert,        // set true to enable timecode insert during play
    bool recordInsert);     // set true to enable timecode insert during record


// Set the timecode generator mode. Each player has a single timecode
// generator that runs at the player frame rate.
OMPLRLIB_C_API OmPlrError OmPlrSetTcgMode(
    OmPlrHandle plrHandle,  // handle returned from OmPlrOpen()
    OmPlrTcgMode mode);     // new timecode generator mode

/*! \endcond OmneonIgnore */

#endif
