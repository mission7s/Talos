

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


 /* File created by MIDL compiler version 6.00.0366 */
/* at Tue Dec 14 16:18:57 2010
 */
/* Compiler settings for .\TAPI.idl:
    Oicf, W1, Zp8, env=Win32 (32b run)
    protocol : dce , ms_ext, c_ext
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
//@@MIDL_FILE_HEADING(  )

#pragma warning( disable: 4049 )  /* more than 64k source lines */


/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 440
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif // __RPCNDR_H_VERSION__

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __TAPI_h__
#define __TAPI_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

/* Forward Declarations */ 

#ifndef __ITAPEventHandler_FWD_DEFINED__
#define __ITAPEventHandler_FWD_DEFINED__
typedef interface ITAPEventHandler ITAPEventHandler;
#endif 	/* __ITAPEventHandler_FWD_DEFINED__ */


#ifndef __ITAP_FWD_DEFINED__
#define __ITAP_FWD_DEFINED__
typedef interface ITAP ITAP;
#endif 	/* __ITAP_FWD_DEFINED__ */


#ifndef __ITAPParser_FWD_DEFINED__
#define __ITAPParser_FWD_DEFINED__
typedef interface ITAPParser ITAPParser;
#endif 	/* __ITAPParser_FWD_DEFINED__ */


#ifndef __TAPEventHandler_FWD_DEFINED__
#define __TAPEventHandler_FWD_DEFINED__

#ifdef __cplusplus
typedef class TAPEventHandler TAPEventHandler;
#else
typedef struct TAPEventHandler TAPEventHandler;
#endif /* __cplusplus */

#endif 	/* __TAPEventHandler_FWD_DEFINED__ */


#ifndef __TAP_FWD_DEFINED__
#define __TAP_FWD_DEFINED__

#ifdef __cplusplus
typedef class TAP TAP;
#else
typedef struct TAP TAP;
#endif /* __cplusplus */

#endif 	/* __TAP_FWD_DEFINED__ */


#ifndef __TAPParser_FWD_DEFINED__
#define __TAPParser_FWD_DEFINED__

#ifdef __cplusplus
typedef class TAPParser TAPParser;
#else
typedef struct TAPParser TAPParser;
#endif /* __cplusplus */

#endif 	/* __TAPParser_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

