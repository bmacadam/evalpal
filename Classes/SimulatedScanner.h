//
//  SimulatedScanner.h
//  evalpal
//
//  Created by Bill MacAdam on 6/4/13.
//  Copyright (c) 2013 Bill MacAdam. All rights reserved.
//

#ifndef __evalpal__SimulatedScanner__
#define __evalpal__SimulatedScanner__

void WrapError(void* pThis,const char* str);
void WrapNotify(void* pThis,const char* str);
void WrapDecode(void* pThis,const unsigned short* str,const char*  SymbolType,const char*  SymbolMode);
void WrapCameraStopOrStart(int on,void* pThis);

class CScanner  {
public:
	enum DecodingFlags
	{
		None					= 0x00000000,	//No flags
		DecodeEAN8				= 0x00000001,	//Decode EAN8
		DecodeEAN13				= 0x00000002,	//Decode EAN13
		DecodeCODABAR			= 0x00000008,	//Decode Codabar NW7
        DecodeMicroQR           = 0x00000080,   //Decode Micro QR
        DecodeDataMatrix		= 0x00000100,	//Decode DataMatrix
		DecodeQR				= 0x00000200,	//Decode QR
		DecodePDF417			= 0x00000800,	//Decode PDF417
		DecodeEAN128			= 0x00001000,	//Decode Code 128
		DecodeEAN39				= 0x00002000,	//Decode Code 39
		Decode_2_of_5			= 0x00004000,	//Decode 2 of 5
        DecodeGS1_OMNI			= 0x00008000,   //Decode GS1 OMNI
        
        
		DecodeBlackOnWhite		= 0x00010000,	//Reverse B&W barcodes
		ContinuousDecode		= 0x10000000,	//Continues decoding
	};
    
	enum DecodingMode
	{
		NoFunc                  = 0x00000000,	//No func
		Func1                   = 0x00000001,	//Func1
		Func2                   = 0x00000002,	//Func2
	};
    
    enum ErrorType
    {
        EmptyError=0,
        CameraInUseError,		// Camera could not be operated because it is used by other application
        GeneralError,			// Could not open the camera / Unknown error occurred
        LicenseError,			// No License / Wrong license / Insufficient license
        CodeInvalidError,
        CodeNotSupportedError
    };

    enum NotificationType
    {
        EmptyNofitication = 0,
        GettingLicenseStarted,
        LicenseProcessSucceeded,
        LicenseProcessFailed,
        CameraStarted,
        CameraClosed,
        CodeFound
    };
    
	CScanner(void* pControler);
	virtual ~CScanner();
	virtual void OnTimeout();						//Called if no bar code decoded till timeout occurred
	virtual void OnError(ErrorType error) ;		// Called on error
	virtual void OnNotification(NotificationType notification);		// Called on Notification
	virtual void OnDecode(unsigned char *result,int len,DecodingFlags SymbolType,DecodingMode mode);	// Called on successful decoding with the bar code content
	virtual void OnCameraStopOrStart(int on);	// Called after camera begin or stop to be able to add or remove GUI layers`
    void SetOrientation(int Orientation);
    void Scan(void* pView);
	void Scan(void* pView,int x, int y, int w , int h ,int timeoutInSeconds = 45);
    // one more preview rect set for landscape
	void Scan(void* pView,int x, int y, int w , int h ,int xLand, int yLand, int wLand , int hLand , int timeoutInSeconds = 45);
	void UpdateLicense();
	void Abort();
	void CloseCamera();
    int IsTorchAvailable();
    void TurnTorch(int on);
    void OnBackground();
    void OnForground();

private:
	void* m_pControler;
    void* m_pView;
    int m_x;
    int m_y;
    int m_w;
    int m_h;
    int m_xLand;
    int m_yLand;
    int m_wLand;
    int m_hLand;
    int m_timeoutInSeconds;
    bool m_scan;

};

#endif /* defined(__evalpal__SimulatedScanner__) */
