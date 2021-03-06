Flow = {}
local Flows = {}
local e = {}
local function newObject(value)
	local haschange = false 
	return function(action,v,on) 
		if action == 'get' then 
			return value 
		elseif action == 'set' then 
			if value ~= v then 
				if (on or e).change then 
					on.change(value,v) 
				end 
				haschange = true
				value = v 
				
			else 
				if (on or e).same then 
					on.same(value,v) 
				end 
				haschange = false 
			end 
		elseif action == 'has' then 
			return value ~= nil
		elseif action == 'haschange' then 
			local r = haschange
			haschange = false 
			return r
		else 
			error "invalid action"
		end 
	end 
end 

Flow.CheckNative = function(name,fn,...)
	local cb
	local on = {}
	local opts = {...}
	local lastopts = opts[#opts] 
	if type(lastopts) == 'function' then 
		
		cb = lastopts
		table.remove(opts,#opts)
		if not Flows[name] then 
			Flows[name] = newObject(fn(table.unpack(opts))) 
		end
		cb(on)
		if on.change or on.same then 
			Flows[name]('set',fn(table.unpack(opts)),on)
		end 
	end 
	
end 

Flow.Check = function(name,value,cb)
	local on = {}

	if not Flows[name] then 
		Flows[name] = newObject(value)
	end
	cb(on)
	if on.change or on.same then 
		Flows[name]('set',value,on)
	end 
end 
Flow.CheckValue = Flow.Check