#ifdef __cplusplus
extern "C"{
#endif 

void * __RPC_USER MIDL_user_allocate(size_t);
void __RPC_USER MIDL_user_free( void * ); 

/* interface __MIDL_itf_TAPI_0000 */
/* [local] */ 

#pragma once
typedef 
enum eTAPCommand
    {	TAP_COMMAND_Play	= 0,
	TAP_COMMAND_Pause	= TAP_COMMAND_Play + 1,
	TAP_COMMAND_Out	= TAP_COMMAND_Pause + 1,
	TAP_COMMAND_Stop	= TAP_COMMAND_Out + 1,
	TAP_COMMAND_Prepare	= TAP_COMMAND_Stop + 1,
	TAP_COMMAND_StopPreview	= TAP_COMMAND_Prepare + 1,
	TAP_COMMAND_Section_Prepare	= TAP_COMMAND_StopPreview + 1,
	TAP_COMMAND_Section_In	= TAP_COMMAND_Section_Prepare + 1,
	TAP_COMMAND_Section_Out	= TAP_COMMAND_Section_In + 1,
	TAP_COMMAND_SECTION_Pause	= TAP_COMMAND_Section_Out + 1,
	TAP_COMMAND_Stop_All_Sections	= TAP_COMMAND_SECTION_Pause + 1,
	TAP_COMMAND_TopLayer_In	= TAP_COMMAND_Stop_All_Sections + 1,
	TAP_COMMAND_TopLayer_Out	= TAP_COMMAND_TopLayer_In + 1,
	TAP_COMMAND_Default_Out	= TAP_COMMAND_TopLayer_Out + 1,
	TAP_COMMAND_Load_Project	= TAP_COMMAND_Default_Out + 1,
	TAP_COMMAND_Save_Project	= TAP_COMMAND_Load_Project + 1,
	TAP_COMMAND_UnloadAll	= TAP_COMMAND_Save_Project + 1,
	TAP_COMMAND_DeleteAll	= TAP_COMMAND_UnloadAll + 1,
	TAP_COMMAND_Load	= TAP_COMMAND_DeleteAll + 1,
	TAP_COMMAND_LoadEx	= TAP_COMMAND_Load + 1,
	TAP_COMMAND_LoadEx_2	= TAP_COMMAND_LoadEx + 1,
	TAP_COMMAND_Insert	= TAP_COMMAND_LoadEx_2 + 1,
	TAP_COMMAND_Unload	= TAP_COMMAND_Insert + 1,
	TAP_COMMAND_Save_Page	= TAP_COMMAND_Unload + 1,
	TAP_COMMAND_CreateFile	= TAP_COMMAND_Save_Page + 1,
	TAP_COMMAND_CreateImage	= TAP_COMMAND_CreateFile + 1,
	TAP_COMMAND_PageDefault	= TAP_COMMAND_CreateImage + 1,
	TAP_COMMAND_BackGrnd	= TAP_COMMAND_PageDefault + 1,
	TAP_COMMAND_ObjValue	= TAP_COMMAND_BackGrnd + 1,
	TAP_COMMAND_ObjValue2	= TAP_COMMAND_ObjValue + 1,
	TAP_COMMAND_SetStyleText	= TAP_COMMAND_ObjValue2 + 1,
	TAP_COMMAND_AddStyleText	= TAP_COMMAND_SetStyleText + 1,
	TAP_COMMAND_SetStyleText2	= TAP_COMMAND_AddStyleText + 1,
	TAP_COMMAND_AddStyleText2	= TAP_COMMAND_SetStyleText2 + 1,
	TAP_COMMAND_SetImageObject	= TAP_COMMAND_AddStyleText2 + 1,
	TAP_COMMAND_AddImageObject	= TAP_COMMAND_SetImageObject + 1,
	TAP_COMMAND_AddScrollObject	= TAP_COMMAND_AddImageObject + 1,
	TAP_COMMAND_ObjAttr	= TAP_COMMAND_AddScrollObject + 1,
	TAP_COMMAND_PageEffect	= TAP_COMMAND_ObjAttr + 1,
	TAP_COMMAND_PageEffectEx	= TAP_COMMAND_PageEffect + 1,
	TAP_COMMAND_PageTime	= TAP_COMMAND_PageEffectEx + 1,
	TAP_COMMAND_Query	= TAP_COMMAND_PageTime + 1,
	TAP_COMMAND_Hello	= TAP_COMMAND_Query + 1,
	TAP_COMMAND_HeartBeat	= TAP_COMMAND_Hello + 1,
	TAP_COMMAND_Bye	= TAP_COMMAND_HeartBeat + 1,
	TAP_COMMAND_Hello_Connected	= TAP_COMMAND_Bye + 1,
	TAP_COMMAND_Hello_Check_Ok	= TAP_COMMAND_Hello_Connected + 1,
	TAP_COMMAND_AudioEnable	= TAP_COMMAND_Hello_Check_Ok + 1,
	TAP_COMMAND_AudioFile	= TAP_COMMAND_AudioEnable + 1,
	TAP_COMMAND_ScrollSpeed	= TAP_COMMAND_AudioFile + 1,
	TAP_COMMAND_AirScrollSpeed	= TAP_COMMAND_ScrollSpeed + 1,
	TAP_COMMAND_AirSectionScrollSpeed	= TAP_COMMAND_AirScrollSpeed + 1,
	TAP_COMMAND_Pause_Add	= TAP_COMMAND_AirSectionScrollSpeed + 1,
	TAP_COMMAND_Pause_Delete	= TAP_COMMAND_Pause_Add + 1,
	TAP_COMMAND_ObjPath	= TAP_COMMAND_Pause_Delete + 1,
	TAP_COMMAND_ObjLine	= TAP_COMMAND_ObjPath + 1,
	TAP_COMMAND_Page	= TAP_COMMAND_ObjLine + 1,
	TAP_COMMAND_PageAlias	= TAP_COMMAND_Page + 1,
	TAP_COMMAND_ObjValueEx	= TAP_COMMAND_PageAlias + 1,
	TAP_COMMAND_PageMode	= TAP_COMMAND_ObjValueEx + 1,
	TAP_COMMAND_ScrollMargin	= TAP_COMMAND_PageMode + 1,
	TAP_COMMAND_Section_Play	= TAP_COMMAND_ScrollMargin + 1,
	TAP_COMMAND_TextAll	= TAP_COMMAND_Section_Play + 1,
	TAP_COMMAND_AliasAll	= TAP_COMMAND_TextAll + 1,
	TAP_COMMAND_TextSize	= TAP_COMMAND_AliasAll + 1,
	TAP_COMMAND_Error	= TAP_COMMAND_TextSize + 1,
	TAP_COMMAND_Continue	= TAP_COMMAND_Error + 1,
	TAP_COMMAND_End	= TAP_COMMAND_Continue + 1,
	TAP_COMMAND_Layer_Prepare	= TAP_COMMAND_End + 1,
	TAP_COMMAND_Layer_Play	= TAP_COMMAND_Layer_Prepare + 1,
	TAP_COMMAND_Layer_AllPlay	= TAP_COMMAND_Layer_Play + 1,
	TAP_COMMAND_Layer_PauseResume	= TAP_COMMAND_Layer_AllPlay + 1,
	TAP_COMMAND_Layer_Count	= TAP_COMMAND_Layer_PauseResume + 1,
	TAP_COMMAND_Layer_AllCutOut	= TAP_COMMAND_Layer_Count + 1,
	TAP_COMMAND_Layer_Stop	= TAP_COMMAND_Layer_AllCutOut + 1,
	TAP_COMMAND_Layer_AllStop	= TAP_COMMAND_Layer_Stop + 1,
	TAP_COMMAND_Layer_ScrollSpeed	= TAP_COMMAND_Layer_AllStop + 1,
	TAP_COMMAND_Change_Sequence_Mode	= TAP_COMMAND_Layer_ScrollSpeed + 1,
	TAP_COMMAND_NoMatch	= TAP_COMMAND_Change_Sequence_Mode + 1
    } 	eTAPCommand;

typedef 
enum eTAPAttr
    {	TAP_ATTR_Value	= TAP_COMMAND_NoMatch + 1,
	TAP_ATTR_Type	= TAP_ATTR_Value + 1,
	TAP_ATTR_Color	= TAP_ATTR_Type + 1,
	TAP_ATTR_Color_Start	= TAP_ATTR_Color + 1,
	TAP_ATTR_Width	= TAP_ATTR_Color_Start + 1,
	TAP_ATTR_Height	= TAP_ATTR_Width + 1,
	TAP_ATTR_Depth	= TAP_ATTR_Height + 1,
	TAP_ATTR_Position	= TAP_ATTR_Depth + 1,
	TAP_ATTR_Pivot	= TAP_ATTR_Position + 1,
	TAP_ATTR_BarWidth	= TAP_ATTR_Pivot + 1,
	TAP_ATTR_Rotation	= TAP_ATTR_BarWidth + 1,
	TAP_ATTR_Scale	= TAP_ATTR_Rotation + 1,
	TAP_ATTR_Scale_Start	= TAP_ATTR_Scale + 1,
	TAP_ATTR_Slant	= TAP_ATTR_Scale_Start + 1,
	TAP_ATTR_Text_Format	= TAP_ATTR_Slant + 1,
	TAP_ATTR_TextType	= TAP_ATTR_Text_Format + 1,
	TAP_ATTR_TextType_Text	= TAP_ATTR_TextType + 1,
	TAP_ATTR_TextType_Clock	= TAP_ATTR_TextType_Text + 1,
	TAP_ATTR_TextType_Timer	= TAP_ATTR_TextType_Clock + 1,
	TAP_ATTR_TextType_Counter	= TAP_ATTR_TextType_Timer + 1,
	TAP_ATTR_TimerBegin	= TAP_ATTR_TextType_Counter + 1,
	TAP_ATTR_TimerEnd	= TAP_ATTR_TimerBegin + 1,
	TAP_ATTR_TimerDuration	= TAP_ATTR_TimerEnd + 1,
	TAP_ATTR_TimerUpdate	= TAP_ATTR_TimerDuration + 1,
	TAP_ATTR_Seq_Start	= TAP_ATTR_TimerUpdate + 1,
	TAP_ATTR_Seq_Finish	= TAP_ATTR_Seq_Start + 1,
	TAP_ATTR_Seq_Loop	= TAP_ATTR_Seq_Finish + 1,
	TAP_ATTR_Circle_Angle	= TAP_ATTR_Seq_Loop + 1,
	TAP_ATTR_Effect	= TAP_ATTR_Circle_Angle + 1,
	TAP_ATTR_NoMatch	= TAP_ATTR_Effect + 1
    } 	eTAPAttr;

typedef 
enum eTAPBg
    {	TAP_BG_FileName	= TAP_ATTR_NoMatch + 1,
	TAP_BG_Begin	= TAP_BG_FileName + 1,
	TAP_BG_End	= TAP_BG_Begin + 1,
	TAP_BG_Loop	= TAP_BG_End + 1,
	TAP_BG_Start	= TAP_BG_Loop + 1,
	TAP_BG_Finish	= TAP_BG_Start + 1,
	TAP_BG_NoMatch	= TAP_BG_Finish + 1
    } 	eTAPBg;

typedef 
enum eTAPEffect
    {	TAP_EFFECT_Cut	= TAP_BG_NoMatch + 1,
	TAP_EFFECT_Wipe	= TAP_EFFECT_Cut + 1,
	TAP_EFFECT_Push	= TAP_EFFECT_Wipe + 1,
	TAP_EFFECT_Dve	= TAP_EFFECT_Push + 1,
	TAP_EFFECT_Curl	= TAP_EFFECT_Dve + 1,
	TAP_EFFECT_Particle	= TAP_EFFECT_Curl + 1,
	TAP_EFFECT_Ripple	= TAP_EFFECT_Particle + 1,
	TAP_EFFECT_Organic	= TAP_EFFECT_Ripple + 1,
	TAP_EFFECT_Distortion	= TAP_EFFECT_Organic + 1,
	TAP_EFFECT_Blink	= TAP_EFFECT_Distortion + 1,
	TAP_EFFECT_Mask	= TAP_EFFECT_Blink + 1,
	TAP_EFFECT_Frame	= TAP_EFFECT_Mask + 1,
	TAP_EFFECT_NoMatch	= TAP_EFFECT_Frame + 1
    } 	eTAPEffect;

typedef 
enum eTAPEffectWipe
    {	TAP_EFFECT_Wipe_Shape	= TAP_EFFECT_NoMatch + 1,
	TAP_EFFECT_Wipe_Shape_Divide	= TAP_EFFECT_Wipe_Shape + 1,
	TAP_EFFECT_Wipe_Shape_Rectangle	= TAP_EFFECT_Wipe_Shape_Divide + 1,
	TAP_EFFECT_Wipe_Shape_Circle	= TAP_EFFECT_Wipe_Shape_Rectangle + 1,
	TAP_EFFECT_Wipe_Shape_Fan	= TAP_EFFECT_Wipe_Shape_Circle + 1,
	TAP_EFFECT_Wipe_Position	= TAP_EFFECT_Wipe_Shape_Fan + 1,
	TAP_EFFECT_Wipe_Position_Up	= TAP_EFFECT_Wipe_Position + 1,
	TAP_EFFECT_Wipe_Position_Down	= TAP_EFFECT_Wipe_Position_Up + 1,
	TAP_EFFECT_Wipe_Position_Left	= TAP_EFFECT_Wipe_Position_Down + 1,
	TAP_EFFECT_Wipe_Position_Right	= TAP_EFFECT_Wipe_Position_Left + 1,
	TAP_EFFECT_Wipe_Position_UpLeft	= TAP_EFFECT_Wipe_Position_Right + 1,
	TAP_EFFECT_Wipe_Position_UpRight	= TAP_EFFECT_Wipe_Position_UpLeft + 1,
	TAP_EFFECT_Wipe_Position_DownLeft	= TAP_EFFECT_Wipe_Position_UpRight + 1,
	TAP_EFFECT_Wipe_Position_DownRight	= TAP_EFFECT_Wipe_Position_DownLeft + 1,
	TAP_EFFECT_Wipe_Position_Center	= TAP_EFFECT_Wipe_Position_DownRight + 1,
	TAP_EFFECT_Wipe_NoMatch	= TAP_EFFECT_Wipe_Position_Center + 1
    } 	eTAPEffectWipe;

typedef 
enum eTAPEffectPush
    {	TAP_EFFECT_Push_Direction	= TAP_EFFECT_Wipe_NoMatch + 1,
	TAP_EFFECT_Push_Direction_Up	= TAP_EFFECT_Push_Direction + 1,
	TAP_EFFECT_Push_Direction_Down	= TAP_EFFECT_Push_Direction_Up + 1,
	TAP_EFFECT_Push_Direction_Left	= TAP_EFFECT_Push_Direction_Down + 1,
	TAP_EFFECT_Push_Direction_Right	= TAP_EFFECT_Push_Direction_Left + 1,
	TAP_EFFECT_Push_Direction_UpLeft	= TAP_EFFECT_Push_Direction_Right + 1,
	TAP_EFFECT_Push_Direction_UpRight	= TAP_EFFECT_Push_Direction_UpLeft + 1,
	TAP_EFFECT_Push_Direction_DownLeft	= TAP_EFFECT_Push_Direction_UpRight + 1,
	TAP_EFFECT_Push_Direction_DownRight	= TAP_EFFECT_Push_Direction_DownLeft + 1,
	TAP_EFFECT_Push_NoMatch	= TAP_EFFECT_Push_Direction_DownRight + 1
    } 	eTAPEffectPush;

typedef 
enum eTAPEffectCurl
    {	TAP_EFFECT_Curl_Radius	= TAP_EFFECT_Push_NoMatch + 1,
	TAP_EFFECT_Curl_Angle	= TAP_EFFECT_Curl_Radius + 1,
	TAP_EFFECT_Curl_NoMatch	= TAP_EFFECT_Curl_Angle + 1
    } 	eTAPEffectCurl;

typedef 
enum eTAPEffectDve
    {	TAP_EFFECT_Dve_Position	= TAP_EFFECT_Curl_NoMatch + 1,
	TAP_EFFECT_Dve_Center	= TAP_EFFECT_Dve_Position + 1,
	TAP_EFFECT_Dve_Scale	= TAP_EFFECT_Dve_Center + 1,
	TAP_EFFECT_Dve_Rotation	= TAP_EFFECT_Dve_Scale + 1,
	TAP_EFFECT_Dve_NoMatch	= TAP_EFFECT_Dve_Rotation + 1
    } 	eTAPEffectDve;

typedef 
enum eTAPEffectParticle
    {	TAP_EFFECT_Particle_Shape	= TAP_EFFECT_Dve_NoMatch + 1,
	TAP_EFFECT_Particle_Shape_Tile	= TAP_EFFECT_Particle_Shape + 1,
	TAP_EFFECT_Particle_Shape_Random	= TAP_EFFECT_Particle_Shape_Tile + 1,
	TAP_EFFECT_Particle_Shape_Radial	= TAP_EFFECT_Particle_Shape_Random + 1,
	TAP_EFFECT_Particle_Order	= TAP_EFFECT_Particle_Shape_Radial + 1,
	TAP_EFFECT_Particle_Order_AtOnce	= TAP_EFFECT_Particle_Order + 1,
	TAP_EFFECT_Particle_Order_Random	= TAP_EFFECT_Particle_Order_AtOnce + 1,
	TAP_EFFECT_Particle_Order_Top	= TAP_EFFECT_Particle_Order_Random + 1,
	TAP_EFFECT_Particle_Order_Bottom	= TAP_EFFECT_Particle_Order_Top + 1,
	TAP_EFFECT_Particle_Order_Left	= TAP_EFFECT_Particle_Order_Bottom + 1,
	TAP_EFFECT_Particle_Order_Right	= TAP_EFFECT_Particle_Order_Left + 1,
	TAP_EFFECT_Particle_Order_TopLeft	= TAP_EFFECT_Particle_Order_Right + 1,
	TAP_EFFECT_Particle_Order_TopRight	= TAP_EFFECT_Particle_Order_TopLeft + 1,
	TAP_EFFECT_Particle_Order_BottomLeft	= TAP_EFFECT_Particle_Order_TopRight + 1,
	TAP_EFFECT_Particle_Order_BottomRight	= TAP_EFFECT_Particle_Order_BottomLeft + 1,
	TAP_EFFECT_Particle_Order_PointCenter	= TAP_EFFECT_Particle_Order_BottomRight + 1,
	TAP_EFFECT_Particle_Order_PointSide	= TAP_EFFECT_Particle_Order_PointCenter + 1,
	TAP_EFFECT_Particle_Order_SnakeTop	= TAP_EFFECT_Particle_Order_PointSide + 1,
	TAP_EFFECT_Particle_Order_SnakeBottom	= TAP_EFFECT_Particle_Order_SnakeTop + 1,
	TAP_EFFECT_Particle_Order_SnakeLeft	= TAP_EFFECT_Particle_Order_SnakeBottom + 1,
	TAP_EFFECT_Particle_Order_SnakeRight	= TAP_EFFECT_Particle_Order_SnakeLeft + 1,
	TAP_EFFECT_Particle_Order_SnakeCenter	= TAP_EFFECT_Particle_Order_SnakeRight + 1,
	TAP_EFFECT_Particle_Order_SnakeSide	= TAP_EFFECT_Particle_Order_SnakeCenter + 1,
	TAP_EFFECT_Particle_Motion	= TAP_EFFECT_Particle_Order_SnakeSide + 1,
	TAP_EFFECT_Particle_Motion_Scatter2D	= TAP_EFFECT_Particle_Motion + 1,
	TAP_EFFECT_Particle_Motion_Scatter3D	= TAP_EFFECT_Particle_Motion_Scatter2D + 1,
	TAP_EFFECT_Particle_Motion_Converge	= TAP_EFFECT_Particle_Motion_Scatter3D + 1,
	TAP_EFFECT_Particle_Motion_Directional	= TAP_EFFECT_Particle_Motion_Converge + 1,
	TAP_EFFECT_Particle_DIVIDEY	= TAP_EFFECT_Particle_Motion_Directional + 1,
	TAP_EFFECT_Particle_OrderX	= TAP_EFFECT_Particle_DIVIDEY + 1,
	TAP_EFFECT_Particle_OrderY	= TAP_EFFECT_Particle_OrderX + 1,
	TAP_EFFECT_Particle_ConvergeX	= TAP_EFFECT_Particle_OrderY + 1,
	TAP_EFFECT_Particle_ConvergeY	= TAP_EFFECT_Particle_ConvergeX + 1,
	TAP_EFFECT_Particle_Direction	= TAP_EFFECT_Particle_ConvergeY + 1,
	TAP_EFFECT_Particle_NoMatch	= TAP_EFFECT_Particle_Direction + 1
    } 	eTAPEffectParticle;

typedef 
enum eTAPEffectRipple
    {	TAP_EFFECT_Ripple_Shape	= TAP_EFFECT_Particle_NoMatch + 1,
	TAP_EFFECT_Ripple_Shape_Water	= TAP_EFFECT_Ripple_Shape + 1,
	TAP_EFFECT_Ripple_Shape_Flag	= TAP_EFFECT_Ripple_Shape_Water + 1,
	TAP_EFFECT_Ripple_Frequency	= TAP_EFFECT_Ripple_Shape_Flag + 1,
	TAP_EFFECT_Ripple_Amplitude	= TAP_EFFECT_Ripple_Frequency + 1,
	TAP_EFFECT_Ripple_OriginX	= TAP_EFFECT_Ripple_Amplitude + 1,
	TAP_EFFECT_Ripple_OriginY	= TAP_EFFECT_Ripple_OriginX + 1,
	TAP_EFFECT_Ripple_Slant	= TAP_EFFECT_Ripple_OriginY + 1,
	TAP_EFFECT_Ripple_NoMatch	= TAP_EFFECT_Ripple_Slant + 1
    } 	eTAPEffectRipple;

typedef 
enum eTAPEffectOrganic
    {	TAP_EFFECT_Organic_UseMatte	= TAP_EFFECT_Ripple_NoMatch + 1,
	TAP_EFFECT_Organic_FILE	= TAP_EFFECT_Organic_UseMatte + 1,
	TAP_EFFECT_Organic_NoMatch	= TAP_EFFECT_Organic_FILE + 1
    } 	eTAPEffectOrganic;

typedef 
enum eTAPEffectDistortion
    {	TAP_EFFECT_Distortion_Height	= TAP_EFFECT_Organic_NoMatch + 1,
	TAP_EFFECT_Distortion_File	= TAP_EFFECT_Distortion_Height + 1,
	TAP_EFFECT_Distortion_NoMatch	= TAP_EFFECT_Distortion_File + 1
    } 	eTAPEffectDistortion;

typedef 
enum eLayer
    {	LAYER_BASE	= 0,
	LAYER_TOP	= LAYER_BASE + 1,
	LAYER_SECTION_0	= LAYER_TOP + 1,
	LAYER_SECTION_1	= LAYER_SECTION_0 + 1,
	LAYER_SECTION_2	= LAYER_SECTION_1 + 1,
	LAYER_SECTION_3	= LAYER_SECTION_2 + 1,
	LAYER_COUNT	= LAYER_SECTION_3 + 1
    } 	eLayer;

typedef 
enum eEffectType
    {	EFFECT_CUT	= 0,
	EFFECT_WIPE	= EFFECT_CUT + 1,
	EFFECT_PUSH	= EFFECT_WIPE + 1,
	EFFECT_DVE	= EFFECT_PUSH + 1,
	EFFECT_CURL	= EFFECT_DVE + 1,
	EFFECT_PARTICLE	= EFFECT_CURL + 1,
	EFFECT_RIPPLE	= EFFECT_PARTICLE + 1,
	EFFECT_ORGANIC	= EFFECT_RIPPLE + 1,
	EFFECT_DISTORTION	= EFFECT_ORGANIC + 1,
	EFFECT_BLINK	= EFFECT_DISTORTION + 1,
	EFFECT_MASK	= EFFECT_BLINK + 1,
	EFFECT_COUNT	= EFFECT_MASK + 1
    } 	eEffectType;



extern RPC_IF_HANDLE __MIDL_itf_TAPI_0000_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_TAPI_0000_v0_0_s_ifspec;

#ifndef __ITAPEventHandler_INTERFACE_DEFINED__
#define __ITAPEventHandler_INTERFACE_DEFINED__

/* interface ITAPEventHandler */
/* [unique][helpstring][nonextensible][dual][uuid][object] */ 


EXTERN_C const IID IID_ITAPEventHandler;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("7D2FDF75-28D2-4264-8C5E-3C7417AA4046")
    ITAPEventHandler : public IUnknown
    {
    public:
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE OnConnect( void) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE OnReceive( 
            BSTR pData) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE OnClose( void) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct ITAPEventHandlerVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            ITAPEventHandler * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            ITAPEventHandler * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            ITAPEventHandler * This);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *OnConnect )( 
            ITAPEventHandler * This);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *OnReceive )( 
            ITAPEventHandler * This,
            BSTR pData);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *OnClose )( 
            ITAPEventHandler * This);
        
        END_INTERFACE
    } ITAPEventHandlerVtbl;

    interface ITAPEventHandler
    {
        CONST_VTBL struct ITAPEventHandlerVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ITAPEventHandler_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define ITAPEventHandler_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define ITAPEventHandler_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define ITAPEventHandler_OnConnect(This)	\
    (This)->lpVtbl -> OnConnect(This)

#define ITAPEventHandler_OnReceive(This,pData)	\
    (This)->lpVtbl -> OnReceive(This,pData)

#define ITAPEventHandler_OnClose(This)	\
    (This)->lpVtbl -> OnClose(This)

#endif /* COBJMACROS */


#endif 	/* C style interface */



/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAPEventHandler_OnConnect_Proxy( 
    ITAPEventHandler * This);


void __RPC_STUB ITAPEventHandler_OnConnect_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAPEventHandler_OnReceive_Proxy( 
    ITAPEventHandler * This,
    BSTR pData);


void __RPC_STUB ITAPEventHandler_OnReceive_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAPEventHandler_OnClose_Proxy( 
    ITAPEventHandler * This);


void __RPC_STUB ITAPEventHandler_OnClose_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __ITAPEventHandler_INTERFACE_DEFINED__ */


#ifndef __ITAP_INTERFACE_DEFINED__
#define __ITAP_INTERFACE_DEFINED__

/* interface ITAP */
/* [unique][helpstring][nonextensible][dual][uuid][object] */ 


EXTERN_C const IID IID_ITAP;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("F672346C-DAFA-4748-95DA-AE568C68E1B1")
    ITAP : public IDispatch
    {
    public:
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Connect( 
            BOOL bTCP,
            BSTR ServerIPAddress,
            LONG ServerPort,
            LONG ClientPort,
            ITAPEventHandler *pHandler) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Hello( 
            BOOL bCheck) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Destroy( void) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetEventHandler( 
            ITAPEventHandler *pHandler) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Send( 
            BSTR string) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Bye( void) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE LoadPage( 
            BSTR FileName,
            BSTR PageName,
            /* [retval][out] */ BOOL *ret) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE UnloadPage( 
            BSTR PageName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE UnloadAllPages( void) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE LoadProject( 
            BSTR T3DFileName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SaveProject( 
            BSTR T3DFileName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE PreparePage( 
            BSTR PageName,
            eLayer Layer,
            BOOL bAutoPreview) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Play( 
            eLayer Layer) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Stop( void) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE PauseResume( 
            eLayer Layer,
            BOOL bBackground) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Out( 
            eLayer Layer) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetObjValue( 
            BSTR PageName,
            BSTR ObjName,
            BSTR Value,
            BOOL bTextImage) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetText( 
            BSTR PageName,
            BSTR ObjName,
            BSTR TextValue) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetObjVisible( 
            BSTR PageName,
            BSTR ObjName,
            BOOL bVisible) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetObjAttr( 
            BSTR PageName,
            BSTR ObjName,
            BSTR Options) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetPageDefault( 
            BSTR PageName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetBackground( 
            BSTR PageName,
            BSTR BGFileName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetPageEffect( 
            BSTR PageName,
            BOOL bIn,
            eEffectType EffectType,
            BSTR Options) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetPageEffectEx( 
            BSTR PageName,
            BOOL bIn,
            eEffectType EffectType,
            LONG FrameCount) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE AddPause( 
            BSTR PageName,
            LONG PauseFrame,
            LONG DelayFrame,
            BOOL bAutoResume) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE DeletePause( 
            BSTR PageName,
            LONG PauseFrame) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetScrollSpeed( 
            BSTR PageName,
            LONG Speed) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetAirScrollSpeed( 
            LONG Speed) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetAudioFile( 
            BSTR PageName,
            BOOL bIn,
            BSTR AudioFileName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetAudioEnable( 
            BSTR PageName,
            BOOL bIn,
            BOOL bEnable) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetStyleText( 
            BSTR PageName,
            BSTR ObjName,
            LONG StyleID,
            BSTR TextValue) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetImageObject( 
            BSTR PageName,
            BSTR ObjName,
            LONG ObjectID) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE AddStyleText( 
            BSTR PageName,
            BSTR ObjName,
            LONG StyleID,
            BSTR TextValue) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE AddImageObject( 
            BSTR PageName,
            BSTR ObjName,
            LONG ObjectID) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE AddScrollObject( 
            BSTR PageName,
            BSTR ObjName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE CreateImageFile( 
            BSTR PageName,
            LONG ImageWidth,
            LONG ImageHeight,
            BSTR ImagePathName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueryLoad( 
            BSTR PageName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueryPageMode( 
            BSTR PageName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueryPageAlias( 
            BSTR PageName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueryAliasAll( 
            BSTR PageName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueryObjValue( 
            BSTR PageName,
            BSTR ObjName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueryObjAttr( 
            BSTR PageName,
            BSTR ObjName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueryAudioFile( 
            BSTR PageName,
            BOOL bIn) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueryAudioEnable( 
            BSTR PageName,
            BOOL bIn) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueryScrollSpeed( 
            BSTR PageName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueryAirScrollMargin( 
            eLayer Layer) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueryPageEffect( 
            BSTR PageName,
            BOOL bIn) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueryPageEffectEx( 
            BSTR PageName,
            BOOL bIn) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetObjValue2( 
            BSTR PageName,
            BSTR ObjName,
            BSTR Value,
            BOOL bSeqTga) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetObjLine( 
            BSTR PageName,
            BSTR VariableName,
            BOOL b3D,
            int Thick,
            int Depth,
            BSTR strCoordinates) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SetImageObject2( 
            BSTR PageName,
            BSTR ObjName,
            BSTR FileName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE AddScrollObject2( 
            BSTR PageName,
            BSTR ObjName,
            eLayer LayerID) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE TopLayerIn( 
            BSTR PageName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE TopLayerOut( void) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueryPageTime( 
            BSTR PageName) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ChangeSequenceMode( 
            int Mode) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct ITAPVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            ITAP * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            ITAP * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            ITAP * This);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            ITAP * This,
            /* [out] */ UINT *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            ITAP * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            ITAP * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            ITAP * This,
            /* [in] */ DISPID dispIdMember,
            /* [in] */ REFIID riid,
            /* [in] */ LCID lcid,
            /* [in] */ WORD wFlags,
            /* [out][in] */ DISPPARAMS *pDispParams,
            /* [out] */ VARIANT *pVarResult,
            /* [out] */ EXCEPINFO *pExcepInfo,
            /* [out] */ UINT *puArgErr);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Connect )( 
            ITAP * This,
            BOOL bTCP,
            BSTR ServerIPAddress,
            LONG ServerPort,
            LONG ClientPort,
            ITAPEventHandler *pHandler);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Hello )( 
            ITAP * This,
            BOOL bCheck);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Destroy )( 
            ITAP * This);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetEventHandler )( 
            ITAP * This,
            ITAPEventHandler *pHandler);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Send )( 
            ITAP * This,
            BSTR string);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Bye )( 
            ITAP * This);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *LoadPage )( 
            ITAP * This,
            BSTR FileName,
            BSTR PageName,
            /* [retval][out] */ BOOL *ret);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *UnloadPage )( 
            ITAP * This,
            BSTR PageName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *UnloadAllPages )( 
            ITAP * This);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *LoadProject )( 
            ITAP * This,
            BSTR T3DFileName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SaveProject )( 
            ITAP * This,
            BSTR T3DFileName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *PreparePage )( 
            ITAP * This,
            BSTR PageName,
            eLayer Layer,
            BOOL bAutoPreview);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Play )( 
            ITAP * This,
            eLayer Layer);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Stop )( 
            ITAP * This);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *PauseResume )( 
            ITAP * This,
            eLayer Layer,
            BOOL bBackground);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Out )( 
            ITAP * This,
            eLayer Layer);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetObjValue )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName,
            BSTR Value,
            BOOL bTextImage);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetText )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName,
            BSTR TextValue);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetObjVisible )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName,
            BOOL bVisible);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetObjAttr )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName,
            BSTR Options);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetPageDefault )( 
            ITAP * This,
            BSTR PageName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetBackground )( 
            ITAP * This,
            BSTR PageName,
            BSTR BGFileName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetPageEffect )( 
            ITAP * This,
            BSTR PageName,
            BOOL bIn,
            eEffectType EffectType,
            BSTR Options);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetPageEffectEx )( 
            ITAP * This,
            BSTR PageName,
            BOOL bIn,
            eEffectType EffectType,
            LONG FrameCount);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *AddPause )( 
            ITAP * This,
            BSTR PageName,
            LONG PauseFrame,
            LONG DelayFrame,
            BOOL bAutoResume);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *DeletePause )( 
            ITAP * This,
            BSTR PageName,
            LONG PauseFrame);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetScrollSpeed )( 
            ITAP * This,
            BSTR PageName,
            LONG Speed);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetAirScrollSpeed )( 
            ITAP * This,
            LONG Speed);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetAudioFile )( 
            ITAP * This,
            BSTR PageName,
            BOOL bIn,
            BSTR AudioFileName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetAudioEnable )( 
            ITAP * This,
            BSTR PageName,
            BOOL bIn,
            BOOL bEnable);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetStyleText )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName,
            LONG StyleID,
            BSTR TextValue);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetImageObject )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName,
            LONG ObjectID);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *AddStyleText )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName,
            LONG StyleID,
            BSTR TextValue);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *AddImageObject )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName,
            LONG ObjectID);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *AddScrollObject )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *CreateImageFile )( 
            ITAP * This,
            BSTR PageName,
            LONG ImageWidth,
            LONG ImageHeight,
            BSTR ImagePathName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueryLoad )( 
            ITAP * This,
            BSTR PageName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueryPageMode )( 
            ITAP * This,
            BSTR PageName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueryPageAlias )( 
            ITAP * This,
            BSTR PageName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueryAliasAll )( 
            ITAP * This,
            BSTR PageName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueryObjValue )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueryObjAttr )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueryAudioFile )( 
            ITAP * This,
            BSTR PageName,
            BOOL bIn);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueryAudioEnable )( 
            ITAP * This,
            BSTR PageName,
            BOOL bIn);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueryScrollSpeed )( 
            ITAP * This,
            BSTR PageName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueryAirScrollMargin )( 
            ITAP * This,
            eLayer Layer);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueryPageEffect )( 
            ITAP * This,
            BSTR PageName,
            BOOL bIn);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueryPageEffectEx )( 
            ITAP * This,
            BSTR PageName,
            BOOL bIn);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetObjValue2 )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName,
            BSTR Value,
            BOOL bSeqTga);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetObjLine )( 
            ITAP * This,
            BSTR PageName,
            BSTR VariableName,
            BOOL b3D,
            int Thick,
            int Depth,
            BSTR strCoordinates);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SetImageObject2 )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName,
            BSTR FileName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *AddScrollObject2 )( 
            ITAP * This,
            BSTR PageName,
            BSTR ObjName,
            eLayer LayerID);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *TopLayerIn )( 
            ITAP * This,
            BSTR PageName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *TopLayerOut )( 
            ITAP * This);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueryPageTime )( 
            ITAP * This,
            BSTR PageName);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *ChangeSequenceMode )( 
            ITAP * This,
            int Mode);
        
        END_INTERFACE
    } ITAPVtbl;

    interface ITAP
    {
        CONST_VTBL struct ITAPVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ITAP_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define ITAP_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define ITAP_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define ITAP_GetTypeInfoCount(This,pctinfo)	\
    (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo)

#define ITAP_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo)

#define ITAP_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)

#define ITAP_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)


#define ITAP_Connect(This,bTCP,ServerIPAddress,ServerPort,ClientPort,pHandler)	\
    (This)->lpVtbl -> Connect(This,bTCP,ServerIPAddress,ServerPort,ClientPort,pHandler)

#define ITAP_Hello(This,bCheck)	\
    (This)->lpVtbl -> Hello(This,bCheck)

#define ITAP_Destroy(This)	\
    (This)->lpVtbl -> Destroy(This)

#define ITAP_SetEventHandler(This,pHandler)	\
    (This)->lpVtbl -> SetEventHandler(This,pHandler)

#define ITAP_Send(This,string)	\
    (This)->lpVtbl -> Send(This,string)

#define ITAP_Bye(This)	\
    (This)->lpVtbl -> Bye(This)

#define ITAP_LoadPage(This,FileName,PageName,ret)	\
    (This)->lpVtbl -> LoadPage(This,FileName,PageName,ret)

#define ITAP_UnloadPage(This,PageName)	\
    (This)->lpVtbl -> UnloadPage(This,PageName)

#define ITAP_UnloadAllPages(This)	\
    (This)->lpVtbl -> UnloadAllPages(This)

#define ITAP_LoadProject(This,T3DFileName)	\
    (This)->lpVtbl -> LoadProject(This,T3DFileName)

#define ITAP_SaveProject(This,T3DFileName)	\
    (This)->lpVtbl -> SaveProject(This,T3DFileName)

#define ITAP_PreparePage(This,PageName,Layer,bAutoPreview)	\
    (This)->lpVtbl -> PreparePage(This,PageName,Layer,bAutoPreview)

#define ITAP_Play(This,Layer)	\
    (This)->lpVtbl -> Play(This,Layer)

#define ITAP_Stop(This)	\
    (This)->lpVtbl -> Stop(This)

#define ITAP_PauseResume(This,Layer,bBackground)	\
    (This)->lpVtbl -> PauseResume(This,Layer,bBackground)

#define ITAP_Out(This,Layer)	\
    (This)->lpVtbl -> Out(This,Layer)

#define ITAP_SetObjValue(This,PageName,ObjName,Value,bTextImage)	\
    (This)->lpVtbl -> SetObjValue(This,PageName,ObjName,Value,bTextImage)

#define ITAP_SetText(This,PageName,ObjName,TextValue)	\
    (This)->lpVtbl -> SetText(This,PageName,ObjName,TextValue)

#define ITAP_SetObjVisible(This,PageName,ObjName,bVisible)	\
    (This)->lpVtbl -> SetObjVisible(This,PageName,ObjName,bVisible)

#define ITAP_SetObjAttr(This,PageName,ObjName,Options)	\
    (This)->lpVtbl -> SetObjAttr(This,PageName,ObjName,Options)

#define ITAP_SetPageDefault(This,PageName)	\
    (This)->lpVtbl -> SetPageDefault(This,PageName)

#define ITAP_SetBackground(This,PageName,BGFileName)	\
    (This)->lpVtbl -> SetBackground(This,PageName,BGFileName)

#define ITAP_SetPageEffect(This,PageName,bIn,EffectType,Options)	\
    (This)->lpVtbl -> SetPageEffect(This,PageName,bIn,EffectType,Options)

#define ITAP_SetPageEffectEx(This,PageName,bIn,EffectType,FrameCount)	\
    (This)->lpVtbl -> SetPageEffectEx(This,PageName,bIn,EffectType,FrameCount)

#define ITAP_AddPause(This,PageName,PauseFrame,DelayFrame,bAutoResume)	\
    (This)->lpVtbl -> AddPause(This,PageName,PauseFrame,DelayFrame,bAutoResume)

#define ITAP_DeletePause(This,PageName,PauseFrame)	\
    (This)->lpVtbl -> DeletePause(This,PageName,PauseFrame)

#define ITAP_SetScrollSpeed(This,PageName,Speed)	\
    (This)->lpVtbl -> SetScrollSpeed(This,PageName,Speed)

#define ITAP_SetAirScrollSpeed(This,Speed)	\
    (This)->lpVtbl -> SetAirScrollSpeed(This,Speed)

#define ITAP_SetAudioFile(This,PageName,bIn,AudioFileName)	\
    (This)->lpVtbl -> SetAudioFile(This,PageName,bIn,AudioFileName)

#define ITAP_SetAudioEnable(This,PageName,bIn,bEnable)	\
    (This)->lpVtbl -> SetAudioEnable(This,PageName,bIn,bEnable)

#define ITAP_SetStyleText(This,PageName,ObjName,StyleID,TextValue)	\
    (This)->lpVtbl -> SetStyleText(This,PageName,ObjName,StyleID,TextValue)

#define ITAP_SetImageObject(This,PageName,ObjName,ObjectID)	\
    (This)->lpVtbl -> SetImageObject(This,PageName,ObjName,ObjectID)

#define ITAP_AddStyleText(This,PageName,ObjName,StyleID,TextValue)	\
    (This)->lpVtbl -> AddStyleText(This,PageName,ObjName,StyleID,TextValue)

#define ITAP_AddImageObject(This,PageName,ObjName,ObjectID)	\
    (This)->lpVtbl -> AddImageObject(This,PageName,ObjName,ObjectID)

#define ITAP_AddScrollObject(This,PageName,ObjName)	\
    (This)->lpVtbl -> AddScrollObject(This,PageName,ObjName)

#define ITAP_CreateImageFile(This,PageName,ImageWidth,ImageHeight,ImagePathName)	\
    (This)->lpVtbl -> CreateImageFile(This,PageName,ImageWidth,ImageHeight,ImagePathName)

#define ITAP_QueryLoad(This,PageName)	\
    (This)->lpVtbl -> QueryLoad(This,PageName)

#define ITAP_QueryPageMode(This,PageName)	\
    (This)->lpVtbl -> QueryPageMode(This,PageName)

#define ITAP_QueryPageAlias(This,PageName)	\
    (This)->lpVtbl -> QueryPageAlias(This,PageName)

#define ITAP_QueryAliasAll(This,PageName)	\
    (This)->lpVtbl -> QueryAliasAll(This,PageName)

#define ITAP_QueryObjValue(This,PageName,ObjName)	\
    (This)->lpVtbl -> QueryObjValue(This,PageName,ObjName)

#define ITAP_QueryObjAttr(This,PageName,ObjName)	\
    (This)->lpVtbl -> QueryObjAttr(This,PageName,ObjName)

#define ITAP_QueryAudioFile(This,PageName,bIn)	\
    (This)->lpVtbl -> QueryAudioFile(This,PageName,bIn)

#define ITAP_QueryAudioEnable(This,PageName,bIn)	\
    (This)->lpVtbl -> QueryAudioEnable(This,PageName,bIn)

#define ITAP_QueryScrollSpeed(This,PageName)	\
    (This)->lpVtbl -> QueryScrollSpeed(This,PageName)

#define ITAP_QueryAirScrollMargin(This,Layer)	\
    (This)->lpVtbl -> QueryAirScrollMargin(This,Layer)

#define ITAP_QueryPageEffect(This,PageName,bIn)	\
    (This)->lpVtbl -> QueryPageEffect(This,PageName,bIn)

#define ITAP_QueryPageEffectEx(This,PageName,bIn)	\
    (This)->lpVtbl -> QueryPageEffectEx(This,PageName,bIn)

#define ITAP_SetObjValue2(This,PageName,ObjName,Value,bSeqTga)	\
    (This)->lpVtbl -> SetObjValue2(This,PageName,ObjName,Value,bSeqTga)

#define ITAP_SetObjLine(This,PageName,VariableName,b3D,Thick,Depth,strCoordinates)	\
    (This)->lpVtbl -> SetObjLine(This,PageName,VariableName,b3D,Thick,Depth,strCoordinates)

#define ITAP_SetImageObject2(This,PageName,ObjName,FileName)	\
    (This)->lpVtbl -> SetImageObject2(This,PageName,ObjName,FileName)

#define ITAP_AddScrollObject2(This,PageName,ObjName,LayerID)	\
    (This)->lpVtbl -> AddScrollObject2(This,PageName,ObjName,LayerID)

#define ITAP_TopLayerIn(This,PageName)	\
    (This)->lpVtbl -> TopLayerIn(This,PageName)

#define ITAP_TopLayerOut(This)	\
    (This)->lpVtbl -> TopLayerOut(This)

#define ITAP_QueryPageTime(This,PageName)	\
    (This)->lpVtbl -> QueryPageTime(This,PageName)

#define ITAP_ChangeSequenceMode(This,Mode)	\
    (This)->lpVtbl -> ChangeSequenceMode(This,Mode)

#endif /* COBJMACROS */


#endif 	/* C style interface */



/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_Connect_Proxy( 
    ITAP * This,
    BOOL bTCP,
    BSTR ServerIPAddress,
    LONG ServerPort,
    LONG ClientPort,
    ITAPEventHandler *pHandler);


void __RPC_STUB ITAP_Connect_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_Hello_Proxy( 
    ITAP * This,
    BOOL bCheck);


void __RPC_STUB ITAP_Hello_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_Destroy_Proxy( 
    ITAP * This);


void __RPC_STUB ITAP_Destroy_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetEventHandler_Proxy( 
    ITAP * This,
    ITAPEventHandler *pHandler);


void __RPC_STUB ITAP_SetEventHandler_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_Send_Proxy( 
    ITAP * This,
    BSTR string);


void __RPC_STUB ITAP_Send_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_Bye_Proxy( 
    ITAP * This);


void __RPC_STUB ITAP_Bye_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_LoadPage_Proxy( 
    ITAP * This,
    BSTR FileName,
    BSTR PageName,
    /* [retval][out] */ BOOL *ret);


void __RPC_STUB ITAP_LoadPage_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_UnloadPage_Proxy( 
    ITAP * This,
    BSTR PageName);


void __RPC_STUB ITAP_UnloadPage_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_UnloadAllPages_Proxy( 
    ITAP * This);


void __RPC_STUB ITAP_UnloadAllPages_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_LoadProject_Proxy( 
    ITAP * This,
    BSTR T3DFileName);


void __RPC_STUB ITAP_LoadProject_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SaveProject_Proxy( 
    ITAP * This,
    BSTR T3DFileName);


void __RPC_STUB ITAP_SaveProject_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_PreparePage_Proxy( 
    ITAP * This,
    BSTR PageName,
    eLayer Layer,
    BOOL bAutoPreview);


void __RPC_STUB ITAP_PreparePage_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_Play_Proxy( 
    ITAP * This,
    eLayer Layer);


void __RPC_STUB ITAP_Play_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_Stop_Proxy( 
    ITAP * This);


void __RPC_STUB ITAP_Stop_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_PauseResume_Proxy( 
    ITAP * This,
    eLayer Layer,
    BOOL bBackground);


void __RPC_STUB ITAP_PauseResume_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_Out_Proxy( 
    ITAP * This,
    eLayer Layer);


void __RPC_STUB ITAP_Out_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetObjValue_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName,
    BSTR Value,
    BOOL bTextImage);


