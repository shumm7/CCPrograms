function divide(string, key)
	local str = string
	local i = 1
	local ret = {}

	while string.find(str, key)~=nil do
		pos = string.find(str, key)
		table.insert(ret, string.sub(str,i,pos-1))
		i=pos+string.len(key)
		str = string.sub(str, i)
		i=1
	end

	table.insert(ret, str)
	return ret
end

function round(n)
	c = math.floor(n)
	if (n-c) * 10  >= 5 then
		return c+1
	elseif (n-c) * 10  < 5 then
		return c
	end
end

function limit(n, max, min)
	if n>max then
		return max
	elseif n<min then
		return min
	end
	return n
end

function limit_overflow(n, max, min)
	if n>max then
		return min
	elseif n<min then
		return max
	end
	return n
end

function divideCnt(string, count)
	local t,text = string, {}
	repeat
		if string.len(t)>count then
			table.insert(text, string.sub(t,1,count))
			t=string.sub(t,count+1)
		else
			table.insert(text, string.sub(t,1))
			t=""
		end
	until string.len(t)==0

	return text
end

function insert(string, position, text)
	local ret = ""
	ret = string.sub(string, 1, position)..text..string.sub(string, position+1)
	return ret
end

function table_shift(table, shift)
	local t,ret = table, {}

	if t==nil then
		return
	end

	for i=1, #t do
		ret[i+shift] = t[i]
	end

	return ret
end

function table_remove(table, index)
	t = table
	if t[index]==nil then
		return
	end
	if #t==1 then
		return
	end

	t[index] = nil
	for i=index+1, #t do
		t[i-1] = t[i]
	end
	t[#t] = nil

	return t
end

function table_insert(table, index, content)
	local t = table
	if t==nil then
		return
	end

	for i=index+1, #t do
		t[i] = t[i-1]
	end
	t[index]=content
	
	return t
end
