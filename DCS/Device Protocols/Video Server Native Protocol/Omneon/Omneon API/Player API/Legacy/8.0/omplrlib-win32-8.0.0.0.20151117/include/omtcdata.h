/*********************************************************************
 Filename:          omtcdata.h

 Description:       raw timecode format

 Copyright (c) 1999-2011, Harmonic Inc. All rights reserved.

 HARMONIC, INC. CONFIDENTIAL
***********************************************************************/

/** 
 * @file omtcdata.h
 * Definition of the OmTcData raw timecode format.
 */
 
#ifndef __omtcdata_h__
#define __omtcdata_h__

#include <omdefs.h>
#include <ommediadefs.h>
#include <stdio.h>
#ifdef __cplusplus
#include <string>
#endif

#if defined _MSC_VER && _MSC_VER >= 1200
#define snprintf _snprintf
#endif

// SMPTE 12M, "Time and Control Code":

/**
 *  The OmTcData structure presents the raw 64 bits of the house time reading; of the 64 bits, 32 are user
 *  data and some of the rest are dedicated flag bits such as the Drop Frm flag. The OmTcData
 *  structure will be filled with 0xFF values if there is no valid VITC time available. The OmTcData
 *  structure is defined in omtcdata.h. The structure defines the raw 64 bits of the timecode as defined in
 *  the standard “SMPTE 12M-1999, Time and Control Code”. The structure uses bit definitions; it has
 *  been carefully designed to fit into 64 bits. See omtcdata.h for more information.
 */
struct OmTcData {
    uint framesUnits:4;       ///<  Byte 0: Frame number (units)
    uint binaryGroup1:4;      ///< Binary group 1
    uint framesTens:2;        ///< Byte 1: Frame number (tens)
    uint dropFrame_59_94:1;   ///< &true* ==> drop-frame, &false* ==> non-drop-frame, for FldRate59_94Hz; reserved, for FldRate50Hz
    uint colorFrame:1;        ///< Color-frame marker
    uint binaryGroup2:4;      ///< Binary group 2
    uint secondsUnits:4;      ///< Byte 2
    uint binaryGroup3:4;      ///< Binary group 3
    uint secondsTens:3;       ///< Byte 3: Seconds (tens)
    uint pcFm_59_94_bg0_50:1; ///< NRZ phase correction for LTC FldRate59_94Hz; Binary group flag #0 for LTC/VITC FldRate50Hz; Fieldmark for VITC FldRate59_94Hz
    uint binaryGroup4:4;      ///< Binary group 4
    uint minutesUnits:4;      ///< Byte 4: Minutes (units)
    uint binaryGroup5:4;      ///< Binary group 5
    uint minutesTens:3;       ///< Byte 5: Minutes (tens)
    uint bg0_59_94_bg2_50:1;  ///< Binary group flag #0 for FldRate59_94Hz; binary group flag #2 for FldRate50Hz:
    uint binaryGroup6:4;      ///< Binary group 6
    uint hoursUnits:4;        ///< Byte 6: Hours (units)
    uint binaryGroup7:4;      ///< Binary group 7
    uint hoursTens:2;         ///< Byte 7: Hours (tens)
    uint bg1:1;               ///< Binary group flag #1 (for both FldRate59_94Hz and FldRate50Hz)
    uint bg2_59_94_pcFm_50:1; ///< Binary group flag #2 for FldRate59_94Hz; NRZ phase correction for LTC FldRate50Hz; Fieldmark for VITC FldRate50Hz:
    uint binaryGroup8:4;      ///< Binary group 8

#ifdef __cplusplus

    bool operator==(const OmTcData &other) const {
        return ((*(uint *)this == *(uint *)&other) &&
                (*((uint *)this + 1) == *((uint *)&other + 1)));
    }

    // this struct can't have a ctor because it's used in unions
    void Init() {
        Zero();
        SetInvalid();
    }

    void SetInvalid() { framesUnits = 15; }
    bool IsInvalid() const { return framesUnits == 15; }
    bool IsValid() const { return framesUnits != 15; }

