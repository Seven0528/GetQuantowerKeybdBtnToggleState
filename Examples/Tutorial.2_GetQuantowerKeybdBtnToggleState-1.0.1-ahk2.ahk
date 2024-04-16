#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <GetQuantowerKeybdBtnToggleState-1.0.1-ahk2>
pToken:=Gdip_Startup(), onExit((*)=>Gdip_Shutdown(pToken))

F5::  {
    state := getQuantowerKeybdBtnToggleState()
    tooltip "state: " state
    /*
    -2      The window cannot be found.
    -1      Unknown
    0       Off
    1       On
    */
}
