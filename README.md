# FlowDetector
FlowDetector utilities for FXServer

[INSTALLATION]

Set it as a dependency in you fxmanifest.lua
and
```
client_script '@flowdetector/flowdetector.lua'
```
[FUNCTIONS]
```
FlowCheckCreate(name,defaultValue)        --to create a detector to follow a value's changing
FlowCheck(name,inputValue)                --input a value into the detector


FlowCheckDelete(name)                     --waste the detector


FlowOnInitialise(name,thefirstValue)      --when the value is from undefined to a newervalue 
FlowOnSame(name)                          --when the newervalue is the same from oldervalue
FlowOnChange(name,fromValue,toValue)      --when the oldervalue become a new value 
```

[EXAMPLE] [cfx-switchcase by negbook](https://github.com/negbook/cfx-switchcase/blob/main/cfx-switchcase.lua)
```
function FlowOnChange(name,fromValue,toValue)
	local case = {} --cfx-switchcase by negbook 
    local switch = setmetatable({},{__call=function(a,b)case=setmetatable({},{__call=function(a,b)return a[b]end,__index=function(a,c)return c and c==b and setmetatable({},{__call=function(a,d)d()end})or function()end end})return a[b]end,__index=function(a,c)return setmetatable({},{__call=function(a,...)end})end})
    switch(name)(
        case('coords')(function()
            print('Position Updated:from ('..type(fromValue)..') '..tostring(fromValue)..'  to ('..type(toValue)..') '..tostring(toValue))
        end),
        case('health')(function()
            print('Health Updated:from ('..type(fromValue)..') '..tostring(fromValue)..'  to ('..type(toValue)..') '..tostring(toValue))
        end)
    )
end 
FlowCheckCreate('health',"hello")
CreateThread(function()
    
    while true do Wait(1000)
        FlowCheck('coords',GetEntityCoords(PlayerPedId()))
        FlowCheck('health',GetEntityHealth(PlayerPedId()))
    end 
end)
```