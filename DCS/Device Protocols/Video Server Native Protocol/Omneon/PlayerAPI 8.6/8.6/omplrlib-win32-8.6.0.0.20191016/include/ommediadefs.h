/**********************************************************************
 Filename:    ommediadefs.h

 Description: Various media defines

 Copyright (c) 1998-2012, Harmonic Inc. All rights reserved.
************************************************************************/

#ifndef _OMMEDIADEFS_H_
#define _OMMEDIADEFS_H_

/** 
 * @file ommediadefs.h
 * Various media constants and types.
 */

#include <omdefs.h>


/** 
 * Describes the video format to be used. 
 */
enum OmVideoFormat {
    omVidFmtInvalid = 0x0,              /**< Invalid format. */
    omVidFmt525Line29_97Hz2_1 = 0x1,    /**< 525 lines/frame, 29.97 Hz frame rate, 2:1 interlace */
    omVidFmt625Line25Hz2_1 = 0x2,       /**< 625 lines/frame, 25 Hz frame rate, 2:1 interlace */
    omVidFmt1125Line29_97Hz2_1 = 0x3,   /**< SMPTE 274M System 5: 1125 lines/frame (1080 active); 2200 (1920 active), 30/1.001 Hz frame rate, 74.25/1.001 MHz clock, 2:1 interlace */
    omVidFmt1125Line25Hz2_1 = 0x4,      /**< SMPTE 274M System 6: 1125 lines/frame (1080 active), 2640 (1920 active), 25 Hz frame rate, 74.25 MHz clock, 2:1 interlace */
    omVidFmt750Line59_94Hz = 0x5,       /**< 750 lines/frame, 59_94 Hz frame rate */
    omVidFmt750Line50Hz = 0x6,          /**< 750 lines/frame, 50 Hz frame rate */
    omVidFmt1125Line50Hz = 0x7,         /**< 1080p50 (SMPTE 274M System 3) */
    omVidFmt1125Line59_94Hz = 0x8,      /**< 1080p59.94 (SMPTE 274M System 2)*/
    omVidFmt525Line59_94Hz = 0x9,       /**< 525p59.94 (SMPTE 293M) (internal) */
    omVidFmt625Line50Hz = 0xa,          /**< 625p50 (internal) */
    omVidFmt1125Line29_97HzPsf = 0xb,   /**< 1080p29.97/psf (SMPTE 274M System B) */
    omVidFmt1125Line25HzPsf = 0xc,      /**< 1080p25/psf (SMPTE 274M System C) */
    omVidFmt2250Line50Hz = 0xd,         /**< ST 2036-1 UHDTV1, 3840x2160/50/P */
    omVidFmt2250Line59_94Hz = 0xe,      /**< ST 2036-1 UHDTV1, 3840x2160/59.94/P */
    omVidFmt2250Line25Hz = 0xf,         /**< 2160p25 (internal) */
    omVidFmt2250Line29_97Hz = 0x10,     /**< 2160p29.97 (internal) */
    omVidFmt1125Line25Hz = 0x11,        /**< 1080p25 (SMPTE 274M System 9) */
    omVidFmt1125Line29_97Hz = 0x12,     /**< 1080p59.94 (SMPTE 274M System 8) */
    // Do not change value of enumerators; add new enumerators at end of list. 
};

/** 
 * Video raster geometry.
 */
enum OmVideoScan {
    omVidScanInvalid,               /**< Invalid value. */
    omVidScan2160Line3840Pixel,     /**< ST 2036-1 UHDTV1, 2160 active lines, 3840 active pixels. */
    omVidScan1080Line1920Pixel,     /**< SMPTE 274M: 1080 active lines, 1920 active pixels. */
    omVidScan720Line1280Pixel,      /**< SMPTE 296M: 720 active lines, 1280 active pixels. */
    omVidScan480Line720Pixel,       /**< CCIR 601, 480 active lines, 720 active pixels. */
    omVidScan576Line720Pixel,       /**< CCIR 601, 576 active lines, 720 active pixels. */
};

/**
 * Video sequence coding.
 */
enum OmSequenceCodingType {
    omSequenceIntraCoded,     /**< Most media types are always this. */
    omSequenceNonIntraCoded   /**< Only mpeg with P and/or B frames. */
};

/**
 * Video frame structure.
 */
