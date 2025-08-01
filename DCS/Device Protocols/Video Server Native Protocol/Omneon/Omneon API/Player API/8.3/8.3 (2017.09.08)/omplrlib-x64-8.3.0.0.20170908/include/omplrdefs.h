/**********************************************************************
 Filename:    omplrdefs.h

 Description: Various player interface defines

 Copyright (c) 1998-2014, Harmonic Inc. All rights reserved.
************************************************************************/

/*! \file omplrdefs.h
 *  \brief Header for structs, typedefs and enums specific to the player interface. */

/*! \cond OmneonIgnore */

#ifndef _omplrdefs_h_
#define _omplrdefs_h_

#include <omdefs.h>
#include <ommediadefs.h>
#include <omtcdata.h>
#include <omclipfiledefs.h>


// Note: this struct does not exist
// The typedef is done this way to strengthen type checking
typedef struct _OmPlrHandle* OmPlrHandle;
typedef uint OmPlrClipHandle;
typedef uint OmPlrClipCopyHandle;



// maximum lengths for strings includes the trailing null

enum {omPlrMaxClipDirLen = 512};     // max clip director name length
enum {omPlrMaxClipExtListLen = 128}; // max clip extension list length
enum {omPlrMaxClipNameLen = 64};     // max clip name length
enum {omPlrMaxDirectorNameLen = 64}; // max length of director name
enum {omPlrMaxPlayerNameLen = 32};   // max length player name
enum {omPlrMaxPlayerUserDataLen = 16*1024}; // max length of player user data
enum {omPlrMaxTrackMatchLen = 1024};  // max track match string length
enum {omPlrMaxUserDataKeyLen = 64};  // max user data key size
enum {omPlrMaxUserDataDataLen = 16*1024}; // max user data data size
enum {omPlrMaxVancFilterEntries = 32}; // max number of VANC filter entries

// clip extension list rules:
// 1. This list is an ASCII string of ordered filename extensions including
//    the '.'. For example:
//    use ".mov" for Quicktime clips
//    use ".mxf" for MXF clips
//    use ".mov.mxf" for Quicktime or MXF with preference to Quicktime


// Low resolution proxy clips may be created at the same time a clip is
// recorded. In this case the clip will contain user data containing the
// name of the proxy clip. The user data key is "ovn_proxy_path" and the
// user data value is the path of the proxy relative to the path of the clip.
#define PROXY_NAME_USER_DATA_KEY "ovn_proxy_path"


// use this special name for a black/empty clip
#ifdef UNICODE
#define PLAYER_BLACK_CLIP_NAME L"OmneonEmptyBlackClip"
#else
#define PLAYER_BLACK_CLIP_NAME "OmneonEmptyBlackClip"
#endif


// use this special name prefix to retrieve known keys from clips
// For instance to retrieve the known key "clipProps" use a key name of
// "ovn_clip_property_clipProps"
#define OMN_KNOWN_KEY_PREFIX "ovn_clip_property_"
#define OMN_KNOWN_KEY_PREFIX_LEN 18



// use these magic values to specify "special" clip handles
#define omPlrNullClip ((OmPlrClipHandle)0)  //
#define omPlrFirstClip ((OmPlrClipHandle)1) // first clip on timeline
#define omPlrLastClip ((OmPlrClipHandle)2)  // last clip on timeline
#define omPlrActiveClip ((OmPlrClipHandle)3)// clip currently playing


// Player types (e.g. SDI, compressed stream, etc.)
enum OmPlrType {
    omPlrTypeUnknown = 0,      // unknown/error
    omPlrTypeSdi,              // physical SDI interface (default)
    omPlrTypeCompressedStream, // compressed network stream

    omPlrNumTypes
};


// Encode sources
enum OmPlrEncodeSource {
    omPlrEncSrcUnknown = 0,
    omPlrEncSrcDefault,
    omPlrEncSrcCompressedStream,
    omPlrEncSrcSdi,
    omPlrEncSrc2022_6,

    omPlrNumEncSrc
};


// use these magic values to specify "special" in/out points
enum {
    omPlrClipDefaultIn = ~0U,
    omPlrClipDefaultOut = ~0U,
    omPlrClipDefaultLen = ((unsigned int)~0 >> 1) + 1,
};


// Clip file types
enum OmPlrClipFileType {
    omPlrClipFileUnknown,
    omPlrClipFileRef,         // referenced quicktime, *.mov
    omPlrClipFileSelf,        // self contained quicktime, *.mov
};


// Record style types
enum OmPlrRecordStyle {
    omPlrRecordStyleGeneric,        // generic style
    omPlrRecordStyleAs02_2009,      // Legacy MXF AS-02 format (AS-02 2009)
    omPlrRecordStyleAs02 = omPlrRecordStyleAs02_2009, // MXF AS-02 format (defaults to AS-02 2009)
    omPlrRecordStyleLowLatency,     // low latency for xfer while record
    omPlrRecordStyleEvtr,           // Sony eVTR (MXF OP1A)
    omPlrRecordStyleEvtrLowLatency, // low latency version of above
    omPlrRecordStyleRdd9,           // Sony Rdd-9 low latency w/377-1 complaint package durations
    omPlrRecordStyleRdd9Legacy,     // Sony Rdd-9 low latency w/sony style package durations
    omPlrRecordStyleAs02_2011,      // MXF AS-02 format (AS-02 2011)
    omPlrRecordStyleArdZdfHdf01,    // IRT ARD_ZDF_HDF01(a/b)
    omPlrRecordStyleArdZdfHdf02_03, // IRT ARD_ZDF_HDF(02/03)(a/b)
}; // add new values at the end!


