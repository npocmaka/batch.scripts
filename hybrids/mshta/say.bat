:speak
@echo off 
setlocal enableDelayedExpansion
set "toSay=%*"
mshta "javascript:code(close((v=new ActiveXObject('SAPI.SpVoice')).GetVoices()&&v.Speak('!toSay!')))"
endLocal
