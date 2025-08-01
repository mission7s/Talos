// TAPAnimationDlg.h : header file
//

#pragma once


// CTAPAnimationDlg dialog
class CTAPAnimationDlg : public CDialog
{
// Construction
public:
	CTAPAnimationDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_TAPANIMATION_DIALOG };
	CEdit	MessageEdit;

	CString	PageNames[2];

	int BeginScales[3];
	int EndScales[3];

	int BeginFrames[5];
	int EndFrames[5];
	int BeginDegrees[5];
	int EndDegrees[5];

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
	afx_msg void OnBnClickedConnect();
	afx_msg void OnBnClickedBrowse1();
	afx_msg void OnBnClickedSetScale();
	afx_msg void OnBnClickedPrepare1();
	afx_msg void OnBnClickedPlay1();
	afx_msg void OnBnClickedClear1();
	afx_msg void OnBnClickedBrowse2();
	afx_msg void OnBnClickedSetCircleangle1();
	afx_msg void OnBnClickedSetCircleangle2();
	afx_msg void OnBnClickedSetCircleangle3();
	afx_msg void OnBnClickedSetCircleangle4();
	afx_msg void OnBnClickedSetCircleangle5();
	afx_msg void OnBnClickedPrepare2();
	afx_msg void OnBnClickedPlay2();
	afx_msg void OnBnClickedClear2();
};