// Timecode generator modes
enum OmPlrTcgMode {
    omPlrTcgModeHold,           // holds at constant value
    omPlrTcgModeFreeRun,        // always counts up
    omPlrTcgModeLockedTimeline, // value based on timeline position
    omPlrTcgModeLockedClip,     // value based on timeline position within clip
    omPlrTcgModeLockedClipTc,   // value starts at clip start TC, then counts
    omPlrTcgModeLockedRefVitc,  // value based on reference VITC input
};


// Use these magic values for VITC line 1, 2 to select other
// sources of timecode.
// Ex: OmPlrSetIfDevTc(..., omPlrTcLine1Special, omPlrTcLine2Ltc, ...)
enum OmPlrIfDevTcLine1Special {
    omPlrTcLine1Special = 0,
};
enum OmPlrIfDevTcLine2Special {
    omPlrTcLine2Ltc = 0,
    omPlrTcLine2RefVitc = 1,
};


// Mpeg subtypes
enum OmPlrMpegSubtype {
    omPlrMpegSubtypeStd,
    omPlrMpegSubtypeImx,
    omPlrMpegSubtypeXdcamHd,
    omPlrMpegSubtypePanasonicAvci,
    omPlrMpegSubtypeRP2027,
    omPlrMpegSubtypeXAVC,
    omPlrMpegSubtypeAvcUltra,
};


// EE modes
enum OmPlrEeMode {
    omPlrEeModeNormal,
    omPlrEeModeNever,
    omPlrEeModeRecord,
};


// Record options
enum OmPlrRecordOptions {
    omPlrRecordNoOptions = 0,
    omPlrRecordStopAtMaxPos = 1,
};

// AVC various classes
// This is similar to previous coding of OmPlrCalcVideoIsoBpc(..., avciRate, ...),
// except that it did not distinguish among 720p, 1080i and 1080p for the
// same class. This argument to OmPlrCalcVideoIsoBpc2() plus the frame
// rate does that correctly.

enum OmPlrAvcClass {
    OmPlrAvcClassUnknown        = 0,
    OmPlrAvcClass50_720Line     = 51,
    OmPlrAvcClass50_1080Line    = 50,
    OmPlrAvcClass100_720Line    = 101,
    OmPlrAvcClass100_1080Line   = 100,
    OmPlrAvcClass200_720Line    = 201,
    OmPlrAvcClass200_1080Line   = 200,
    OmPlrAvcClass300_2160Line   = 211,  // Sony XAVC
    OmPlrAvcClass400_2160Line   = 213,  // Panasonic AVCU
};

#ifdef __cplusplus
inline OmPlrAvcClass encodeAvcClass(uint avcClass, uint nLines)
{
    switch (avcClass) {
    case 50:
        switch(nLines) {
        case 720:   return OmPlrAvcClass50_720Line;
        case 1080:  return OmPlrAvcClass50_1080Line;
        default:    return OmPlrAvcClassUnknown;
        }
    case 100:
        switch(nLines) {
        case 720:   return OmPlrAvcClass100_720Line;
        case 1080:  return OmPlrAvcClass100_1080Line;
        default:    return OmPlrAvcClassUnknown;
        }
    case 200:
        switch(nLines) {
        case 720:   return OmPlrAvcClass200_720Line;
        case 1080:  return OmPlrAvcClass200_1080Line;
        default:    return OmPlrAvcClassUnknown;
        }
    case 300:
        switch(nLines) {
        case 2160:  return OmPlrAvcClass300_2160Line;
        default:    return OmPlrAvcClassUnknown;
        }
    case 400:
        switch(nLines) {
        case 2160:  return OmPlrAvcClass400_2160Line;
        default:    return OmPlrAvcClassUnknown;
        }

    default:
        return OmPlrAvcClassUnknown;
    }
}

inline uint getAvcClassNumber(OmPlrAvcClass avcClass)
{
    switch(avcClass) {
    case OmPlrAvcClass50_720Line:
    case OmPlrAvcClass50_1080Line:  return  50;

    case OmPlrAvcClass100_720Line:
    case OmPlrAvcClass100_1080Line: return 100;

    case OmPlrAvcClass200_720Line:
    case OmPlrAvcClass200_1080Line: return 200;

    case OmPlrAvcClass300_2160Line: return 300;
    case OmPlrAvcClass400_2160Line: return 400;

    default:                        return 0;
    }
}

inline uint getAvcClassHeight(OmPlrAvcClass avcClass)
{
    switch(avcClass) {
    case OmPlrAvcClass50_720Line:
    case OmPlrAvcClass100_720Line:
    case OmPlrAvcClass200_720Line:  return 720;

    case OmPlrAvcClass100_1080Line:
    case OmPlrAvcClass50_1080Line:
    case OmPlrAvcClass200_1080Line: return 1080;

    case OmPlrAvcClass300_2160Line:
    case OmPlrAvcClass400_2160Line: return 2160;
    
    default:                        return 0;
    }
}
#endif