    bool IsDropFrame() const { return dropFrame_59_94; }
    bool IsColorFrame() const { return colorFrame; }
    uint Hours() const { return hoursUnits + hoursTens * 10; }
    uint Minutes() const { return minutesUnits + minutesTens * 10; }
    uint Seconds() const { return secondsUnits + secondsTens * 10; }
    uint Frames() const { return framesUnits + framesTens * 10; }
    uint Fields(bool is625) const {
        uint num = 2 * (framesUnits + framesTens * 10);
        if ((is625 && bg2_59_94_pcFm_50) ||
            (!is625 && pcFm_59_94_bg0_50))
            ++num;
        return num;
    }
    uint Field(OmFieldRate fieldRate) const { 
        if (fieldRate == omFldRate50Hz)
            return bg2_59_94_pcFm_50;
        else
            return pcFm_59_94_bg0_50;
    }

    uint Field(uint roundedHz) const {          // returns the fieldMark flag
        if (roundedHz == 50 || roundedHz == 25)
            return bg2_59_94_pcFm_50;
        else
            return pcFm_59_94_bg0_50;
    }

    // Translate OmTcData to SMPTE 12M-2 ANC timecode
    void GetAncTimecode(unsigned char* tc, uint dbb1, uint vitcA, 
                        uint vitcB) const
    {
        // create DBB2 based on VITC values
        uint dbb2 = ((((vitcA > 0) && (vitcA < vitcB)) ? vitcA : vitcB) & 0x1f) | 
            (((vitcB > vitcA) ? 1 : 0) << 5) | (1 << 7);

        // loop thru and set each of the User Data Words
        for (uint udw = 0; udw < 16; udw++) {
            tc[udw] = 0;

            // pick off OmTcData values and set bits 5-8 
            tc[udw] = (udw % 2) ?  
                ((*((unsigned char *)this + udw/2) & 0xf0) >> 4) : 
                ((*((unsigned char *)this + udw/2) & 0xf) << 4);

            // clear the first 4 bits set bit 4 with the DBB
            tc[udw] &= ~0xf;
            tc[udw] |= (udw < 8) ? 
                (((dbb1 & (1 << udw))) ? 0x8 : 0) :
                (((dbb2 & (1 << (udw - 8)))) ? 0x8 : 0x0);
        }
        
        return;
    }

    // returns index of frame in the range (0, fps]
    uint GetFrameIndex(OmFrameRate frameRate) const
    {
        if (IsInvalid())
            return 0;
        if (frameRate == omFrmRate50Hz)
            return Fields(true);
        else if (frameRate == omFrmRate59_94Hz)
            return Fields(false);
        else
            return Frames();
    }

    uint GetTime(bool is625) const {
        if (IsInvalid())
            return 0;
        if (is625) {
            return Hours() * 25 * 60 * 60 + Minutes() * 25 * 60 +
                Seconds() * 25 + Frames();
        }
        else {
            if (dropFrame_59_94 == 0) {
                return Hours() * 30 * 60 * 60 + Minutes() * 30 * 60 +
                    Seconds() * 30 + Frames();
            }
            else {
                uint num;
                uint min = Minutes();
                uint nonDropMin = (min + 9) / 10;
                uint dropMin = min - nonDropMin;
                uint seconds = Seconds();
                uint frames = Frames();
                num = Hours() * 6 * (1800 + 9 * 1798) + 
                    dropMin * 1798 + nonDropMin * 1800 +
                    Seconds() * 30 + Frames();
                if ((min % 10) != 0) {
                    if ((seconds == 0) && (frames < 2))
                        num -= 1;
                    else
                        num -= 2;
                }
                return num;
            }
        }
    }

    uint GetTime(OmFrameRate frameRate) const {
        if (IsInvalid())
            return 0;

        switch (frameRate) {
        default:
        case omFrmRate25Hz:
            return GetTime(true);

        case omFrmRate29_97Hz:
            return GetTime(false);
            break;

        case omFrmRate50Hz: {
            uint fr = GetTime(true) * 2;
            if (bg2_59_94_pcFm_50)
                fr++;
            return fr;
        }

        case omFrmRate59_94Hz: {
            uint fr = GetTime(false) * 2;
            if (pcFm_59_94_bg0_50)
                fr++;
            return fr;
        }
        }
    }

