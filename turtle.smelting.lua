-- Args
ARGS={...}
amount=ARGS[1]
fuel=ARGS[2]
item=0
amount=amount+1

if amount-1>64 then
  os.queueEvent("terminate")
  sleep(1)
end

if fuel~="true" and fuel~="false" then
  os.queueEvent("terminate")
  sleep(1)
end

------------------------
-- Smelting
turtle.up()
turtle.dig()
turtle.forward()

turtle.select(1)
turtle.dropDown(amount-1)
print("Items were set (Amount: ", amount-1, ")")

turtle.turnRight()
turtle.dig()
turtle.forward()
turtle.digDown()
turtle.down()

if fuel then
  turtle.turnRight()
  turtle.turnRight()
  turtle.select(2)
  turtle.drop()
  print("Fuel were set")
  turtle.turnRight()
  turtle.turnRight()
end

turtle.digDown()
turtle.down()
turtle.turnRight()
turtle.turnRight()
turtle.dig()
turtle.forward()

while item~=(amount-1) do
  success=turtle.suckUp()
  if success then
    item=item+1
    print("Item Received: ", item)
  end
  sleep(0.1)
end
print("Smelting Completed")