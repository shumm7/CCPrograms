print("Terminate program: CTRL+T")
itemnum=8
print("Iten Amount: ",itemnum)

for i=1,16 do
 turtle.select(i)
  turtle.drop()
 end

sleep(1)
slot=1
turtle.select(slot)

----------------------------------
--Crafting
while 0 do
 sleep(1)
 
 slot=turtle.getSelectedSlot()
 while slot<12 do
  success,errormsg=turtle.suckDown(itemnum)
  
  if turtle.getItemCount(slot)<itemnum then
   nowitemnum=turtle.getItemCount(slot)
   print("Items are too few: slot ",slot,", amount ",nowitemnum)
   
   while nowitemnum<=itemnum-1 do
    sleep(1)
    nowitemnum=turtle.getItemCount(slot)
    sleep(1)
    success,errormsg=turtle.suckDown(itemnum-nowitemnum)
   end
  end
  
  if success then
   slot=slot+1
   if slot==4 then
    slot=5
   elseif slot==8 then
    slot=9
   end
  end
  
  turtle.select(slot)
 end
 
 turtle.select(11)
 success,errormsg=turtle.craft(8)
 sleep(1)
 
 if success==false then
  for i=1,16 do
  turtle.select(i)
   turtle.drop()
  end
 else
  turtle.drop()
 end
 
 
 turtle.select(1)
end