    bool GetTime(OmFieldRate fieldRate, uint *hours, uint *minutes, 
                 uint *seconds, uint *frames, uint* fieldNum = 0, 
                 bool *dropFrm = 0) const 
    {
        if (IsInvalid()) 
            return false;
        if (hours != 0)
            *hours = Hours();
        if (minutes != 0)
            *minutes = Minutes();
        if (seconds != 0)
            *seconds = Seconds();
        if (frames != 0)
            *frames = Frames();
        if (fieldNum != 0) 
            *fieldNum = (Field(fieldRate) == 0)? 1: 2;
        if (dropFrm != 0)
            *dropFrm = (fieldRate == omFldRate59_94Hz && dropFrame_59_94 == 1);
        return true;
    }

    bool GetTime(uint *hours, uint *minutes, uint *seconds, uint *frames,
                 bool *df = 0, bool *cf = 0) const {
        if (IsInvalid()) 
            return false;
        if (hours)
            *hours = Hours();
        if (minutes)
            *minutes = Minutes();
        if (seconds)
            *seconds = Seconds();
        if (frames)
            *frames = Frames();
        if (df)
            *df = (dropFrame_59_94 == 1);
        if (cf)
            *cf = (colorFrame == 1);
        return true;
    }

    bool GetFlagFields(OmFieldRate rate, bool &bgflag0, bool &bgflag1, bool &bgflag2) const {
        if (rate == omFldRateInvalid)
            return false;
        uint hz  =  rate == omFldRate50Hz? 50: 60;
        return GetFlagFields(hz, bgflag0, bgflag1, bgflag2);
    }

    bool GetFlagFields(uint roundedHz, bool &bgflag0, bool &bgflag1, bool &bgflag2) const {
        if (IsInvalid())
            return false;
        bool is625 = (roundedHz == 25 || roundedHz == 50);    
        if(is625) {
            bgflag0=pcFm_59_94_bg0_50;
            bgflag1=bg1;
            bgflag2=bg0_59_94_bg2_50;
        }
        else {
            bgflag0=bg0_59_94_bg2_50;
            bgflag1=bg1;
            bgflag2=bg2_59_94_pcFm_50;
        }
        return true;
    }

    void SetFlagFields(uint roundedHz, bool bgflag0, bool bgflag1, bool bgflag2) {
        // No need to set the fieldMark, which is calculated by OmTcData when time is set or frames are added
        bool is625 = (roundedHz == 25 || roundedHz == 50);    
        if(is625) {
            pcFm_59_94_bg0_50=bgflag0;
            bg1=bgflag1;
            bg0_59_94_bg2_50=bgflag2;
        }
        else {
            bg0_59_94_bg2_50=bgflag0;
            bg1=bgflag1;
            bg2_59_94_pcFm_50=bgflag2;
        }
    }

    // Translate SMPTE 12M-2 ANC timecode to OmTcData and set DBB1
    void SetAncTimecode(const unsigned char* tc, uint* dbb1) {

        this->Init();

        framesUnits       = (tc[0]  & 0xf0) >> 4;
        binaryGroup1      = (tc[1]  & 0xf0) >> 4;
        framesTens        = (tc[2]  & 0x30) >> 4;
        dropFrame_59_94   = (tc[2]  & 0x40) >> 6;
        colorFrame        = (tc[2]  & 0x80) >> 7;
        binaryGroup2      = (tc[3]  & 0xf0) >> 4;
        secondsUnits      = (tc[4]  & 0xf0) >> 4;
        binaryGroup3      = (tc[5]  & 0xf0) >> 4;
        secondsTens       = (tc[6]  & 0x70) >> 4;
        pcFm_59_94_bg0_50 = (tc[6]  & 0x80) >> 7;
        binaryGroup4      = (tc[7]  & 0xf0) >> 4;
        minutesUnits      = (tc[8]  & 0xf0) >> 4;
        binaryGroup5      = (tc[7]  & 0xf0) >> 4;
        minutesTens       = (tc[10] & 0x70) >> 4;
        bg0_59_94_bg2_50  = (tc[10] & 0x80) >> 7;
        binaryGroup6      = (tc[11] & 0xf0) >> 4;
        hoursUnits        = (tc[12] & 0xf0) >> 4;
        binaryGroup7      = (tc[13] & 0xf0) >> 4;
        hoursTens         = (tc[14] & 0x30) >> 4;
        bg1               = (tc[14] & 0x40) >> 6;
        bg2_59_94_pcFm_50 = (tc[14] & 0x80) >> 7;
        binaryGroup8      = (tc[15] & 0xf0) >> 4;

        // Shift off the DDB1 that has LTC, VITC1&2
        for (uint udw = 0; udw < 8; udw++) { 
            *dbb1 |= (((tc[udw] & 0x8) >> 3) << udw);
        }
    }

