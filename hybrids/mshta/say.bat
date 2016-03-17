:speak
@echo off 
setlocal enableDelayedExpansion
set "toSay=%~1"
mshta "javascript:code(close((v=new ActiveXObject('SAPI.SpVoice')).GetVoices()&&v.Speak('!toSay!')))"
endLocal
