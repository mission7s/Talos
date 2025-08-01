// TAPPlayDlg.h : header file
//

#pragma once

// CTAPPlayDlg dialog
class CTAPPlayDlg : public CDialog
{
// Construction
public:
	CTAPPlayDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_TAPPLAY_DIALOG };
	CEdit	MessageEdit;

	void OnReceive(CString& strRcev);
	void ShowMessage(CString& strRecv);

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedBrowse();
	afx_msg void OnBnClickedLoad();
	afx_msg void OnBnClickedPrepare();
	afx_msg void OnBnClickedPlay();
	afx_msg void OnBnClickedClear();
	afx_msg void OnBnClickedConnect();
};

