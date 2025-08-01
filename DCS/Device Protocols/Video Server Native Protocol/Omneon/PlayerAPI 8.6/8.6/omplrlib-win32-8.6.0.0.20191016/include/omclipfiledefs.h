#ifndef __omclipfiledefs_h__
#define __omclipfiledefs_h__

/*

 Filename:    omclipfiledefs.h

 Author:      Ben Humble

 Description: Subset of omplrdefs.h that are used in conjunction with cliplib and media API.

 Copyright (c) 1998-2013, Harmonic Inc. All rights reserved.

*/


enum OmPlrTrackType { // If you modify this enum, update the array trackTypeNames in clipfileutils.cc to match
    omPlrTrackTypeInvalid,
    omPlrTrackTypeVideo,
    omPlrTrackTypeAudio,
    omPlrTrackTypeVbi,
};

// Audio File Formats
enum OmPlrAudioFileType {
    omPlrAudioFileUnknown,
    omPlrAudioFileAiff,
    omPlrAudioFileWav,
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

    // VBI data stored in a SMPTE436 VBI track; See omPlrClipDataWrapperVbi
    // OmVancFrameHeader followed by frame data
    omPlrClipData436Vbi,

    // SMPTE291 VANC stored in a SMPTE436 VANC track. See omPlrClipDataWrapperVanc
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

    // Uncompressed VBI data stored in the wrapper, as opposed to embedded in
    // the essence. For example, GXF Uncompressed VBI, or SMPTE 436 Vbi.
    // OmVancFrameHeader, followed by frame data.
    omPlrClipDataWrapperVbi,

    // SMPTE291 VANC stored in the wrapper, as opposed to embedded in the essence.
    // For example, the GXF Anc, or SMPTE 436 tracks.
    // OmVancFrameHeader, followed by frame data.
    omPlrClipDataWrapperVanc,

    // Uncompressed VBI data embedded in the essence.
    // OmVancFrameHeader, followed by frame data.
    omPlrClipDataVideoEmbVbi,

    // ST2016-1-2009 data byte, synthesized from SPS and ATSC A/72 AFD SEI AFD
    // packets in H.264 streams.
    omPlrClipDataAfdA72,

    // Add new values before this entry
    omPlrClipDataEnd = 0xFFFFFFFF,
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

#endif