// Audio I/O formats
enum OmPlrAudioIo {
    omPlrAudioIoUnknown,
    omPlrAudioIoAes,         // use AES
    omPlrAudioIoEmbedded,    // use 601 embedded
    omPlrAudioIoEmbLimited,  // use 601 embedded, only 1 group, 20 bits
};


// Player application modes
enum OmPlrApp {
    omPlrAppNone,
    omPlrAppLouth,      // VDCP
    omPlrAppOmnibus,
    omPlrAppBvw,        // Sony serial
    omPlrAppOmneonPe,   // Omneon Playout Engine
    omPlrAppOmneonPeDC, // Omneon Playout Engine Delay Channel
};


// Player application options
enum OmPlrAppOptions {
    omPlrAppOptNone         = 0x00,  // no options
    omPlrAppOptMediaFetch   = 0x01,  // media fetch licensed
    omPlrAppOptScheduleTool = 0x02,  // ScheduleTool licensed
};


// Video frame conversion mode
enum OmPlrVideoFrameConvert {
    omPlrVfcUnknown,    // unspecified conversion
    omPlrVfcNone,       // no conversion
    omPlrVfcExternal0,  // external converter, 0 frame delay
    omPlrVfcExternal1,  // external converter, 1 frame delay
    omPlrVfcExternal2,  // external converter, 2 frame delay
    omPlrVfcExternal3,  // external converter, 3 frame delay
    omPlrVfcExternal4,  // external converter, 4 frame delay
    omPlrVfcPillar,     // 4x3 => 16x9 (black on sides)
    omPlrVfcCrop,       // 4x3 => 16x9 (chop top and bottom, some black sides)
                        // 16x9 => 4x3 (chop sides, some black top/bottom)
    omPlrVfcLetter,     // 16x9 => 4x3 (black top/bottom)
    omPlrVfcFull,       // 16x9 => 4x3 (chop sides, no black top/bottom)
                        // 4x3 => 16x9 (chop top/bottom, no black sides)
    omPlrVfcAnamorphic, // 4x3 => 16x9 (stretch)
                        // 16x9 => 4x3 (squeeze)
    omPlrVfcNonLinear   // 4x3 => 16x9 (non-linear stretch, aka 'Turner Stretch')
};


// Player states, a player is always in one of these states.
enum OmPlrState{
    omPlrStateStopped,
    omPlrStateCuePlay,
    omPlrStatePlay,
    omPlrStateCueRecord,
    omPlrStateRecord
};


// Clip shift modes, how the timeline clips are shifted when the timeline
// is modified
enum OmPlrShiftMode {
    omPlrShiftModeAfter, // shift clips after the modified clip
    omPlrShiftModeBefore,// shift clips before the modified clip
    omPlrShiftModeAuto,  //shift as necessary to avoid changing the current pos
    omPlrShiftModeOthers,// shift all other clips, not this one
};


// This is the per frame header used for the 436Vbi, 436Vanc and EmbVanc
// data types
struct OmVancFrameHeader {
    unsigned char headerSize:4;         // frame header size (this header)
    unsigned char dataType:4;           // always 1 or 2
    union {
        struct {                        // dataType 1
            unsigned char frameSize[3]; // payload + frame header size
        } type1;
        struct {                        // data type 2
            unsigned char pktHdrSize:4; // size of packet header
            unsigned char reserved:4;
            unsigned char frameSize[2]; // payload + frame header size
            unsigned char maxFrameSize[2];
        } type2;
    };

    uint GetDataType() { return dataType; }
    uint GetHeaderSize() { return headerSize; }
    uint GetLength() {
        if (dataType == 1)
            return (type1.frameSize[0] * 4096) + (type1.frameSize[1] * 256) +
                    type1.frameSize[2];
        else
            return (type2.frameSize[0] * 256) + type2.frameSize[1];
    }
    uint GetMaxLength() {
        if (dataType == 1)
            return 0;                   // not supported in this version
        else
            return (type2.maxFrameSize[0] * 256) + type2.maxFrameSize[1];
    }
};

// This is the per line or per packet header used for the 436Vbi, 436Vanc
// and EmbVanc data types
// Note: coding type should always be 1, indicates VBI is 8-bit luma only, VANC
// is 8-bit data
struct OmVancPacketHeader {
    unsigned char lineNumUpper;
    unsigned char codingType:4;
    unsigned char lineNumLower:4;
    unsigned char length[2];        // length of packet including this header

    uint GetCodingType() { return codingType; }
    uint GetHeaderSize() { return 4; }
    uint GetLength() { return (length[0] * 256) + length[1]; }
    uint GetLineNum() { return (lineNumUpper << 4) + lineNumLower; }
};



