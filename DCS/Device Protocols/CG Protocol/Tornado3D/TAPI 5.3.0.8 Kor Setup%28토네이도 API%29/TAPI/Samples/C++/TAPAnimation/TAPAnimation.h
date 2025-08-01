// TAPAnimation.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols

#include "TAPEventHandler.h"

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
class CMyTAPHandler : public CTAPEventHandler
{
public:
	HRESULT STDMETHODCALLTYPE raw_Test();

	HRESULT STDMETHODCALLTYPE raw_OnConnect();

	HRESULT STDMETHODCALLTYPE raw_OnClose();

	HRESULT STDMETHODCALLTYPE raw_OnReceive(BSTR pData);
	//HRESULT STDMETHODCALLTYPE raw_OnReceive(BSTR pData);

};
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

// CTAPAnimationApp:
// See TAPAnimation.cpp for the implementation of this class
//

class CTAPAnimationApp : public CWinApp
{
public:
	CTAPAnimationApp();

// Overrides
	public:
	virtual BOOL InitInstance();

	TAPI::ITAPPtr		pTAP;
	TAPI::ITAPParserPtr	pTAPParser;
	CMyTAPHandler*	pMyHandler;

	void OnReceive(CString& strRcev);
// Implementation

	DECLARE_MESSAGE_MAP()
};

extern CTAPAnimationApp theApp;