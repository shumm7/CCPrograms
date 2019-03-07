ARGS = {...}
amount=ARGS[1]
size=ARGS[2]

amount=amount+1

if size-1~=1 and size-1~=2 then
  print("Argument(2) has to be 2 or 3!")
  os.queueEvent("terminate")
  sleep(1)
end

----------------------------------
--Crafting
function three()
  for i=1, amount-1 do
    for j=1, 9 do
      if j<4 then
        slot=j
      elseif j>3 and j<7 then
        slot=j+1
      else
        slot=j+2
      end

      turtle.select(slot)
      success=turtle.suckUp(1)
    end
    if success then
      turtle.craft()
      turtle.dropUp()
    else
      print("Nothing items!")
      os.queueEvent("terminate")
      sleep(1)
    end
  end
end

function two()
  for i=1, amount-1 do
    for j=1, 4 do
      if j<3 then
        slot=j
      else
        slot=j+2
      end

      turtle.select(slot)
      success=turtle.suckUp(1)
    end
    if success then
      turtle.craft()
      turtle.dropUp()
    else
      print("Nothing items!")
      os.queueEvent("terminate")
      sleep(1)
    end
  end
end


if size-1==1 then
  two()
else
  three()
end
print("Crafting Completed!")