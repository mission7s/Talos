#pragma once

#ifdef _DEBUG
#import "../../../DLL/Debug/TAPI.dll"
#else
#import "../../../DLL/Release/TAPI.dll"
#endif

enum {
	TAP_RECEIVE = WM_USER + 9000,
};

//////////////////////////////////////////////////////////////////////////
class CTAPEventHandler : public TAPI::ITAPEventHandler{
public:
	CTAPEventHandler(){
		RefCount = 1;
	}

	~CTAPEventHandler(){
	}

	ULONG STDMETHODCALLTYPE AddRef(){ 
		RefCount ++; 
		return RefCount; 
	}

	ULONG STDMETHODCALLTYPE Release(){ 
		RefCount --; 
		if(RefCount == 0) 
			delete this; 
		return RefCount; 
	}

	HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void __RPC_FAR *__RPC_FAR *ppvObject){
		return S_FALSE;
	}

	// Raw methods provided by interface
	HRESULT STDMETHODCALLTYPE raw_OnConnect()= 0;
	HRESULT STDMETHODCALLTYPE raw_OnClose() = 0;
	HRESULT STDMETHODCALLTYPE raw_OnReceive(BSTR pData) = 0;
	//HRESULT STDMETHODCALLTYPE raw_OnReceive(BSTR pData) = 0;

protected:
	int RefCount;
};