enum OmFrameStruct {
    omFrmStructInvalid,     /**< Invalid frame structure. */
    omFrmStructInterlace,   /**< Interlaced frame. */
    omFrmStructProgressive, /**< Progressive frame. */
};

/**
 * Video field rate.
 */
enum OmFieldRate {
    omFldRateInvalid,   /**< Invalid, unsupported or unknown. */
    omFldRate24Hz,      /**< 24 fields per second. */
    omFldRate50Hz,      /**< 50 fields per second. */
    omFldRate59_94Hz,   /**< 59.94 fields per second. */
    omFldRate60Hz       /**< 60 fields per second. */
};

/** 
 * Video frame rates.
 * This enumeration lists all the supported frame rates.
 */
enum OmFrameRate {
    omFrmRateInvalid,   /**< Invalid, unsupported or unknown. */
    omFrmRate24Hz,      /**< 24Hz */
    omFrmRate25Hz,      /**< 25Hz */
    omFrmRate29_97Hz,   /**< 29.97Hz */
    omFrmRate30Hz,      /**< 30Hz */
    omFrmRate50Hz,      /**< 50Hz */
    omFrmRate59_94Hz,   /**< 59.94Hz */
    omFrmRate60Hz,      /**< 60Hz */
    omFrmRate23_976Hz   /**< 23.976Hz */
};

#ifdef __cplusplus
inline float getRealFrameRate(OmFrameRate code)
{
    switch (code) {
    case omFrmRate23_976Hz: return 24000 / 1001.0;
    case omFrmRate24Hz:     return 24.0;
    case omFrmRate25Hz:     return 25.0;
    case omFrmRate29_97Hz:  return 30000 / 1001.0;
    case omFrmRate30Hz:     return 30.0;
    case omFrmRate50Hz:     return 50.0;
    case omFrmRate59_94Hz:  return 60000 / 1001.0;
    case omFrmRate60Hz:     return 60.0;
    default:                return  1.0;
    }
}
#endif // __cplusplus

/**
 * Field Id.
 */
enum OmFieldId {
    omFieldInvalid,                 /**< Invalid field. */
    omFieldAny = omFieldInvalid,    /**< Any field. */
    omField1,                       /**< Field 1. */
    omField2,                       /**< Field 2. */
};

/**
 * The basic type of media contained in a single track of a clip.
 */
enum OmMediaType {
    // Do not change these numbers... add new ones wherever there are unused numbers.
    omMediaUnknown      = 0,    /**< Unknown or invalid. */
    omMediaMpegVideo    = 1,    /**< Standard, IEC-13818 video. */
    omMediaMpegStdAudio = 2,    /**< MPEG layer 1,2,3 audio. */
    omMediaMpegAc3      = 3,    /**< Dolby AC3 audio in an MTS. */
    omMediaAacAudio     = 4,    /**< Advanced Audio Coding. */
    omMediaPcmAudio     = 5,    /**< PCM audio. */
    omMediaDvVideo      = 6,    /**< DV video. */
    omMediaDvAudio      = 7,    /**< DV audio. */
    omMediaRec601Video  = 8,    /**< Standard, SMPTE Rec 601 video. */
    omMediaHdcam        = 9,    /**< Sony HDCAM. */
    omMediaVbi          =10,    /**< Omneon proprietary VBI, not S436M. */
    omMediaJpeg2000     =11,    /**< Standard, IEC-15444-1 Annex A codestreams. */
    omMediaData         =12,    /**< Data. */
    // unused           =13,
    omMediaGxfAnc       =14,    /**< Standard, RDD14-2010 Ancillary Data. */
    omMediaTc           =15,    /**< Omneon Timecode. */
    omMediaDnxhd        =16,    /**< Avid's DNxHD. */
    omMediaProRes       =17,    /**< Apple's ProRes video compression */
    omMediaAvc          =18,    /**< Standard, IEC-14496-10 video. */
    omMediaAlawAudio    =19,    /**< Standard, ITU-T G.711 audio. */
    omMedia436mVbi      =20,    /**< Standard, S436M VBI. */
    omMedia436mAnc      =21,    /**< Standard, S436M ANC. */
    omMediaMpeg1System  =22,    /**< Standard, ISO/IEC-11172-1 MPEG-1 system stream. */
    omMediaDisplay      =23,    /**< Omneon output display control (BFC, monitor, etc). */
    omMediaSubtitleIns  =24,    /**< Subtitle Insertion. */
    omMediaCc608        =25,    /**< EIA-608 closed caption track */
    omMediaCc708        =26,    /**< EIA-708 closed caption track */
    omMediaLxfAnc       =27,    /**< Standard, LXF Ancillary Data. */
    omMediaDolbyE       =28,    /**< Stored as PCM, but used internally */
    omMediaHevc         =29,    /**< Standard, IEC-23008-2: High efficiency video encoding*/
    // Update omMediaNumTypes when adding new types ...
    // Warning, I think this is stored in a 6-bit int somewhere...
};