void __RPC_STUB ITAP_SetObjValue_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetText_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName,
    BSTR TextValue);


void __RPC_STUB ITAP_SetText_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetObjVisible_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName,
    BOOL bVisible);


void __RPC_STUB ITAP_SetObjVisible_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetObjAttr_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName,
    BSTR Options);


void __RPC_STUB ITAP_SetObjAttr_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetPageDefault_Proxy( 
    ITAP * This,
    BSTR PageName);


void __RPC_STUB ITAP_SetPageDefault_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetBackground_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR BGFileName);


void __RPC_STUB ITAP_SetBackground_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetPageEffect_Proxy( 
    ITAP * This,
    BSTR PageName,
    BOOL bIn,
    eEffectType EffectType,
    BSTR Options);


void __RPC_STUB ITAP_SetPageEffect_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetPageEffectEx_Proxy( 
    ITAP * This,
    BSTR PageName,
    BOOL bIn,
    eEffectType EffectType,
    LONG FrameCount);


void __RPC_STUB ITAP_SetPageEffectEx_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_AddPause_Proxy( 
    ITAP * This,
    BSTR PageName,
    LONG PauseFrame,
    LONG DelayFrame,
    BOOL bAutoResume);


void __RPC_STUB ITAP_AddPause_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_DeletePause_Proxy( 
    ITAP * This,
    BSTR PageName,
    LONG PauseFrame);