// player status
struct OmPlrStatusA {
    // temporary, older code had version instead of size
    union {
        uint    size;         // internal use only
        uint    version;
    };
    OmPlrState  state;        // player state
    int     pos;              // player position
    int     resv1;
    double  rate;             // player rate
    int     minPos;           // player minimum position
    int     maxPos;           // player maximum position
    uint    numClips;         // number of clips on the timeline
    uint    clipListVersion;  // version number of the timeline,
                              // increments on every timeline change
    uint    currClipNum;      // current clip number (first clip on
                              // the timeline is 0)
    int     currClipStartPos; // timeline pos of start of current clip
    uint    currClipIn;       // in point of current clip
    uint    currClipOut;      // out point of current clip
    uint    currClipLen;      // length (out - in) of current clip
    uint    currClipFirstFrame;// first recorded frame of current clip
    uint    currClipLastFrame;// last recorded frame of current clip
    char    currClipName[omPlrMaxClipNameLen]; // name of current clip
    int     firstClipStartPos;// timeline pos of start of first clip
    int     lastClipEndPos;   // timeline pos of end of last clip
    int     loopMin;          // minimum loop position
    int     loopMax;          // maximum loop position
    bool    playEnabled;      // true if player is enabled for play
    bool    recordEnabled;    // true if player is enabled for record
    bool    resv2[2];
    OmFrameRate frameRate;    // player frame rate
};

struct OmPlrStatusW {
    // temporary, older code had version instead of size
    union {
        uint    size;         // internal use only
        uint    version;
    };
    OmPlrState  state;        // player state
    int     pos;              // player position
    int     resv1;
    double  rate;             // player rate
    int     minPos;           // player minimum position
    int     maxPos;           // player maximum position
    uint    numClips;         // number of clips on the timeline
    uint    clipListVersion;  // version number of the timeline,
                              // increments on every timeline change
    uint    currClipNum;      // current clip number (first clip on
                              // the timeline is 0)
    int     currClipStartPos; // timeline pos of start of current clip
    uint    currClipIn;       // in point of current clip
    uint    currClipOut;      // out point of current clip
    uint    currClipLen;      // length (out - in) of current clip
    uint    currClipFirstFrame;// first recorded frame of current clip
    uint    currClipLastFrame;// last recorded frame of current clip
    unsigned short currClipName[omPlrMaxClipNameLen/2]; // name of current clip
    int     firstClipStartPos;// timeline pos of start of first clip
    int     lastClipEndPos;   // timeline pos of end of last clip
    int     loopMin;          // minimum loop position
    int     loopMax;          // maximum loop position
    bool    playEnabled;      // true if player is enabled for play
    bool    recordEnabled;    // true if player is enabled for record
    bool    resv2[2];
    OmFrameRate frameRate;    // player frame rate
};

#ifdef UNICODE
#define OmPlrStatus OmPlrStatusW
#else
#define OmPlrStatus OmPlrStatusA
#endif

// player status version 2
struct OmPlrStatus1A {
    uint    version;          // internal use only
    OmPlrState  state;        // player state
    double  rate;             // player rate
    int     pos;              // player position
    int     minPos;           // player minimum position
    int     maxPos;           // player maximum position
    uint    numClips;         // number of clips on the timeline
    uint    clipListVersion;  // version number of the timeline,
                              // increments on every timeline change
    OmPlrClipHandle currClipHandle; // handle to current clip
    uint    currClipNum;      // current clip number (first clip on
                              // the timeline is 0)
    int     currClipStartPos; // timeline pos of start of current clip
    uint    currClipIn;       // in point of current clip
    uint    currClipOut;      // out point of current clip
    uint    currClipLen;      // length (out - in) of current clip
    uint    currClipFirstFrame;// first recorded frame of current clip
    uint    currClipLastFrame;// last recorded frame of current clip
    OmFrameRate currClipFrameRate; // frame rate of current clip
    OmTcData currClipStartTimecode; // start timecode of current clip
    char    currClipName[omPlrMaxClipNameLen]; // name of current clip
    int     firstClipStartPos;// timeline pos of start of first clip
    int     lastClipEndPos;   // timeline pos of end of last clip
    int     loopMin;          // minimum loop position
    int     loopMax;          // maximum loop position
    bool    playEnabled;      // true if player is enabled for play
    bool    recordEnabled;    // true if player is enabled for record
    bool    dropFrame;        // true if player set to drop frame mode
    bool    tcgPlayInsert;    // true if tcg inserting on play
    bool    tcgRecordInsert;  // true if tcg inserting on record
    OmPlrTcgMode tcgMode;     // tcg mode
    OmFrameRate frameRate;    // player frame rate
};
struct OmPlrStatus1W {
    uint    version;          // internal use only
    OmPlrState  state;        // player state
    double  rate;             // player rate
    int     pos;              // player position
    int     minPos;           // player minimum position
    int     maxPos;           // player maximum position
    uint    numClips;         // number of clips on the timeline
    uint    clipListVersion;  // version number of the timeline,
                              // increments on every timeline change
    OmPlrClipHandle currClipHandle; // handle to current clip
    uint    currClipNum;      // current clip number (first clip on
                              // the timeline is 0)
    int     currClipStartPos; // timeline pos of start of current clip
    uint    currClipIn;       // in point of current clip
    uint    currClipOut;      // out point of current clip
    uint    currClipLen;      // length (out - in) of current clip
    uint    currClipFirstFrame;// first recorded frame of current clip
    uint    currClipLastFrame;// last recorded frame of current clip
    OmFrameRate currClipFrameRate; // frame rate of current clip
    OmTcData currClipStartTimecode; // start timecode of current clip
    unsigned short currClipName[omPlrMaxClipNameLen]; // name of current clip
    int     firstClipStartPos;// timeline pos of start of first clip
    int     lastClipEndPos;   // timeline pos of end of last clip
    int     loopMin;          // minimum loop position
    int     loopMax;          // maximum loop position
    bool    playEnabled;      // true if player is enabled for play
    bool    recordEnabled;    // true if player is enabled for record
    bool    dropFrame;        // true if player set to drop frame mode
    bool    tcgPlayInsert;    // true if tcg inserting on play
    bool    tcgRecordInsert;  // true if tcg inserting on record
    OmPlrTcgMode tcgMode;     // tcg mode
    OmFrameRate frameRate;    // player frame rate
};