enum { omMediaNumTypes = 30 /**< Number of types in OmMediaType (including unused ones) */ };

/**
 *  Stream (wire) containers.  Note these are similar to OmMediaType, but
 *  OmStreamType reflects the top-level container on the wire, while OmMediaType
 *  represents individual data types.  Currently most media types appear
 *  on the wire as themselves, without containers.  We are moving towards
 *  wire containers (like MTS, Program Streams, MXF, etc), although the original
 *  ten mediatypes, now reflected here as stream types, will always remain.
 *  
 *  @remarks Similar to OmMediaType, but OmStreamType reflects the top-level container on the wire, while
 *  OmMediaType represents individual data types. Currently most media types appear on the wire as
 *  themselves, without containers.
 */
enum OmStreamType {
    omStreamUnknown     = 0,
    omStreamMpegVes     = 1,    ///< MPEG video elementary stream
    // unused           = 2
    // unused           = 3
    omStreamAacAudio    = 4,    ///< AAC audio
    omStreamPcmAudio    = 5,    ///< PCM audio
    omStreamDv          = 6,    ///< DV-style dif blocks
    omStreamJpeg2000    = 7,    ///< Standard, IEC-15444-1 Annex A codestreams
    omStreamRec601Video = 8,    ///< Standard, SMPTE Rec 601 video
    omStreamHdcam       = 9,    ///< Unused
    omStreamVbi         =10,    ///< VBI stream

    omStreamMuxed       =11,    ///< Multiplexed video/audio
    omStreamData        =12,    ///< Streamed (unknown) data
    omStreamMpegTs      =13,    ///< MPEG transport stream
    omStreamGxfAnc      =14,    ///< Standard, RDD14-2010 VBI/ANC
    omStreamTc          =15,    ///< Timecode
    omStreamDnxhd       =16,    ///< Avid's DNxHD
    omStreamProRes      =17,    ///< Apple's ProRes video compression
    omStreamAvc         =18,    ///< Standard, IEC-14496-10 video
    omStreamAlawAudio   =19,    ///< Standard, ITU-T G.711 audio
    omStream436mVbi     =20,    ///< Standard, S436M VBI/ANC as MXF KLVs
    omStream436mAnc     =21,    ///< Standard, S436M VBI/ANC as MXF KLVs
    omStreamMpeg1System =22,    ///< Standard, ISO/IEC-11172-1 MPEG-1 system stream
    omStreamDisplay     =23,    ///< Omneon output display control (BFC, monitor, etc)
    omStreamSubtitleIns =24,    ///< Stream for sending Subtitle Insertion data
    omStreamCc608       =25,    ///< EIA-608 closed caption track
    omStreamCc708       =26,    ///< EIA-708 closed caption track
    omStreamLxfAnc      =27,    ///< Standard, LXF VBI/ANC
    omStreamDolbyE      =28,    ///< Stored as PCM, but used internally */
    omStreamHevc        =29,    ///< Standard, IEC-23008-2 video */
};

typedef enum OmStreamType OmStreamPairType[2];

/**
 * Media File Type constants.
 * Define the file type for file readers and writers.
 */
enum OmMediaFileType {
    omMediaFileTypeUnknown = 0, /**< Unknown, or not in a file by itself. */

