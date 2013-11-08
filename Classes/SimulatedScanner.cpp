//
//  SimulatedScanner.cpp
//  evalpal
//
//  Created by Bill MacAdam on 6/4/13.
//  Copyright (c) 2013 Bill MacAdam. All rights reserved.
//

#include "SimulatedScanner.h"

CScanner::CScanner(void* pControler)
{
	m_pControler = pControler;
    m_scan=false;
}
CScanner::~CScanner()
{
}
void CScanner::OnTimeout()
{
    m_scan=false;
	WrapError(m_pControler,"Time Out");
    
}
void CScanner::OnError(ErrorType error)
{
    m_scan=false;
	switch (error) {
		case CameraInUseError:
			WrapError(m_pControler,"Camera in use Error");
			break;
		case GeneralError:
			WrapError(m_pControler,"General Error");
			break;
		case LicenseError:
			WrapError(m_pControler,"License Error");
			break;
		case CodeInvalidError:
			WrapError(m_pControler,"Code Invalid Error");
			break;
		case CodeNotSupportedError:
			WrapError(m_pControler,"Code Not Supported Error");
			break;
		default:
			break;
	}
}
void CScanner::OnNotification(NotificationType notification){
	switch (notification) {
		case GettingLicenseStarted:
			WrapNotify(m_pControler, "Getting License Started");
			break;
		case LicenseProcessSucceeded:
			WrapNotify(m_pControler, "Getting License Succeeded");
			break;
		case LicenseProcessFailed:
			WrapNotify(m_pControler, "License Process Failed");
			break;
		case CameraStarted:
			WrapNotify(m_pControler, "Camera Started");
			break;
		case CameraClosed:
			WrapNotify(m_pControler, "Camera Closed");
			break;
		case CodeFound:
			WrapNotify(m_pControler, "Code Found");
			break;
        default:
			break;
            
	}
}
void CScanner::OnDecode(unsigned char *result,int len,DecodingFlags SymbolType,DecodingMode SymbolMode)
{
    m_scan=false;
	// convert raw data to unicode string
	unsigned short* str = new unsigned short[len+1];
	for (int i = 0 ; i < len; i++){
		str[i] = result[i];
	}
	str[len] = 0;
    const char* type;
    const char* mode;
    WrapDecode(m_pControler,str,type,mode);
    delete str;
    
}

void CScanner::OnCameraStopOrStart(int on)
{
	WrapCameraStopOrStart(on,m_pControler);
}
void CScanner::Scan(void* pView)
{
    Scan(pView,5,5,300,400,
         5,5,500,500, 0);
}
void CScanner::Scan(void* pView,int x, int y, int w , int h ,int timeoutInSeconds)
{
    Scan(pView,x,y,w,h,x,y,w,h,timeoutInSeconds);
}

void CScanner::Scan(void* pView,int x, int y, int w , int h ,
                    int xLand, int yLand, int wLand , int hLand ,
                    int timeoutInSeconds)
{
    m_scan=true;
}

void CScanner::SetOrientation(int Orientation)
{
}

void CScanner::UpdateLicense()
{
}

void CScanner::Abort()
{
    m_scan=false;
}

void CScanner::CloseCamera()
{
    m_scan=false;
}

int CScanner::IsTorchAvailable()
{
    return 1;
}

void CScanner::TurnTorch(int on)
{
}

void CScanner::OnBackground()
{
}

void CScanner::OnForground()
{
}