void __RPC_STUB ITAP_DeletePause_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetScrollSpeed_Proxy( 
    ITAP * This,
    BSTR PageName,
    LONG Speed);


void __RPC_STUB ITAP_SetScrollSpeed_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetAirScrollSpeed_Proxy( 
    ITAP * This,
    LONG Speed);


void __RPC_STUB ITAP_SetAirScrollSpeed_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetAudioFile_Proxy( 
    ITAP * This,
    BSTR PageName,
    BOOL bIn,
    BSTR AudioFileName);


void __RPC_STUB ITAP_SetAudioFile_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetAudioEnable_Proxy( 
    ITAP * This,
    BSTR PageName,
    BOOL bIn,
    BOOL bEnable);


void __RPC_STUB ITAP_SetAudioEnable_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetStyleText_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName,
    LONG StyleID,
    BSTR TextValue);


void __RPC_STUB ITAP_SetStyleText_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetImageObject_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName,
    LONG ObjectID);


void __RPC_STUB ITAP_SetImageObject_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_AddStyleText_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName,
    LONG StyleID,
    BSTR TextValue);


void __RPC_STUB ITAP_AddStyleText_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_AddImageObject_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName,
    LONG ObjectID);


void __RPC_STUB ITAP_AddImageObject_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_AddScrollObject_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName);