    omMediaFileTypeDv,          /**< IEC-61834 DV video/audio. */
    omMediaFileTypeQt,          /**< QuickTime container file. */
    omMediaFileTypeMxf,         /**< MXF container file. */
    omMediaFileTypeMpegTs,      /**< MPEG transport stream. */
    omMediaFileTypeMpegPs,      /**< MPEG program stream. */
    omMediaFileTypeMpeg4,       /**< MPEG-4 container. */
    omMediaFileTypeMpegV,       /**< MPEG video. */
    omMediaFileTypeMpegA1,      /**< MPEG-1 audio, layer 1. */
    omMediaFileTypeMpegA2,      /**< MPEG-1 audio, layer 2. */
    omMediaFileTypeMpegA3,      /**< MPEG-1 audio, layer 3. */
    omMediaFileTypeHdcam,       /**< Sony HDCAM video. */
    omMediaFileTypeRec601,      /**< Uncompressed ITU rec 601; aka CCIR 601. */
    omMediaFileTypeDnxhd,       /**< Avid's DNxHD video. */
    omMediaFileTypeAiff,        /**< Apple's AIFF audio. */
    omMediaFileTypeWave,        /**< Microsoft's WAVE audio. */
    omMediaFileTypeAc3,         /**< Dolby's AC3 audio. */
    omMediaFileTypeVbi,         /**< Omneon proprietary VBI. */
    omMediaFileTypeData,        /**< Omneon proprietary data stream. */
    omMediaFileTypeAes3Audio,   /**< Raw PCM audio data. */
    omMediaFileTypeNull,
    omMediaFileTypeProRes,      /**< Apple's ProRes video compression. */
    omMediaFileTypeAvc,         /**< AVC (IEC-14496-10). */
    omMediaFileTypeMpeg1System, /**< MPEG-1 system stream. */
    omMediaFileTypeAac,         /**< AAC audio. */
    omMediaFileTypeGxf,         /**< GXF container file. */
    omMediaFileTypeJpeg2000,    /**< IEC 15444-1 Annex A codestreams */
    omMediaFileTypeCc608,       /**< EIA-608 closed caption track */
    omMediaFileTypeCc708,       /**< EIA-708 closed caption track */
    omMediaFileTypeLxf,         /**< LXF container file. */
    omMediaFileTypeHevc,        /**< HEVC (ISO/IEC 23008-2). */

    // add new enumerators here...

    nOmMediaFileTypes           // must be last
};

/**
 * Media Containment constants.
 * Specify how a container contains the essence.
 */
enum OmMediaContainment {
    omMediaContainmentUnspecified = 0,  /**< Unspecified or unknown. */
    omMediaContainmentReference,        /**< Referenced media. */
    omMediaContainmentEmbedded,         /**< Embedded media. */
    omMediaContainmentMixed             /**< A mix of referenced and embedded media. */
};

/**
 * Video Sample Ratio constants.
 * The pixel sample ratio among luma and chroma.
 */
enum OmVideoSampleRatio {
    omVideoSampleNone,          /**< Non-video data. */
    omVideoSample420,           /**< 4:2:0 data. */
    omVideoSample411,           /**< 4:1:1 data. */
    omVideoSample422,           /**< 4:2:2 data. */
    omVideoSample444            /**< 4:4:4 data. */
};

/**
 * Picture Aspect Ratio constants.
 */
enum OmVideoAspectRatio {
    omVideoAspectNone,          /**< Non-video data. */
    omVideoAspect4to3,          /**< 4:3 picture aspect ratio. */
    omVideoAspect16to9,         /**< 16:9 picture aspect ratio. */
    omVideoAspectOther
};

// SMPTE 2016-1, table 1; Active format descriptor
// the macro afdHd() and afdSd() encapsulate the values from table 1 in
// an eight bit value as described in table 4.
#define afdHd(v) ((v<<3)|4)
#define afdSd(v) (v<<3)

enum OmActiveFmtDesc {
    // AFD values common to 4:3 and 16:9
    // Legend:
    //   - Ac:  alternative center
    //   - Afd: active format descriptor
    //   - Alt: alternaive
    //   - Dup: duplicate
    //   - Ff:  full frame
    //   - Hc:  horizontally centered
    //   - Hd:  high def, i.e. a 16:9 coded frame
    //   - Ip:  image areas protected
    //   - Lb:  letterbox
    //   - Pb:  pillarbox
    //   - Sd:  standard def, i.e. a 4:3 coded frame
    //   - Vc:  vertically centered
    //   - 43:  4:3 image
    //   - 169: 16:9 iamge
    //   - 149: 14:9 iamge
    omAfdUnknown        = 0,
    omAfdSdReserved1    = afdSd(1),
    omAfdHdReserved1    = afdHd(1),
    omAfdSdReserved5    = afdSd(5),
    omAfdHdReserved5    = afdHd(5),
    omAfdSdReserved6    = afdSd(6),
    omAfdHdReserved6    = afdHd(6),
    omAfdSdReserved7    = afdSd(7),
    omAfdHdReserved7    = afdHd(7),
    omAfdSdReserved12   = afdSd(12),
    omAfdHdReserved12   = afdHd(12),