#ifdef UNICODE
#define OmPlrStatus1 OmPlrStatus1W
#else
#define OmPlrStatus1 OmPlrStatus1A
#endif


// player status version 3
struct OmPlrStatus2A {
    uint    version;          //
    OmPlrState  state;        // player state
    double  rate;             // player rate
    int     pos;              // player position
    int     minPos;           // player minimum position
    int     maxPos;           // player maximum position
    uint    numClips;         // number of clips on the timeline
    uint    clipListVersion;  // version number of the timeline,
                              // increments on every timeline change
    OmPlrClipHandle currClipHandle; // handle to current clip
    uint    currClipNum;      // current clip number (first clip on
                              // the timeline is 0)
    int     currClipStartPos; // timeline pos of start of current clip
    uint    currClipIn;       // in point of current clip
    uint    currClipOut;      // out point of current clip
    uint    currClipLen;      // length (out - in) of current clip
    uint    currClipFirstFrame;// first recorded frame of current clip
    uint    currClipLastFrame;// last recorded frame of current clip
    OmFrameRate currClipFrameRate; // frame rate of current clip
    OmTcData currClipStartTimecode; // start timecode of current clip
    char    currClipName[omPlrMaxClipNameLen]; // name of current clip
    int     firstClipStartPos;// timeline pos of start of first clip
    int     lastClipEndPos;   // timeline pos of end of last clip
    int     loopMin;          // minimum loop position
    int     loopMax;          // maximum loop position
    bool    playEnabled;      // true if player is enabled for play
    bool    recordEnabled;    // true if player is enabled for record
    bool    dropFrame;        // true if player set to drop frame mode
    bool    tcgPlayInsert;    // true if tcg inserting on play
    bool    tcgRecordInsert;  // true if tcg inserting on record
    OmPlrTcgMode tcgMode;     // tcg mode
    OmFrameRate frameRate;    // player frame rate
    bool    portDown;         // true when I/O port is down
};
struct OmPlrStatus2W {
    uint    version;          //
    OmPlrState  state;        // player state
    double  rate;             // player rate
    int     pos;              // player position
    int     minPos;           // player minimum position
    int     maxPos;           // player maximum position
    uint    numClips;         // number of clips on the timeline
    uint    clipListVersion;  // version number of the timeline,
                              // increments on every timeline change
    OmPlrClipHandle currClipHandle; // handle to current clip
    uint    currClipNum;      // current clip number (first clip on
                              // the timeline is 0)
    int     currClipStartPos; // timeline pos of start of current clip
    uint    currClipIn;       // in point of current clip
    uint    currClipOut;      // out point of current clip
    uint    currClipLen;      // length (out - in) of current clip
    uint    currClipFirstFrame;// first recorded frame of current clip
    uint    currClipLastFrame;// last recorded frame of current clip
    OmFrameRate currClipFrameRate; // frame rate of current clip
    OmTcData currClipStartTimecode; // start timecode of current clip
    unsigned short currClipName[omPlrMaxClipNameLen]; // name of current clip
    int     firstClipStartPos;// timeline pos of start of first clip
    int     lastClipEndPos;   // timeline pos of end of last clip
    int     loopMin;          // minimum loop position
    int     loopMax;          // maximum loop position
    bool    playEnabled;      // true if player is enabled for play
    bool    recordEnabled;    // true if player is enabled for record
    bool    dropFrame;        // true if player set to drop frame mode
    bool    tcgPlayInsert;    // true if tcg inserting on play
    bool    tcgRecordInsert;  // true if tcg inserting on record
    OmPlrTcgMode tcgMode;     // tcg mode
    OmFrameRate frameRate;    // player frame rate
    bool    portDown;         // true when I/O port is down
};

#ifdef UNICODE
#define OmPlrStatus2 OmPlrStatus2W
#else
#define OmPlrStatus2 OmPlrStatus2A
#endif


