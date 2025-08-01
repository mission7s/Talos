/**********************************************************************
 Filename:    omplrdefs.h

 Description: Various player interface defines

 Copyright (c) 1998-2012, Harmonic Inc. All rights reserved.
************************************************************************/

/*! \file omplrdefs.h
 *  \brief Header for structs, typedefs and enums specific to the player interface. */

/*! \cond OmneonIgnore */

#ifndef _omplrdefs_h_
#define _omplrdefs_h_

#include <omdefs.h>
#include <ommediadefs.h>
#include <omtcdata.h>


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


// The aspect ratio used in video up and down coversion of a clip can be
// controlled by setting track level user data on the video track of a clip.
// The user data tag must be "ovn_arcmode"
// The user data value can be one of:
//   "anamorphic", "crop", "full", "letter", "pillar"
#define VFC_USER_DATA_KEY "ovn_arcmode"
#define VFC_USER_ANAMORPHIC "anamorphic"
#define VFC_USER_CROP "crop"
#define VFC_USER_FULL "full"
#define VFC_USER_LETTER "letter"
#define VFC_USER_PILLAR "pillar"


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
#define omPlrNullClip ((OmPlrClipHandle)0)
#define omPlrFirstClip ((OmPlrClipHandle)1)
#define omPlrLastClip ((OmPlrClipHandle)2)


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
    omPlrRecordStyleGeneric,     // generic style
    omPlrRecordStyleOpZeroTypeA, // MXF OP0 typeA
    omPlrRecordStyleAs02 = omPlrRecordStyleOpZeroTypeA, // MXF AS02
    omPlrRecordStyleLowLatency,  // low latency for xfer while record
    omPlrRecordStyleEvtr,        // Sony eVTR (MXF OP1A)
    omPlrRecordStyleEvtrLowLatency, // low latency version of above
    omPlrRecordStyleRdd9,         // Sony Rdd-9 low latency w/377-1 complaint package durations
    omPlrRecordStyleRdd9Legacy    // Sony Rdd-9 low latency w/sony style package durations
};


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


// DV types
enum OmPlrDvType {
    omPlrDvTypeUnknown,
    omPlrDvTypeDV,
    omPlrDvTypeDVCPRO25,
    omPlrDvTypeDVCPRO50,
    omPlrDvTypeDVCPRO25x2,
    omPlrDvTypeDVCPRO25x4,
    omPlrDvTypeDVCPRO50x2,
    omPlrDvTypeDVCPRO100
};

// AVC Subtypes 
enum OmPlrAvcType {
    omPlrAvcTypeUnknown = 0,
    omPlrAvcType50I,
    omPlrAvcType100I,
    omPlrAvcTypeProxy
};

// Audio I/O formats
enum OmPlrAudioIo {
    omPlrAudioIoUnknown,
    omPlrAudioIoAes,         // use AES
    omPlrAudioIoEmbedded,    // use 601 embedded
    omPlrAudioIoEmbLimited,  // use 601 embedded, only 1 group, 20 bits
};


// Audio File Formats
enum OmPlrAudioFileType {
    omPlrAudioFileUnknown,
    omPlrAudioFileAiff,
    omPlrAudioFileWav,
};


// Player application modes
enum OmPlrApp {
    omPlrAppNone,
    omPlrAppLouth,
    omPlrAppOmnibus,
    omPlrAppBvw,
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
    omPlrVfcAnamorphic  // 4x3 => 16x9 (stretch)
                        // 16x9 => 4x3 (squeeze)
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


// If you modify this enum, update the array trackTypeNames in clipfileutils.cc
// to match
enum OmPlrTrackType {
    omPlrTrackTypeInvalid,
    omPlrTrackTypeVideo,
    omPlrTrackTypeAudio,
    omPlrTrackTypeVbi,
};


enum OmPlrClipDataType {
    omPlrClipDataUnknown,

    // 2 bytes of closed caption from field 1
    // This format is only used with interlace clips.
    // See the comments below for omPlrClipDataCcFrame with the difference
    // that only field 1 data is extracted/inserted.
    omPlrClipDataCcField1,

    // 2 bytes of closed caption from field 2
    // This format is only used with interlace clips.
    // See the comments below for omPlrClipDataCcFrame with the difference
    // that only field 2 data is extracted/inserted.
    omPlrClipDataCcField2,