    // AFD codes in a 4:3 coded frame, hence 'omAfdSd'
    omAfdSdLb169        = afdSd(2), // Letterbox 16:9 image, at top of the coded
                                    // frame (see note 1)
    omAfdSdLb149        = afdSd(3), // Letterbox 14:9 image, at top of the coded
                                    // frame (see note 1)
    omAfdSdLb169Vc      = afdSd(4), // Letterbox image with an aspect ratio greater
                                    // than 16:9, vertically centered in the coded
                                    // frame (see note 1)
    omAfdSdFf43         = afdSd(8), // Full frame 4:3 image, the same as the
                                    // coded frame
    omAfdSdFf43Dup      = afdSd(9), // Full frame 4:3 image, the same as the coded
                                    // frame (see note 4)
    omAfdSdLb169VcIp    = afdSd(10),// Letterbox 16:9 image, vertically centered in
                                    // the coded frame with all image areas protected
    omAfdSdLb149Vc      = afdSd(11),// Letterbox 14:9 image, vertically centered in
                                    // the coded frame
    omAfdSdFf43Alt149   = afdSd(13),// Full frame 4:3 image, with alternative 14:9
                                    // center (see note 6)
    omAfdSdLb169Alt149  = afdSd(14),// Letterbox 16:9 image, with alternative 14:9
                                    // center (see note 6)
    omAfdSdLb169Alt43   = afdSd(15),// Letterbox 16:9 image, with alternative 4:3
                                    // center (see note 6)

    // AFD codes in a 16:9 coded frame, hence 'omAfdHd'
    omAfdHdFf169        = afdHd(2), // Full frame 16:9 image, the same as the coded
                                    // frame (see notes 1 and 2)
    omAfdHdPb149HcDup   = afdHd(3), // Pillarbox 14:9 image, horizontally centered in the
                                    // coded frame (see notes 1 and 3)
    omAfdHdLb169Vc      = afdHd(4), // Letterbox image with an aspect ratio greater
                                    // than 16:9, vertically centered in the coded
                                    // frame (see note 1)
    omAfdHdFf169Dup     = afdHd(8), // Full frame 16:9 image, the same as the coded
                                    // frame
    omAfdHdPb43Hc       = afdHd(9), // Pillarbox 4:3 image, horizontally centered
                                    // in the coded frame
    omAfdHdFf169Ip      = afdHd(10),// Full frame 16:9 image, with all image areas
                                    // protected (see note 5)
    omAfdHdPb149Hc      = afdHd(11),// Pillarbox 14:9 image, horizontally centered
                                    // in the coded frame
    omAfdHdPb43Atl149   = afdHd(13),// Pillarbox 4:3 image, with alternative 14:9
                                    // center (see note 6)
    omAfdHdFf169Alt149  = afdHd(14),// Full frame 16:9 image, with alternative 14:9
                                    // center (see note 6)
    omAfdHdFF169Alt43   = afdHd(15),// Full frame 16:9 image, with alternative 4:3
                                    // center (see note 6)
};
#undef afdHd
#undef afdSd

/**
 *  Video color space constants.
 */
enum OmVideoColorSpace {
    omVideoColorSpaceUnknown = 0,   /**< Unknown format  */
    omVideoColorSpaceBt601 = 1,     /**< BT.601 color space  */
    omVideoColorSpaceBt709 = 2,     /**< BT.709 color space  */
    omVideoColorSpaceBt2020 = 3,    /**< BT.2020 color space  */
};

/**
 *  Describes how audio is encoded.
 */
enum OmAudioFormat {
    omAudioFormatUnknown = 0,   ///< Unknown encoding format
    omAudioFormatPcm = 1,       ///< Pulse-code modulation
    omAudioFormatRaw = 2,       ///< Uncompressed audio
    omAudioFormatAC3 = 3,       ///< Dolby's AC3
    omAudioFormatAlaw = 4,      ///< A-Law compression (ITU-T G.711)
    omAudioFormatAac = 5,       ///< AAC compression
};

