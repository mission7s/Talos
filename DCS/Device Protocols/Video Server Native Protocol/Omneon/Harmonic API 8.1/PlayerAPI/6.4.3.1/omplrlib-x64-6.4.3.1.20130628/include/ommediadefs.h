/**********************************************************************
 Filename:    ommediadefs.h

 Description: Various media defines

 Copyright (c) 1998-2007 Omneon Video Networks (TM)

 OMNEON VIDEO NETWORKS CONFIDENTIAL
************************************************************************/

#ifndef _OMMEDIADEFS_H_
#define _OMMEDIADEFS_H_

/** 
 * @file ommediadefs.h
 * Various media constants and types.
 */

#include <omdefs.h>


/** 
 * Video format. 
 * Do not change value of enumerators; add new enumerators at end of list. 
 */
enum OmVideoFormat {
    omVidFmtInvalid = 0x0,              /**< Invalid format. */
    omVidFmt525Line29_97Hz2_1 = 0x1,    /**< 525i29.97 */
    omVidFmt625Line25Hz2_1 = 0x2,       /**< 625i25 */
    omVidFmt1125Line29_97Hz2_1 = 0x3,   /**< 1080i29.97 (SMPTE 274M System 5) */
    omVidFmt1125Line25Hz2_1 = 0x4,      /**< 1080i25 (SMPTE 274M System 6) */
    omVidFmt750Line59_94Hz = 0x5,       /**< 720p59.94 */
    omVidFmt750Line50Hz = 0x6,          /**< 720p50 */
    omVidFmt1125Line50Hz = 0x7,         /**< 1080p50 (SMPTE 274M System 3) */
    omVidFmt1125Line59_94Hz = 0x8,      /**< 1080p59.94 (SMPTE 274M System 2)*/
    omVidFmt525Line59_94Hz = 0x9,       /**< 525p59.94 (SMPTE 293M) (internal) */
    omVidFmt625Line50Hz = 0xa,          /**< 625p50 (internal) */
    omVidFmt1125Line29_97HzPsf = 0xb,   /**< 1080p29.97/psf (SMPTE 274M System B) */
    omVidFmt1125Line25HzPsf = 0xc,      /**< 1080p25/psf (SMPTE 274M System C) */
};

/** 
 * Video raster geometry.
 */
enum OmVideoScan {
    omVidScanInvalid,               /**< Invalid value. */
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
// Do not change these numbers... add new ones wherever there are unused numbers.
enum OmMediaType {
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
    // unused           =11,
    omMediaData         =12,
    // unused           =13,
    // unused           =14,
    omMediaTc           =15,    /**< Omneon Timecode. */
    omMediaDnxhd        =16,    /**< Avid's DNxHD. */
    omMediaMpeg4Video   =17,    /**< Standard, IEC-14496-2 video. */
    omMediaAvc          =18,    /**< Standard, IEC-14496-10 video. */
    omMediaAlawAudio    =19,    /**< Standard, ITU-T G.711 audio. */
    omMedia436mVbi      =20,    /**< Standard, S436M VBI. */
    omMedia436mAnc      =21,    /**< Standard, S436M ANC. */
    omMediaMpeg1System  =22,    /**< Standard, ISO/IEC-11172-1 MPEG-1 system stream. */
    omMediaDisplay      =23,    /**< Omneon output display control (BFC, monitor, etc). */
    // Update omMediaNumTypes when adding new types ...
    // Warning, I think this is stored in a 6-bit int somewhere...
};

// Number of types in OmMediaType (including unused ones):
enum { omMediaNumTypes = 24 };

// Stream (wire) containers.  Note these are similar to OmMediaType, but
// OmStreamType reflects the top-level container on the wire, while OmMediaType
// represents individual data types.  Currently most media types appear
// on the wire as themselves, without containers.  We are moving towards
// wire containers (like MTS, Program Streams, MXF, etc), although the original
// ten mediatypes, now reflected here as stream types, will always remain.
enum OmStreamType {
    omStreamUnknown     = 0,
    omStreamMpegVes     = 1,    // MPEG video elementary stream
    // unused           = 2
    // unused           = 3
    omStreamAacAudio    = 4,    // AAC audio
    omStreamPcmAudio    = 5,    // PCM audio
    omStreamDv          = 6,    // DV-style dif blocks
    // unused           = 7
    omStreamRec601Video = 8,    // standard, SMPTE Rec 601 video
    omStreamHdcam       = 9,
    omStreamVbi         =10,    // VBI stream

    omStreamMuxed       =11,    // multiplexed video/audio
    omStreamData        =12,    // streamed (unknown) data
    omStreamMpegTs      =13,    // MPEG transport stream
    omStreamMxf         =14,    // MXF stream (future)
    omStreamTc          =15,    // timecode
    omStreamDnxhd       =16,    // Avid's DNxHD
    omStreamMpeg4Ves    =17,    // standard, IEC-14496-2 video elementary stream
    omStreamAvc         =18,    // standard, IEC-14496-10 video
    omStreamAlawAudio   =19,    // standard, ITU-T G.711 audio
    omStream436mVbi     =20,    // standard, S436M VBI/ANC as MXF KLVs
    omStream436mAnc     =21,    // standard, S436M VBI/ANC as MXF KLVs
    omStreamMpeg1System =22,    // standard, ISO/IEC-11172-1 MPEG-1 system stream
    omStreamDisplay     =23,    // Omneon output display control (BFC, monitor, etc)
};

typedef enum OmStreamType OmStreamPairType[2];

/**
 * Media File Type constants.
 * Define the file type for file readers and writers.
 */
enum OmMediaFileType {
    omMediaFileTypeUnknown = 0, /**< Unknown, or not in a file by itself. */