// player status version 4
// adds refLocked and recBlackCount
struct OmPlrStatus3A {
    uint    version;          //
    OmPlrState  state;        // player state
    double  rate;             // player rate
    int     pos;              // player position
    int     minPos;           // player minimum position
    int     maxPos;           // player maximum position
    uint    numClips;         // number of clips on the timeline
    uint    clipListVersion;  // version number of the timeline,
                              // increments on every timeline change
    OmPlrClipHandle currClipHandle; // handle to current clip
    uint    currClipNum;      // current clip number (first clip on
                              // the timeline is 0)
    int     currClipStartPos; // timeline pos of start of current clip
    uint    currClipIn;       // in point of current clip
    uint    currClipOut;      // out point of current clip
    uint    currClipLen;      // length (out - in) of current clip
    uint    currClipFirstFrame;// first recorded frame of current clip
    uint    currClipLastFrame;// last recorded frame of current clip
    OmFrameRate currClipFrameRate; // frame rate of current clip
    OmTcData currClipStartTimecode; // start timecode of current clip
    char    currClipName[omPlrMaxClipNameLen]; // name of current clip
    int     firstClipStartPos;// timeline pos of start of first clip
    int     lastClipEndPos;   // timeline pos of end of last clip
    int     loopMin;          // minimum loop position
    int     loopMax;          // maximum loop position
    bool    playEnabled;      // true if player is enabled for play
    bool    recordEnabled;    // true if player is enabled for record
    bool    dropFrame;        // true if player set to drop frame mode
    bool    tcgPlayInsert;    // true if tcg inserting on play
    bool    tcgRecordInsert;  // true if tcg inserting on record
    OmPlrTcgMode tcgMode;     // tcg mode
    OmFrameRate frameRate;    // player frame rate
    bool    portDown;         // true when I/O port is down
    bool    refLocked;        // true when locked to reference input
    uint    recBlackCount;    // number of black video frames recorded, reset
                              // to zero on cueRecord.
};
struct OmPlrStatus3W {
    uint    version;          //
    OmPlrState  state;        // player state
    double  rate;             // player rate
    int     pos;              // player position
    int     minPos;           // player minimum position
    int     maxPos;           // player maximum position
    uint    numClips;         // number of clips on the timeline
    uint    clipListVersion;  // version number of the timeline,
                              // increments on every timeline change
    OmPlrClipHandle currClipHandle; // handle to current clip
    uint    currClipNum;      // current clip number (first clip on
                              // the timeline is 0)
    int     currClipStartPos; // timeline pos of start of current clip
    uint    currClipIn;       // in point of current clip
    uint    currClipOut;      // out point of current clip
    uint    currClipLen;      // length (out - in) of current clip
    uint    currClipFirstFrame;// first recorded frame of current clip
    uint    currClipLastFrame;// last recorded frame of current clip
    OmFrameRate currClipFrameRate; // frame rate of current clip
    OmTcData currClipStartTimecode; // start timecode of current clip
    unsigned short currClipName[omPlrMaxClipNameLen]; // name of current clip
    int     firstClipStartPos;// timeline pos of start of first clip
    int     lastClipEndPos;   // timeline pos of end of last clip
    int     loopMin;          // minimum loop position
    int     loopMax;          // maximum loop position
    bool    playEnabled;      // true if player is enabled for play
    bool    recordEnabled;    // true if player is enabled for record
    bool    dropFrame;        // true if player set to drop frame mode
    bool    tcgPlayInsert;    // true if tcg inserting on play
    bool    tcgRecordInsert;  // true if tcg inserting on record
    OmPlrTcgMode tcgMode;     // tcg mode
    OmFrameRate frameRate;    // player frame rate
    bool    portDown;         // true when I/O port is down
    bool    refLocked;        // true when locked to reference input
    uint    recBlackCount;    // number of black video frames recorded, reset
                              // to zero on cueRecord.
};

#ifdef UNICODE
#define OmPlrStatus3 OmPlrStatus3W
#else
#define OmPlrStatus3 OmPlrStatus3A
#endif