/**
 *  Provides summary information about a video or audio track.
 */
struct OmMediaSummary {
    enum OmMediaType type;              ///< As defined in enums
    enum OmVideoSampleRatio vsr;        ///< As defined in enums
    enum OmVideoAspectRatio aspect;     ///< As defined in enums
    uint bitrate;                       ///< Bitrate for the track; 0 if it is embedded audio
    uint bitsPerUnit;                   ///< 16 or 24 for audio (unit is a sample); 8 or 10 for supported video formats(unit is a pixel); otherwise 0
    uint sampleRate;                    ///< Media sample rate * 100; e.g. NTSC video is 2997; 48khz audio is 4800000.
    uint channels;                      ///< 1 for video; N for audio union
    
    /// Contains media type-specific information.
    union Specific {
        /// Provides video information if OmMediaType type is MPEG.
        struct Mpeg {
            uint gopLength;             ///< Length of the gop structure; usually 15 for MPEG, but is one for other formats
            uint subGopLength;          ///< Length of the sub-gop; usually 3 for IBBPBBP... MPEG video; one for other formats
        } mpeg;
        /// Provides audio information if OmMediaType type is audio.
        struct Audio {
            enum OmAudioFormat format;  ///< PCM, Raw, or AC3
            unsigned char bigEndian;    ///< 1 if data is Big Endian, 0 if data is little Endian
            unsigned char sampleStride; ///< Number of bytes to next sample
        } audio;
        /// Provides VBI information if OmMediaType type is VBI.
        struct Vbi {
            uint lineMask;              ///< Bit mask indicating lines that are encoded
        } vbi;
    } specific;

#ifdef __cplusplus
    OmMediaSummary()
      : type(omMediaUnknown),
        vsr(omVideoSampleNone),
        aspect(omVideoAspectNone),
        bitrate(0),
        bitsPerUnit(0),
        sampleRate(0),
        channels(0)
    {
        specific.mpeg.gopLength = 0;
        specific.mpeg.subGopLength = 0;
    }
#endif
};

#    ifdef __cplusplus
        #define OMMEDIA_N1(NAME)      NAME
#    else
        // Make 'C' struct names unique
        #define OMMEDIA_N1(NAME)      NAME##1
#    endif

/**
 *  Provides summary information about a video or audio track as in Struct OmMediaSummary and in
 *  addition includes width and height data.
 */
struct OmMediaSummary1 {
    enum OmMediaType type;              ///< As defined in enums
    enum OmVideoSampleRatio vsr;        ///< As defined in enums
    enum OmVideoAspectRatio aspect;     ///< As defined in enums
    uint bitrate;                       ///< Bitrate for the track; 0 if it is embedded audio
    uint bitsPerUnit;                   ///< 16 or 24 for audio (unit is a sample); 8 or 10 for supported video format(unit is a pixel); otherwise 0
    uint sampleRate;                    ///< Media sample rate * 100; e.g. NTSC video is 2997; 48khz audio is 4800000.
    uint channels;                      ///< 1 for video; N for audio union
    
    /// Contains media type-specific information.
    union OMMEDIA_N1(Specific) {
        /// Provides video information if OmMediaType type is MPEG.
        struct OMMEDIA_N1(Mpeg) {
            uint gopLength;             ///< Length of the gop structure; usually 15 for MPEG, but is one for other formats
            uint subGopLength;          ///< Length of the sub-gop; usually 3 for IBBPBBP... MPEG video; one for other formats
            unsigned short width;       ///< Video width (in pixels)
            unsigned short height;      ///< Video height (in pixels)
        } video;
        /// Provides audio information if OmMediaType type is audio.
        struct OMMEDIA_N1(Audio) {
            enum OmAudioFormat format;  ///< PCM, Raw, or AC3
            unsigned char bigEndian;    ///< 1 if data is Big Endian, 0 if data is little Endian
            unsigned char sampleStride; ///< Number of bytes to next sample
        } audio;
        /// Provides VBI information if OmMediaType type is VBI.
        struct OMMEDIA_N1(Vbi) {
            uint lineMask;              ///< Bit mask indicating lines that are encoded
        } vbi;
    } specific;

#ifdef __cplusplus
    OmMediaSummary1()
      : type(omMediaUnknown),
        vsr(omVideoSampleNone),
        aspect(omVideoAspectNone),
        bitrate(0),
        bitsPerUnit(0),
        sampleRate(0),
        channels(0)
    {
        specific.video.gopLength = 0;
        specific.video.subGopLength = 0;
        specific.video.width = 0;
        specific.video.height = 0;
    }