void __RPC_STUB ITAP_AddScrollObject_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_CreateImageFile_Proxy( 
    ITAP * This,
    BSTR PageName,
    LONG ImageWidth,
    LONG ImageHeight,
    BSTR ImagePathName);


void __RPC_STUB ITAP_CreateImageFile_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_QueryLoad_Proxy( 
    ITAP * This,
    BSTR PageName);


void __RPC_STUB ITAP_QueryLoad_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_QueryPageMode_Proxy( 
    ITAP * This,
    BSTR PageName);


void __RPC_STUB ITAP_QueryPageMode_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_QueryPageAlias_Proxy( 
    ITAP * This,
    BSTR PageName);


void __RPC_STUB ITAP_QueryPageAlias_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_QueryAliasAll_Proxy( 
    ITAP * This,
    BSTR PageName);


void __RPC_STUB ITAP_QueryAliasAll_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_QueryObjValue_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName);


void __RPC_STUB ITAP_QueryObjValue_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_QueryObjAttr_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName);


void __RPC_STUB ITAP_QueryObjAttr_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_QueryAudioFile_Proxy( 
    ITAP * This,
    BSTR PageName,
    BOOL bIn);


void __RPC_STUB ITAP_QueryAudioFile_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_QueryAudioEnable_Proxy( 
    ITAP * This,
    BSTR PageName,
    BOOL bIn);