// player status version 5
// adds type
struct OmPlrStatus4A {
    uint    version;          //
    OmPlrState  state;        // player state
    double  rate;             // player rate
    int     pos;              // player position
    int     minPos;           // player minimum position
    int     maxPos;           // player maximum position
    uint    numClips;         // number of clips on the timeline
    uint    clipListVersion;  // version number of the timeline,
                              // increments on every timeline change
    OmPlrClipHandle currClipHandle; // handle to current clip
    uint    currClipNum;      // current clip number (first clip on
                              // the timeline is 0)
    int     currClipStartPos; // timeline pos of start of current clip
    uint    currClipIn;       // in point of current clip
    uint    currClipOut;      // out point of current clip
    uint    currClipLen;      // length (out - in) of current clip
    uint    currClipFirstFrame;// first recorded frame of current clip
    uint    currClipLastFrame;// last recorded frame of current clip
    OmFrameRate currClipFrameRate; // frame rate of current clip
    OmTcData currClipStartTimecode; // start timecode of current clip
    char    currClipName[omPlrMaxClipNameLen]; // name of current clip
    int     firstClipStartPos;// timeline pos of start of first clip
    int     lastClipEndPos;   // timeline pos of end of last clip
    int     loopMin;          // minimum loop position
    int     loopMax;          // maximum loop position
    bool    playEnabled;      // true if player is enabled for play
    bool    recordEnabled;    // true if player is enabled for record
    bool    dropFrame;        // true if player set to drop frame mode
    bool    tcgPlayInsert;    // true if tcg inserting on play
    bool    tcgRecordInsert;  // true if tcg inserting on record
    OmPlrTcgMode tcgMode;     // tcg mode
    OmFrameRate frameRate;    // player frame rate
    bool    portDown;         // true when I/O port is down
    bool    refLocked;        // true when locked to reference input
    uint    recBlackCount;    // number of black video frames recorded, reset
                              // to zero on cueRecord.
    OmPlrType type;           // what type of player this is (e.g. SDI,
                              // compressed stream, etc.)
};
struct OmPlrStatus4W {
    uint    version;          //
    OmPlrState  state;        // player state
    double  rate;             // player rate
    int     pos;              // player position
    int     minPos;           // player minimum position
    int     maxPos;           // player maximum position
    uint    numClips;         // number of clips on the timeline
    uint    clipListVersion;  // version number of the timeline,
                              // increments on every timeline change
    OmPlrClipHandle currClipHandle; // handle to current clip
    uint    currClipNum;      // current clip number (first clip on
                              // the timeline is 0)
    int     currClipStartPos; // timeline pos of start of current clip
    uint    currClipIn;       // in point of current clip
    uint    currClipOut;      // out point of current clip
    uint    currClipLen;      // length (out - in) of current clip
    uint    currClipFirstFrame;// first recorded frame of current clip
    uint    currClipLastFrame;// last recorded frame of current clip
    OmFrameRate currClipFrameRate; // frame rate of current clip
    OmTcData currClipStartTimecode; // start timecode of current clip
    unsigned short currClipName[omPlrMaxClipNameLen]; // name of current clip
    int     firstClipStartPos;// timeline pos of start of first clip
    int     lastClipEndPos;   // timeline pos of end of last clip
    int     loopMin;          // minimum loop position
    int     loopMax;          // maximum loop position
    bool    playEnabled;      // true if player is enabled for play
    bool    recordEnabled;    // true if player is enabled for record
    bool    dropFrame;        // true if player set to drop frame mode
    bool    tcgPlayInsert;    // true if tcg inserting on play
    bool    tcgRecordInsert;  // true if tcg inserting on record
    OmPlrTcgMode tcgMode;     // tcg mode
    OmFrameRate frameRate;    // player frame rate
    bool    portDown;         // true when I/O port is down
    bool    refLocked;        // true when locked to reference input
    uint    recBlackCount;    // number of black video frames recorded, reset
                              // to zero on cueRecord.
    OmPlrType type;           // what type of player this is (e.g. SDI,
                              // compressed stream, etc.)
};

#ifdef UNICODE
#define OmPlrStatus4 OmPlrStatus4W
#else
#define OmPlrStatus4 OmPlrStatus4A
#endif


// clip info structure
struct OmPlrClipInfo {
    // temporary, older code had version instead of size
    union {
        uint   size;         // size of this structure, MUST be initialized
        uint   version;
    };
    uint   firstFrame;   // first recorded frame
    uint   lastFrame;    // last recorded frame
    uint   defaultIn;    // default in point (inclusive, first frame to play)
    uint   defaultOut;   // default out point (exclusive, last frame to play)
    uint   numVideo;     // number of video tracks
    uint   numAudio;     // number of audio tracks
    OmFrameRate frameRate;// clip frame rate
    bool   protection;   // true if protected (cannot delete if protected)
    bool   notOpenForWrite;// true if not open for write
    bool   notReadyToPlay; // true if not ready to play
    bool   res1;         // reserved
    uint   creationTime; // creation time, seconds from Jan 1, 1970
    uint   maxMsTracks;  // size of following ms array, MUST be initialized
    OmMediaSummary *ms;  // pointer to array of OmMediaSummay
};


// newer version on OmPlrClipInfo
// adds fileType, modificationTime
struct OmPlrClipInfo1 {
    uint result;         // internal use only
    OmMediaFileType fileType; // movie file type, ex mxf, quicktime
    OmMediaContainment mediaContainment;
    uint   firstFrame;   // first recorded frame
    uint   lastFrame;    // last recorded frame
    uint   defaultIn;    // default in point (inclusive, first frame to play)
    uint   defaultOut;   // default out point (exclusive, last frame to play)
    uint   numVideo;     // number of video tracks
    uint   numAudio;     // number of audio channels
    OmFrameRate frameRate;// clip frame rate
    bool   protection;   // true if protected (cannot delete if protected)
    bool   notOpenForWrite;// true if not open for write
    bool   notReadyToPlay; // true if not ready to play
    bool   res1;         // reserved
    uint   creationTime; // creation time, seconds from Jan 1, 1970
    uint   modificationTime; //last modification time, seconds from Jan 1, 1970
    uint   maxMsTracks;  // size of following ms array, MUST be initialized
    OmMediaSummary1 *ms; // pointer to array of OmMediaSummay1
};

// error codes
#ifndef PLAYER_ERROR_BASE
#define PLAYER_ERROR_BASE 0x9000
#endif