    // Set from previous version of struct
    void setFrom(OmMediaSummary &x) {
        type = x.type;
        vsr = x.vsr;
        aspect = x.aspect;
        bitrate = x.bitrate;
        bitsPerUnit = x.bitsPerUnit;
        sampleRate = x.sampleRate;
        channels = x.channels;
        specific.video.gopLength = x.specific.mpeg.gopLength;
        specific.video.subGopLength = x.specific.mpeg.subGopLength;
        specific.video.width = 0;
        specific.video.height = 0;
    };

    // Set previous version of struct
    void setTo(OmMediaSummary &x) {
        x.type = type;
        x.vsr = vsr;
        x.aspect = aspect;
        x.bitrate = bitrate;
        x.bitsPerUnit = bitsPerUnit;
        x.sampleRate = sampleRate;
        x.channels = channels;
        x.specific.mpeg.gopLength = specific.video.gopLength;
        x.specific.mpeg.subGopLength = specific.video.subGopLength;
    }

    bool isVideoType() const
    {
        return type == omMediaMpegVideo
            || type == omMediaDvVideo
            || type == omMediaAvc 
            || type == omMediaRec601Video
            || type == omMediaHdcam 
            || type == omMediaDnxhd 
            || type == omMediaProRes
            || type == omMediaJpeg2000;
    }

    bool isAudioType() const
    {
        return type == omMediaPcmAudio
            || type == omMediaDvAudio
            || type == omMediaMpegAc3
            || type == omMediaMpegStdAudio
            || type == omMediaAlawAudio;
    }

    bool isDataType() const
    {
        return type == omMediaVbi
            || type == omMediaTc
            || type == omMedia436mVbi
            || type == omMedia436mAnc
            || type == omMediaGxfAnc
            || type == omMediaCc608
            || type == omMediaCc708;
    }

#endif
};

#    undef OMMEDIA_N1

#ifdef __cplusplus
#ifndef SWIG
/**
 *  Provides a mechanism which translates between enums and string representations.
 */
struct MediaSummaryName {
    ///< Returns a string representation of an OnMediaType.
    static const char* get(OmMediaType);
    ///< Returns a string representation of an OnStreamType.
    static const char* get(OmStreamType);                
    ///< Returns a string representation of an OnVideoSampleRatio.
    static const char* get(OmVideoSampleRatio);
    ///< Returns a string representation of an OnVideoAspectRatio.
    static const char* get(OmVideoAspectRatio);
    ///< Returns a string representation of an OnFrameRate.
    static const char* get(OmFrameRate);
    ///< Returns a string representation of an OmFieldRate.
    static const char* get(OmFieldRate);
    ///< Returns a string representation of an OmFrameStruct.
    static const char* get(OmFrameStruct);
    ///< Returns a string representation of an OmVideoScan.
    static const char* get(OmVideoScan);                 

    ///< Returns matching OmMediaType string, else the enum's invalid value
    static OmMediaType        getMediaType(const char*);
    ///< Returns matching OmVideoSampleRatio string, else the enum's invalid value
    static OmVideoSampleRatio getVsr(const char*);
    ///< Returns matching OmVideoAspectRatio string, else the enum's invalid value
    static OmVideoAspectRatio getVar(const char*);
    ///< Returns matching OmMediaFileType string, else the enum's invalid value
    static OmMediaFileType    getFileType(const char*);
    ///< Returns matching OmFrameRate string, else the enum's invalid value
    static OmFrameRate        getFrameRate(const char*);
    ///< Returns matching OmFrameRate string, else the enum's invalid value
    static OmFieldRate        getFieldRate(const char*);
    ///< Returns matching OmFrameStruct string, else the enum's invalid value
    static OmFrameStruct      getFrameStruct(const char*);
    ///< Returns matching OmVideoScan string, else the enum's invalid value
    static OmVideoScan        getVideoScan(const char*);
};
#endif
#endif


#endif // _OMMEDIADEFS_H_