    // Set time using S12M frame counting (XXX what about field bit?)
    void SetTime(uint hours, uint minutes, uint seconds, uint frames,
                 uint df = 0, uint cf = 0) {
        framesUnits = frames % 10;
        framesTens = frames / 10;
        secondsUnits = seconds % 10;
        secondsTens = seconds / 10;
        minutesUnits = minutes % 10;
        minutesTens = minutes / 10;
        hoursUnits = hours % 10;
        hoursTens = hours / 10;
        dropFrame_59_94 = df ? 1 : 0;
        colorFrame = cf ? 1 : 0;
    }

    // Set time using straight (non-S12M) frame counting
    void SetTime(uint hours, uint minutes, uint seconds, uint frameIndex,
                 uint roundedHz, uint df, uint cf) {
        if (roundedHz == 60 /*59.94*/) {
            pcFm_59_94_bg0_50 = frameIndex & 1;
            frameIndex /= 2;
        } else if (roundedHz == 50) {
            bg2_59_94_pcFm_50 = frameIndex & 1;
            frameIndex /= 2;
        }
        SetTime(hours, minutes, seconds, frameIndex, df, cf);
    }

    void SetTime(int totalFrames, bool is625, bool df) {
        uint tmp;
        uint hours;
        uint minutes;
        uint seconds;
        uint frames;

        if (is625) {
            totalFrames %= (25 * 60 * 60 * 24);
            if (totalFrames < 0)
                totalFrames += (25 * 60 * 60 * 24);
            tmp = totalFrames / (25 * 60 * 60);
            hours = tmp;
            totalFrames -= tmp * (25 * 60 * 60);
            tmp = totalFrames / (25 * 60);
            minutes = tmp;
            totalFrames -= tmp * (25 * 60);
            tmp =  totalFrames / 25;
            seconds = tmp;
            totalFrames -= tmp * 25;
            frames = totalFrames % 25;
        }
        else {
            if (df) {
                totalFrames %= (((30 * 60 * 60) - (54 * 2)) * 24);
                if (totalFrames < 0)
                    totalFrames += (((30 * 60 * 60) - (54 * 2)) * 24);

                uint tmp = totalFrames % 17982;
                totalFrames += (totalFrames / 17982) * 18;
                if (tmp >= 1800)
                    totalFrames += ((tmp - 1800) / 1798) * 2 + 2;
            }
            else {
                totalFrames %= (30 * 60 * 60 * 24);
                if (totalFrames < 0)
                    totalFrames += (30 * 60 * 60 * 24);
            }

            tmp = totalFrames / (30 * 60 * 60);
            hours = tmp;
            totalFrames -= tmp * (30 * 60 * 60);
            tmp = totalFrames / (30 * 60);
            minutes = tmp;
            totalFrames -= tmp * (30 * 60);
            tmp =  totalFrames / 30;
            seconds = tmp;
            totalFrames -= tmp * 30;
            frames = totalFrames % 30;
        }
        SetTime(hours, minutes, seconds, frames, df);
    }