enum OmPlrError {
    omPlrOk = 0,
    omPlrBadBusNum = PLAYER_ERROR_BASE, //0x9000
    omPlrBadIsoIndex,           // 0x9001
    omPlrBadIsoChannel,         // 0x9002
    omPlrBadMediaType,          // 0x9003
    omPlrBadBytesPerCycle,      // 0x9004
    omPlrBadSpeed,              // 0x9005
    omPlrBadTrackType,          // 0x9006
    omPlrBadVideoFormat,        // 0x9007
    omPlrBadReferenceNum,       // 0x9008
    omPlrNotWhileRecording,     // 0x9009
    omPlrCannotAccessClip,      // 0x900a
    omPlrCannotCreateClipFile,  // 0x900b
    omPlrCannotAttachClip,      // 0x900c
    omPlrCannotRecordHere,      // 0x900d
    omPlrWrongState,            // 0x900e
    omPlrBadRate,               // 0x900f
    omPlrTrackDriverFailure,    // 0x9010
    omPlrBadClipHandle,         // 0x9011
    omPlrCliplistNotEmpty,      // 0x9012
    omPlrRecordDisabled,        // 0x9013
    omPlrPlaybackDisabled,      // 0x9014
    omPlrNoMemory,              // 0x9015
    omPlrCannotConnect,         // 0x9016
    omPlrBadHandle,             // 0x9017
    omPlrNameExists,            // 0x9018
    omPlrNameNotExist,          // 0x9019
    omPlrNameTooLong,           // 0x901a
    omPlrBadRemoteHandle,       // 0x901b
    omPlrBadPlayerHandle,       // 0x901c
    omPlrBadPlayerEnumHandle,   // 0x901d
    omPlrBadClipEnumHandle,     // 0x901e
    omPlrEndOfList,             // 0x901f
    omPlrInvalidClip,           // 0x9020
    omPlrNetworkError,          // 0x9021
    omPlrNetworkBadVersion,     // 0x9022
    omPlrFailure,               // 0x9023
    omPlrBadIfIndex,            // 0x9024
    omPlrBadNumIfDev,           // 0x9025
    omPlrNotWhileEnabled,       // 0x9026
    omPlrBadNumAudio,           // 0x9027
    omPlrBadAudioConfig,        // 0x9028
    omPlr1394ResourceFailure,   // 0x9029
    omPlr1394IsoChanUnavailable,// 0x902a
    omPlr1394IsoBwUnavailable,  // 0x902b
    omPlrFailedToAllocateIop,   // 0x902c
    omPlrMissingRecordData,     // 0x902d
    omPlrIncorrectRecordData,   // 0x902e
    omPlrNullPointer,           // 0x902f
    omPlrTooManyAudioScrub,     // 0x9030
    omPlrSaveConfigFailed,      // 0x9031
    omPlrMissingClipDir,        // 0x9032
    omPlrFailedToCreateMediaDir,// 0x9033
    omPlrMediaDirIsAFile,       // 0x9034
    omPlrBadFrameRate,          // 0x9035
    omPlrClipProtected,         // 0x9036
    omPlrClipTooLong,           // 0x9037
    omPlrBufferTooSmall,        // 0x9038
    omPlrInvalidUserDataKey,    // 0x9039
    omPlrUserDataTooLarge,      // 0x903a
    omPlrUserDataNotExist,      // 0x903b
    omPlrClipCopyBadHandle,     // 0x903c
    omPlrClipCopyTooManyCopies, // 0x903d
    omPlrClipCopyDone,          // 0x903e
    omPlrClipCopyAborted,       // 0x903f
    omPlrRescheduleTooLate,     // 0x9040
    omPlrCmdWhileBusy,          // 0x9041
    omPlrClipCopyRangeError,    // 0x9042
    omPlrBadBitsPerSample,      // 0x9043
    omPlrBadChansPerFile,       // 0x9044
    omPlrBadAudioFileType,      // 0x9045
    omPlrNetworkTimedOut,       // 0x9046
    omPlrBadClipFileType,       // 0x9047
    omPlrTooManyFrames,         // 0x9048
    omPlrBadStartFrame,         // 0x9049
    omPlrBadDataType,           // 0x904A
    omPlrClipExtListTooLong,    // 0x904B
    omPlrBadClipExtList,        // 0x904C
    omPlrTrackMatchStringTooLong,// 0x904D
    omPlrBadTrackMatchString,   // 0x904E
    omPlrBadString,             // 0x904F
    omPlrBadRecordStyle,        // 0x9050
    omPlrBadSetPos,             // 0x9051
    omPlrNoLicense,             // 0x9052
    omPlrWrongType,             // 0x9053
    omPlrBadType,               // 0x9054
    omPlrBadLocalInterface,     // 0x9055
    omPlrBadSourceAddress,      // 0x9056
    omPlrBadMulticastAddress,   // 0x9057
    omPlrBadPortNum,            // 0x9058
    omPlrBadProgramNum,         // 0x9059
};

// New (post-5.0) version number returned as a struct
struct OmPlrSwVersion {
    uint majorNum;          // Major number
    uint minorNum;          // Minor number
    uint serviceNum;        // Service number
    uint hotfixNum;         // Hotfix number
    char alpha[8];          // Eng/pre-release build?
    char buildNum[16];      // Build number (yymmddhh)
    char branchName[64];    // Branch (if specified)
};

// Network stream settings:
struct OmPlrNetworkStream {
    char localInterface[32];    // IP address of local network interface
    char sourceAddress[255];    // IP address of network stream source
    char multicastAddress[255]; // IP address of multicast group
    uint portNum;               // network port number
    uint programNum;            // transport stream program_number (from PAT/PMT, not PID)
};


/*! \endcond OmneonIgnore */

#endif