    // 4 bytes of closed caption, 2 from field 1 followed by 2 from field 2
    // When this is used with progressive clips either the two bytes of field 1
    // data or the two bytes of field 2 data should be 0xff,0xff or 0xfc,0xfc.
    // These special values which are normally invalid CC byte values because
    // the parity bit is incorrect are used to indicate "no data". For
    // extraction they mean no data was found. For insertion they mean do not
    // insert or insert invalid data as described below. (The two forms of
    // "no data" indication are needed to support proper insertion into
    // progressive clips.)
    // 
    // (See ATSC A/53 and CEA-708)
    // The following rules are used when extracting CC from MPEG user data.
    // 1. The four return bytes are initialized to 0xff 0xff 0xff 0xff
    // 2. The cc data triples (cc_type, cc_data_1, cc_data_2) are walked
    //    in order and each NTSC triple is processed. Walking stops when a
    //    DTVCC type triple is found.
    // 3. Each NTSC triple is processed as follows:
    //    a. Field 1 marked as invalid (cc_type is 0xf8) converts the first two
    //       returned bytes from 0xff to 0xfc. Do nothing if the first two
    //       return bytes are not 0xff.
    //    b. Field 1 marked as valid (0xfc) stuffs the cc_data_1 and cc_data2
    //       bytes into the first two return bytes
    //    c. Field 2 marked as invalid (0xf9) converts the second two returned
    //       bytes from 0xff to 0xfc. Do nothing if the second two return bytes
    //       are not 0xff.
    //    d. Field 2 marked as valid (0xfd) stuffs the cc_data_1 and cc_data2
    //       bytes into the second two return bytes
    //
    // The following rules are used when inserting CC into MPEG user data.
    // 1. Remove the NTSC cc data triples by walking the cc data triples
    //    converting NTSC triples to DTVCC channel packet data marked as
    //    invalid (cc_type is 0xfa). Stop walking when a DTVCC triple is
    //    found. Return failure if cannot convert one triple for progressive
    //    clips or two triples for interlace clips.
    // 2. Convert the first triple for progressive clips to NTSC cc data
    //    triples using the following rule.
    //    a. If the first two of the supplied four bytes are not 0xff,0xff or
    //       0xfc,0xfc then insert the two bytes as Field 1 data (0xfc)
    //       Else if the second two of the supplied four bytes are not
    //       0xff,0xff or 0xfc,0xfc then insert the two bytes as Field 2
    //       data (0xfd)
    //       Else if the first two of the supplied four bytes are 0xfc,0xfc
    //       then insert Field 1 data marked as invalid (0xf8).
    //       Else if the second two of the supplied four bytes are 0xfc then
    //       insert Field 2 data marked as invalid (0xf9).
    //       Else insert Field 1 data marked as invalid (0xf8).
    // 2. Convert the first two triples for interlace clips to NTSC cc data
    //    triples using the following rules.
    //    a. If the first two of the supplied four bytes are not 0xff,0xff or
    //       0xfc,0xfc then insert the two bytes as Field 1 data (0xfc) into
    //       the first triple
    //       Else insert Field 1 data marked as invalid (0xf8) into the first
    //       triple.
    //    b. If the second two of the supplied four bytes are not 0xff,0xff or
    //       0xfc,0xfc then insert the two bytes as Field 2 data (0xfd) into
    //       the second triple.
    //       Else insert Field 2 data marked as invalid (0xf9) into the second
    //       triple.
    omPlrClipDataCcFrame,

    // 4 bytes of timecode (8 TC nibbles of OmTcData)
    // This is per frame timecode embedded in the video essence AND/OR
    // per frame timecode stored in the clip file. Writes go to both locations
    // while reads prioritize video essence over clip file.
    omPlrClipDataTimecode,

    // 4 bytes of userbits (8 UB nibbles of OmTcData)
    // This is per frame timecode embedded in the video essence AND/OR
    // per frame timecode stored in the clip file. Writes go to both locations
    // while reads prioritize video essence over clip file.
    omPlrClipDataUserbits,

    // 4 bytes of timecode followed by 4 bytes userbits
    // This is per frame timecode embedded in the video essence AND/OR
    // per frame timecode stored in the clip file. Writes go to both locations
    // while reads prioritize video essence over clip file.
    omPlrClipDataTimeUser,

    // 8 bytes in OmTcData format
    // This is per frame timecode embedded in the video essence AND/OR
    // per frame timecode stored in the clip file. Writes go to both locations
    // while reads prioritize video essence over clip file.
    omPlrClipDataOmTcData,

    // VBI data stored in .vbi file or Omneon user data in mpeg video
    // OmPlrRawVbiHeader followed by 1440 bytes per line.
    omPlrClipDataRawVbi,

    // VBI data stored in a SMPTE436 VBI track
    // OmVancFrameHeader followed by frame data
    omPlrClipData436Vbi,

    // SMPTE291 VANC stored in a SMPTE436 VANC track.
    // OmVancFrameHeader followed by frame data
    omPlrClipData436Vanc,
    
    // SMPTE291 VANC stored in the video track such as specified in
    // SMPTE328 or SMPTE375
    // OmVancFrameHeader followed by frame data
    omPlrClipDataVideoEmbVanc,

    // CEA-708 closed caption data stored in mpeg user data.
    // The data is formatted as a subset of the ccdata_section in table 5 of
    // SMPTE 334-2-2007. Specifically it is the cc_count value followed by
    // cc_count groups of three bytes. So each frame consists of a byte
    // followed by N more bytes where N is the first byte times 3.
    omPlrClipDataCcA53,

    // Video index data as described in RP186-2008. The data is formatted in
    // the data buffer as a byte array per frame. The byte array starts with
    // a single byte that specifies the number of following bytes followed by
    // that many bytes of the RP186 payload. For instance if a clip contains
    // only class 1.1 of the RP186 data then a read of 2 frames from this clip
    // may respond with the following bytes:
    // 0x03 0x41 0x00 0x00 0x03 0x41 0x00 0x00
    omPlrClipDataViRp186,

    // 8 bytes in OmTcData format
    // This is per frame timecode stored in the clip file. Reads and writes
    // of this data type will not use the timecode stored in the video
    // essence.
    omPlrClipDataClipFileOmTcData,

    // 8 bytes in OmTcData format
    // This is per frame timecode stored in the video essence. Reads and writes
    // of this data type will not use the timecode stored in the clip file.
    omPlrClipDataVideoEssenceOmTcData,
};


// This header is at the beginning of each frame of VBI data. A frame of VBI
// data consists of pairs of video vbi lines, one from each field. A VBI line
// is 720 samples wide per video line, 1 byte per sample, luma data only. The
// size in bytes of a VBI (pair of) lines is 2 * 720 * 1 = 1440 bytes.
struct OmPlrRawVbiHeader {
    uint headerSize;// size (in bytes) of this header
    uint totalSize; // size (in bytes) of header and following data bytes
    uint lineMask;  // bitmask of line numbers, bit0 set for line 1, bit1 set
                    // for line 2, etc.
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

/*! \endcond OmneonIgnore */

#endif