void __RPC_STUB ITAP_QueryAudioEnable_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_QueryScrollSpeed_Proxy( 
    ITAP * This,
    BSTR PageName);


void __RPC_STUB ITAP_QueryScrollSpeed_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_QueryAirScrollMargin_Proxy( 
    ITAP * This,
    eLayer Layer);


void __RPC_STUB ITAP_QueryAirScrollMargin_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_QueryPageEffect_Proxy( 
    ITAP * This,
    BSTR PageName,
    BOOL bIn);


void __RPC_STUB ITAP_QueryPageEffect_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_QueryPageEffectEx_Proxy( 
    ITAP * This,
    BSTR PageName,
    BOOL bIn);


void __RPC_STUB ITAP_QueryPageEffectEx_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetObjValue2_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName,
    BSTR Value,
    BOOL bSeqTga);


void __RPC_STUB ITAP_SetObjValue2_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetObjLine_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR VariableName,
    BOOL b3D,
    int Thick,
    int Depth,
    BSTR strCoordinates);


void __RPC_STUB ITAP_SetObjLine_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_SetImageObject2_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName,
    BSTR FileName);


void __RPC_STUB ITAP_SetImageObject2_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_AddScrollObject2_Proxy( 
    ITAP * This,
    BSTR PageName,
    BSTR ObjName,
    eLayer LayerID);