    void SetTime(int totalFrames, OmFrameRate frameRate, bool df) {
        switch (frameRate) {
        default:
        case omFrmRate25Hz:
            SetTime(totalFrames, true, df);
            bg2_59_94_pcFm_50 = 0;
            break;
        case omFrmRate29_97Hz:
            SetTime(totalFrames, false, df);
            pcFm_59_94_bg0_50 = 0;
            break;
        case omFrmRate50Hz:
            SetTime(totalFrames/2, true, df);
            bg2_59_94_pcFm_50 = (totalFrames & 1) ? 1 : 0;
            break;
        case omFrmRate59_94Hz:
            SetTime(totalFrames/2, false, df);
            pcFm_59_94_bg0_50 = (totalFrames & 1) ? 1 : 0;
            break;
        }
    }

    #ifndef SWIG
    // in drop frame mode can only cross a minute boundary once
    bool AddFrames(OmFieldRate fieldRate, uint frames) {
        bool checkDrop = false;
        uint maxFrames;
        switch (fieldRate) {
        case omFldRate59_94Hz:
            if (dropFrame_59_94) {
                if (frames >= 1798)
                    return false;
                checkDrop = true;
            }
            maxFrames = 30;
            break;
        case omFldRate50Hz:
            maxFrames = 25;
            break;
        case omFldRate24Hz:
            maxFrames = 24;
            break;
        default:
            maxFrames = 1;
            break;
        }

        uint tmpFrames = frames + framesUnits + framesTens * 10;
        if (tmpFrames >= maxFrames) {
            uint tmpSeconds = tmpFrames / maxFrames + secondsUnits +
                secondsTens * 10;
            tmpFrames %= maxFrames;
            if (tmpSeconds >= 60) {
                uint tmpMinutes = tmpSeconds / 60 + minutesUnits +
                    minutesTens * 10;
                tmpSeconds %= 60;
                if (tmpMinutes >= 60) {
                    uint tmpHours = tmpMinutes / 60 + hoursUnits +
                        hoursTens * 10;
                    tmpMinutes %= 60;
                    // limit hours to 24
                    tmpHours %= 24;
                    hoursUnits = tmpHours % 10;
                    hoursTens = tmpHours / 10;
                }
                minutesUnits = tmpMinutes % 10;
                minutesTens = tmpMinutes / 10;
                // if drop frame and increment past the 2 dropped frames
                // every non multiple of 10 minuntes, then add two frames
                if (checkDrop && (minutesUnits != 0)) {
                    // add two frames
                    tmpFrames += 2;
                    // check for frames roll over
                    if (tmpFrames >= maxFrames) {
                        tmpFrames -= maxFrames;
                        tmpSeconds++;
                    }
                }
            }
            secondsUnits = tmpSeconds % 10;
            secondsTens = tmpSeconds / 10;
        }
        framesUnits = tmpFrames % 10;
        framesTens = tmpFrames / 10;

        return true;
    }
    #endif

    bool AddFrames(OmFrameRate frameRate, uint frames) {
        OmFieldRate fldRate;
        switch (frameRate) {
        case omFrmRate59_94Hz:
            if ((frames & 1) == 0)
                frames /= 2;
            else if (pcFm_59_94_bg0_50 == 0) {
                 pcFm_59_94_bg0_50 = 1;
                frames /= 2;
            }
            else {
                 pcFm_59_94_bg0_50 = 0;
                frames = (frames / 2) + 1;
            }
            fldRate = omFldRate59_94Hz;
            break;
        case omFrmRate50Hz:
            if ((frames & 1) == 0)
                frames /= 2;
            else if (bg2_59_94_pcFm_50 == 0) {
                bg2_59_94_pcFm_50 = 1;
                frames /= 2;
            }
            else {
                bg2_59_94_pcFm_50 = 0;
                frames = (frames / 2) + 1;
            }
            fldRate = omFldRate50Hz;
            break;
        case omFrmRate29_97Hz:
            fldRate = omFldRate59_94Hz;
            break;
        case omFrmRate25Hz:
            fldRate = omFldRate50Hz;
            break;
        case omFrmRate24Hz:
            fldRate = omFldRate24Hz;
            break;
        default:
            return false;
        }
        return AddFrames(fldRate, frames);
    }