    // containers
    omMediaFileTypeDv,          /**< IEC-61834 DV video/audio. */
    omMediaFileTypeQt,          /**< QuickTime container file. */
    omMediaFileTypeMxf,         /**< MXF container file. */
    omMediaFileTypeMpegTs,      /**< MPEG transport stream. */
    omMediaFileTypeMpegPs,      /**< MPEG program stream. */
    omMediaFileTypeMpeg4,       /**< MPEG-4 container. */

    // single-track elementary files
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
    omMediaFileTypeMpeg4V,      /**< MPEG-4 part 2 (IEC-14496-2). */
    omMediaFileTypeAvc,         /**< AVC (IEC-14496-10). */
    omMediaFileTypeMpeg1System, /**< MPEG-1 system stream. */
    omMediaFileTypeAac,         /**< AAC audio. */

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

// Audio format
enum OmAudioFormat {
    omAudioFormatUnknown = 0,
    omAudioFormatPcm = 1,       // Pulse-code modulation
    omAudioFormatRaw = 2,       // Uncompressed audio
    omAudioFormatAC3 = 3,       // Dolby's AC3
    omAudioFormatAlaw = 4,      // A-Law compression (ITU-T G.711)
    omAudioFormatAac = 5,       // AAC compression
};

// A structure that summarizes all the interesting attributes of a video or
// audio track
struct OmMediaSummary {
    enum OmMediaType type;           // as defined above
    enum OmVideoSampleRatio vsr;     // as defined above
    enum OmVideoAspectRatio aspect;  // as defined above
    uint bitrate;               // bitrate for the track; 0 if its embedded audio
    uint bitsPerUnit;           // 16 or 24 for audio (unit is a sample);
                                // 8 or 10 for 601 video (unit is a pixel);
                                // otherwise 0
    uint sampleRate;            // media sample rate * 100; e.g. NTSC video is 2997
                                // 48khz audio is 4800000.
    uint channels;              // 1 for video; N for audio

    union Specific {
        struct Mpeg {
            uint gopLength;     // length of the gop structure; usually 15 for
                                // MPEG video, but is one for everything else
            uint subGopLength;  // length of the sub-gop; usually 3 for IBBPBBP...
                                // MPEG video; one for everything else
        } mpeg;
        struct Audio {
            enum OmAudioFormat format;
            unsigned char bigEndian;
            unsigned char sampleStride;
        } audio;
        struct Vbi {
            uint lineMask;
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

// A new version of OmMediaSummary, adds width, height
struct OmMediaSummary1 {
    enum OmMediaType type;          // as defined above
    enum OmVideoSampleRatio vsr;    // as defined above
    enum OmVideoAspectRatio aspect; // as defined above
    uint bitrate;                   // bitrate for the track; 0 if it's embedded audio
    uint bitsPerUnit;               // 16 or 24 for audio (unit is a sample);
                                    // 8 or 10 for 601 video (unit is a pixel);
                                    // otherwise 0
    uint sampleRate;                // media sample rate * 100; e.g. NTSC video is 2997
                                    // 48khz audio is 480000.
    uint channels;                  // 1 for video; N for audio

    union OMMEDIA_N1(Specific) {
        struct OMMEDIA_N1(Mpeg) {
            uint gopLength;         // length of the gop structure; usually 15 for
                                    // MPEG video, but is one for everything else
            uint subGopLength;      // length of the sub-gop; usually 3 for IBBPBBP...
                                    // MPEG video; one for everything else
            unsigned short width;
            unsigned short height;
        } video;
        struct OMMEDIA_N1(Audio) {
            enum OmAudioFormat format;
            unsigned char bigEndian;
            unsigned char sampleStride;
        } audio;
        struct OMMEDIA_N1(Vbi) {
            uint lineMask;
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
            || type == omMediaMpeg4Video;
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
            || type == omMedia436mAnc;
    }

#endif
};

#    undef OMMEDIA_N1

#ifdef __cplusplus
#ifndef SWIG
// Utility methods to translate enumerators to strings and vice versa.
struct MediaSummaryName {
    static const char* get(OmMediaType);
    static const char* get(OmStreamType);
    static const char* get(OmVideoSampleRatio);
    static const char* get(OmVideoAspectRatio);
    static const char* get(OmFrameRate);

    static OmMediaType        getMediaType(const char*);
    static OmVideoSampleRatio getVsr(const char*);
    static OmVideoAspectRatio getVar(const char*);
    static OmMediaFileType    getFileType(const char*);
    static OmFrameRate        getFrameRate(const char*);
};
#endif
#endif


#endif // _OMMEDIADEFS_H_