void __RPC_STUB ITAP_AddScrollObject2_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_TopLayerIn_Proxy( 
    ITAP * This,
    BSTR PageName);


void __RPC_STUB ITAP_TopLayerIn_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_TopLayerOut_Proxy( 
    ITAP * This);


void __RPC_STUB ITAP_TopLayerOut_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_QueryPageTime_Proxy( 
    ITAP * This,
    BSTR PageName);


void __RPC_STUB ITAP_QueryPageTime_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAP_ChangeSequenceMode_Proxy( 
    ITAP * This,
    int Mode);


void __RPC_STUB ITAP_ChangeSequenceMode_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __ITAP_INTERFACE_DEFINED__ */


#ifndef __ITAPParser_INTERFACE_DEFINED__
#define __ITAPParser_INTERFACE_DEFINED__

/* interface ITAPParser */
/* [unique][helpstring][nonextensible][dual][uuid][object] */ 


EXTERN_C const IID IID_ITAPParser;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("BF754FD0-3663-4C2C-9848-29281519E6EC")
    ITAPParser : public IDispatch
    {
    public:
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Parse( 
            BSTR Text,
            /* [retval][out] */ BOOL *ret) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE GetCommand( 
            /* [retval][out] */ eTAPCommand *Command) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE GetNextCommand( 
            /* [retval][out] */ eTAPCommand *Command) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE GetNextString( 
            /* [retval][out] */ BSTR *str) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE GetNextQuotationString( 
            /* [retval][out] */ BSTR *str) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE GetNextOptionString( 
            /* [retval][out] */ BSTR *str) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE GetNextStringAll( 
            /* [retval][out] */ BSTR *str) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct ITAPParserVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            ITAPParser * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            ITAPParser * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            ITAPParser * This);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            ITAPParser * This,
            /* [out] */ UINT *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            ITAPParser * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            ITAPParser * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            ITAPParser * This,
            /* [in] */ DISPID dispIdMember,
            /* [in] */ REFIID riid,
            /* [in] */ LCID lcid,
            /* [in] */ WORD wFlags,
            /* [out][in] */ DISPPARAMS *pDispParams,
            /* [out] */ VARIANT *pVarResult,
            /* [out] */ EXCEPINFO *pExcepInfo,
            /* [out] */ UINT *puArgErr);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Parse )( 
            ITAPParser * This,
            BSTR Text,
            /* [retval][out] */ BOOL *ret);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *GetCommand )( 
            ITAPParser * This,
            /* [retval][out] */ eTAPCommand *Command);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *GetNextCommand )( 
            ITAPParser * This,
            /* [retval][out] */ eTAPCommand *Command);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *GetNextString )( 
            ITAPParser * This,
            /* [retval][out] */ BSTR *str);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *GetNextQuotationString )( 
            ITAPParser * This,
            /* [retval][out] */ BSTR *str);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *GetNextOptionString )( 
            ITAPParser * This,
            /* [retval][out] */ BSTR *str);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *GetNextStringAll )( 
            ITAPParser * This,
            /* [retval][out] */ BSTR *str);
        
        END_INTERFACE
    } ITAPParserVtbl;

    interface ITAPParser
    {
        CONST_VTBL struct ITAPParserVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ITAPParser_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define ITAPParser_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define ITAPParser_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define ITAPParser_GetTypeInfoCount(This,pctinfo)	\
    (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo)

#define ITAPParser_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo)

#define ITAPParser_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)

#define ITAPParser_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)


#define ITAPParser_Parse(This,Text,ret)	\
    (This)->lpVtbl -> Parse(This,Text,ret)

#define ITAPParser_GetCommand(This,Command)	\
    (This)->lpVtbl -> GetCommand(This,Command)

#define ITAPParser_GetNextCommand(This,Command)	\
    (This)->lpVtbl -> GetNextCommand(This,Command)

#define ITAPParser_GetNextString(This,str)	\
    (This)->lpVtbl -> GetNextString(This,str)

#define ITAPParser_GetNextQuotationString(This,str)	\
    (This)->lpVtbl -> GetNextQuotationString(This,str)

#define ITAPParser_GetNextOptionString(This,str)	\
    (This)->lpVtbl -> GetNextOptionString(This,str)

#define ITAPParser_GetNextStringAll(This,str)	\
    (This)->lpVtbl -> GetNextStringAll(This,str)

#endif /* COBJMACROS */


#endif 	/* C style interface */



/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAPParser_Parse_Proxy( 
    ITAPParser * This,
    BSTR Text,
    /* [retval][out] */ BOOL *ret);


void __RPC_STUB ITAPParser_Parse_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAPParser_GetCommand_Proxy( 
    ITAPParser * This,
    /* [retval][out] */ eTAPCommand *Command);


void __RPC_STUB ITAPParser_GetCommand_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAPParser_GetNextCommand_Proxy( 
    ITAPParser * This,
    /* [retval][out] */ eTAPCommand *Command);


void __RPC_STUB ITAPParser_GetNextCommand_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAPParser_GetNextString_Proxy( 
    ITAPParser * This,
    /* [retval][out] */ BSTR *str);


void __RPC_STUB ITAPParser_GetNextString_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAPParser_GetNextQuotationString_Proxy( 
    ITAPParser * This,
    /* [retval][out] */ BSTR *str);


void __RPC_STUB ITAPParser_GetNextQuotationString_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAPParser_GetNextOptionString_Proxy( 
    ITAPParser * This,
    /* [retval][out] */ BSTR *str);


void __RPC_STUB ITAPParser_GetNextOptionString_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE ITAPParser_GetNextStringAll_Proxy( 
    ITAPParser * This,
    /* [retval][out] */ BSTR *str);


void __RPC_STUB ITAPParser_GetNextStringAll_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __ITAPParser_INTERFACE_DEFINED__ */



#ifndef __TAPI_LIBRARY_DEFINED__
#define __TAPI_LIBRARY_DEFINED__

/* library TAPI */
/* [helpstring][version][uuid] */ 


EXTERN_C const IID LIBID_TAPI;

EXTERN_C const CLSID CLSID_TAPEventHandler;

#ifdef __cplusplus

class DECLSPEC_UUID("5086449B-9A59-4A0C-ACA7-7E4E03BB7001")
TAPEventHandler;
#endif

EXTERN_C const CLSID CLSID_TAP;

#ifdef __cplusplus

class DECLSPEC_UUID("9B6BE992-8D43-4481-B91B-8E588905236B")
TAP;
#endif

EXTERN_C const CLSID CLSID_TAPParser;

#ifdef __cplusplus

class DECLSPEC_UUID("C43B085B-8DE1-4482-8124-DE5588C67F07")
TAPParser;
#endif
#endif /* __TAPI_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

unsigned long             __RPC_USER  BSTR_UserSize(     unsigned long *, unsigned long            , BSTR * ); 
unsigned char * __RPC_USER  BSTR_UserMarshal(  unsigned long *, unsigned char *, BSTR * ); 
unsigned char * __RPC_USER  BSTR_UserUnmarshal(unsigned long *, unsigned char *, BSTR * ); 
void                      __RPC_USER  BSTR_UserFree(     unsigned long *, BSTR * ); 

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