    uint Timecode() const {
        return ((*((unsigned char *)this + 0) & 0xf) << 0) |
            ((*((unsigned char *)this + 1) & 0xf) << 4) |
            ((*((unsigned char *)this + 2) & 0xf) << 8) |
            ((*((unsigned char *)this + 3) & 0xf) << 12) |
            ((*((unsigned char *)this + 4) & 0xf) << 16) |
            ((*((unsigned char *)this + 5) & 0xf) << 20) |
            ((*((unsigned char *)this + 6) & 0xf) << 24) |
            ((*((unsigned char *)this + 7) & 0xf) << 28);
    }

    enum {UserbitsMask = 0xf0f0f0f0};

    void InsertTimecode(uint tc) {
        // strip out existing tc
        *(uint *)this = *(uint *)this & UserbitsMask;
        *((uint *)this + 1) = *((uint *)this + 1) & UserbitsMask;

        // insert new tc
        *((unsigned char *)this + 0) |= tc & 0xf;
        *((unsigned char *)this + 1) |= (tc >> 4) & 0xf;
        *((unsigned char *)this + 2) |= (tc >> 8) & 0xf;
        *((unsigned char *)this + 3) |= (tc >> 12) & 0xf;
        *((unsigned char *)this + 4) |= (tc >> 16) & 0xf;
        *((unsigned char *)this + 5) |= (tc >> 20) & 0xf;
        *((unsigned char *)this + 6) |= (tc >> 24) & 0xf;
        *((unsigned char *)this + 7) |= (tc >> 28) & 0xf;
    }

    void InsertUserbits(OmTcData &other) {
        *(uint *)this = ((*(uint *)this & ~UserbitsMask) |
                         (*(uint *)&other & UserbitsMask));
        *((uint *)this + 1) = ((*((uint *)this + 1) & ~UserbitsMask) |
                               (*((uint *)&other + 1) & UserbitsMask));
    }
    void InsertUserbits(uint ub) {
        binaryGroup1 = ub & 0xf;
        binaryGroup2 = (ub >> 4) & 0xf;
        binaryGroup3 = (ub >> 8) & 0xf;
        binaryGroup4 = (ub >> 12) & 0xf;
        binaryGroup5 = (ub >> 16) & 0xf;
        binaryGroup6 = (ub >> 20) & 0xf;
        binaryGroup7 = (ub >> 24) & 0xf;
        binaryGroup8 = (ub >> 28) & 0xf;
    }
    void Zero() {
        *(uint *)this = 0;
        *((uint *)this + 1) = 0;
    }
    void ZeroUserbits() {
        *(uint *)this &= ~UserbitsMask;
        *((uint *)this + 1) &= ~UserbitsMask;
    }

    uint LowWord() const { return *(uint *)this; }
    uint HighWord() const { return *((uint *)this + 1); }

    void SetLowWord(uint x) { *(uint *)this = x; }
    void SetHighWord(uint x) { *((uint *)this + 1) = x; }

    uint Userbits() const {
        return (binaryGroup1 | (binaryGroup2 << 4) |
                (binaryGroup3 << 8) | (binaryGroup4 << 12) |
                (binaryGroup5 << 16) | (binaryGroup6 << 20) |
                (binaryGroup7 << 24) | (binaryGroup8 << 28));
    }

    void SetFieldId(OmFieldRate fieldRate, OmFieldId fieldId) {
        if (fieldRate == omFldRate59_94Hz)
            pcFm_59_94_bg0_50 = (fieldId == omField2);
        else if (fieldRate == omFldRate50Hz)
            bg2_59_94_pcFm_50 = (fieldId == omField2);
        return;
    }

    void ClearLtcPhaseCorrectionBit(OmFieldRate fieldRate) {
        if (fieldRate == omFldRate59_94Hz)
            pcFm_59_94_bg0_50 = 0;
        else if (fieldRate == omFldRate50Hz)
            bg2_59_94_pcFm_50 = 0;
        return;
    }

