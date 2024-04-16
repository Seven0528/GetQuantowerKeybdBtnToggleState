#Include <Class_iseahound.ImagePut.20240313-1.10.0-d37dd55dd83902f31f1f18502db08b2d49d2b498-ahk2>
#Include <FunctionGroup_buliasz.Gdip_All.20240110-1.61.0-8960b875c4f1064865b51c72978d61e6648c0343-ahk2>
GetQuantowerKeybdBtnToggleState()    { ;  ahk2.0
    static init:=false, bufNeedleOff, bufNeedleOn
        ,DPI_AWARENESS_CONTEXT_UNAWARE:=-1
    getWindowDpiAwarenessContextIgnoringInfoFlag(hWnd)    {
        areDpiAwarenessContextsEqual(dpiContextA, dpiContextB)    {
            return dllCall("User32.dll\AreDpiAwarenessContextsEqual", "Ptr",dpiContextA, "Ptr",dpiContextB)
        }
        getWindowDpiAwarenessContext(hWnd)    {
            return dllCall("User32.dll\GetWindowDpiAwarenessContext", "Ptr",hWnd, "Ptr")
        }
        if (dpiContextA:=getWindowDpiAwarenessContext(hWnd))    {
            loop 5    {
                dpiContextB:=-1*A_Index
                if (areDpiAwarenessContextsEqual(dpiContextA,dpiContextB))
                    return dpiContextB
            }
        }
        return false
    }
    if (!init)    {
        init:=true
        if (!fileExist(pathOff:=A_Temp "\QuantowerKeybdBtnOff.png"))
            download("https://raw.githubusercontent.com/Seven0528/GetQuantowerKeybdBtnToggleState/main/QuantowerKeybdBtnOff.png", pathOff)
        if (!fileExist(pathOn:=A_Temp "\QuantowerKeybdBtnOn.png"))
            download("https://raw.githubusercontent.com/Seven0528/GetQuantowerKeybdBtnToggleState/main/QuantowerKeybdBtnOn.png", pathOn)
        bufNeedleOff:=ImagePutBuffer(pathOff)
        bufNeedleOn:=ImagePutBuffer(pathOn)
    }
    prevTMM:=setTitleMatchMode("RegEx")
    hWnd:=winExist("ahk_class ^HwndWrapper\[Starter")
    setTitleMatchMode(prevTMM)
    /*
    Chart
    ahk_class HwndWrapper[Starter;;0868b63c-43fa-412f-9089-77cadc9056b2]
    ahk_exe Starter.exe
    */
    if (!hWnd) || (getWindowDpiAwarenessContextIgnoringInfoFlag(hWnd)!==DPI_AWARENESS_CONTEXT_UNAWARE)
        return -2
    winGetPos(&winX, &winY, &winW, &winH, hWnd)
    if (windowDpiScale:=dllCall("User32.dll\GetDpiForWindow", "Ptr",hwnd, "UInt")/A_ScreenDPI)
        winW:=round(winW*windowDpiScale), winH:=round(winH*windowDpiScale)
    ;------------------
    hbm:=CreateDIBSection(winW, winH), hdc:=CreateCompatibleDC(), obm:=SelectObject(hdc, hbm)
    PrintWindow(hwnd, hdc)
    pHaystack:=Gdip_CreateBitmapFromHBITMAP(hbm)
    SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
    bufHaystack:=ImagePutBuffer(pHaystack)
    loop 1    {
        state:=-1
        variation:=5 ;  I thought a little variation wouldn't be necessary, but it is needed. I'm not sure why.
        if (xys:=bufHaystack.ImageSearchAll(bufNeedleOff,variation))    {
            if (xys.length)    {
                state:=0
                break
            }
        }
        if (xys:=bufHaystack.ImageSearchAll(bufNeedleOn,variation))    {
            if (xys.length)    {
                state:=1
                break
            }
        }
    }
    Gdip_DisposeImage(pHaystack)
    return state
}