    std::string toString(OmFieldRate fieldRate) const
    {
        enum { stackBufSize = 128};
        char stackBuf[ stackBufSize ];
        char sep = ':';
        if (fieldRate == omFldRate50Hz)
            sep = (bg2_59_94_pcFm_50 ? ':' : '.');
        else if (fieldRate == omFldRate59_94Hz)
            sep = (pcFm_59_94_bg0_50 ? (Field(fieldRate) ? ';' : ':')
                                     : (Field(fieldRate) ? ',' : '.'));
        else
            sep = ':';
        snprintf(stackBuf, stackBufSize-1, "%02d:%02d:%02d%c%02d",
                Hours(), Minutes(), Seconds(), sep, Frames());
        stackBuf[stackBufSize-1] = 0;
        return std::string(stackBuf);
    }

    std::string toString(OmFrameRate frameRate) const
    {
        enum { stackBufSize = 128};
        char stackBuf[ stackBufSize ];
        char sep = ':';
        if (frameRate == omFrmRate25Hz) {
            sep = (bg2_59_94_pcFm_50 ? ':' : '.');
        } else if (frameRate == omFrmRate29_97Hz) {
            bool field = Field(omFldRate59_94Hz);
            sep = (dropFrame_59_94 ? (field ? ';' : ':')
                                   : (field ? ',' : '.'));
        } else {
            sep = ':';
        }
        snprintf(stackBuf, stackBufSize-1, "%02d:%02d:%02d%c%02d",
                Hours(), Minutes(), Seconds(), sep, GetFrameIndex(frameRate));
        stackBuf[stackBufSize-1] = 0;
        return std::string(stackBuf);
    }

#endif // __cplusplus

#if defined(__GNUC__)
} __attribute__((aligned(4)));
#else
};
#endif

// Correctly constructed OmTcData.
#ifdef __cplusplus

struct OmTimecode : public OmTcData
{
    OmTimecode()
    {
        framesUnits       = 15; // mark invalid
        binaryGroup1      = 0;
        framesTens        = 0;
        dropFrame_59_94   = 0;
        colorFrame        = 0;
        binaryGroup2      = 0;
        secondsUnits      = 0;
        binaryGroup3      = 0;
        secondsTens       = 0;
        pcFm_59_94_bg0_50 = 0;
        binaryGroup4      = 0;
        minutesUnits      = 0;
        binaryGroup5      = 0;
        minutesTens       = 0;
        bg0_59_94_bg2_50  = 0;
        binaryGroup6      = 0;
        hoursUnits        = 0;
        binaryGroup7      = 0;
        hoursTens         = 0;
        bg1               = 0;
        bg2_59_94_pcFm_50 = 0;
        binaryGroup8      = 0;
    }   

    OmTimecode(const OmTcData& rval)
    {
        framesUnits       = rval.framesUnits;
        binaryGroup1      = rval.binaryGroup1;
        framesTens        = rval.framesTens;
        dropFrame_59_94   = rval.dropFrame_59_94;
        colorFrame        = rval.colorFrame;
        binaryGroup2      = rval.binaryGroup2;
        secondsUnits      = rval.secondsUnits;
        binaryGroup3      = rval.binaryGroup3;
        secondsTens       = rval.secondsTens;
        pcFm_59_94_bg0_50 = rval.pcFm_59_94_bg0_50;
        binaryGroup4      = rval.binaryGroup4;
        minutesUnits      = rval.minutesUnits;
        binaryGroup5      = rval.binaryGroup5;
        minutesTens       = rval.minutesTens;
        bg0_59_94_bg2_50  = rval.bg0_59_94_bg2_50;
        binaryGroup6      = rval.binaryGroup6;
        hoursUnits        = rval.hoursUnits;
        binaryGroup7      = rval.binaryGroup7;
        hoursTens         = rval.hoursTens;
        bg1               = rval.bg1;
        bg2_59_94_pcFm_50 = rval.bg2_59_94_pcFm_50;
        binaryGroup8      = rval.binaryGroup8;
    }
};

#endif // __cplusplus


#endif
