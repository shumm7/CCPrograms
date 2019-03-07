ARGS={...}
height=ARGS[2]
width=ARGS[1]
depth=ARGS[3]


x=0
y=0
z=0

if width-1<1 or height-1<1 or depth-1<0 then
  print("The argument is too low!")
  os.queueEvent("terminate")
  sleep(1)
end

if height*width*depth>1216 then
  print("The argument is too high!")
  os.queueEvent("terminate")
  sleep(1)
end

-----------------------------

-- Moving
function moving()
  for j=1,height do
    for i=1,width-1 do
      turtle.dig()
      turtle.forward()

      if j%2==0 then
        x=x-1
      else
        x=x+1
      end
      print("Now on: ", x, ",", y, ",", z)
    end

    if y~=(height-1) then
      if j%2==0 then
        turtle.turnRight()
        turtle.turnRight()
        turtle.digUp()
        turtle.up()
      else
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.digUp()
        turtle.up()
      end
      y=y+1
    end
    print("Now on: ", x, ",", y, ",", z)
  end

  if y%2==0 then
    turtle.turnLeft()
  else
    turtle.turnRight()
  end

  for i=1, height-1 do
    turtle.down()
    y=y-1
    print("Now on: ", x, ",", y, ",", z)
  end

  if x==0 then
    turtle.turnRight()
  else
    turtle.turnLeft()
    for i=1, width-1 do
      turtle.forward()
      x=x-1
      print("Now on: ", x, ",", y, ",", z)
    end
    turtle.turnRight()
  end
end

function itemfull(z)
  nowdepth=z
  x_z=z
  y=0
  x=0

  turtle.turnRight()
  turtle.turnRight()
  for i=1, nowdepth do
    turtle.forward()
    x_z=x_z-1
    print("Now on: ", x, ",", y, ",", x_z)
  end

  for i=1, 16 do
    turtle.select(i)
    turtle.drop(i)
  end

  turtle.turnRight()
  turtle.turnRight()
  for i=1, nowdepth do
    turtle.forward()
    x_z=x_z+1
    print("Now on: ", x, ",", y, ",", x_z)
  end
  turtle.select(2)
end

function fuelerror(z)
  turtle.turnRight()
  turtle.turnRight()
  for i=1, z do
    turtle.forward()
  end
  turtle.turnRight()
  turtle.turnRight()

  print("The fuel is too low!")
  os.queueEvent("terminate")
  sleep(1)
end
----------------------------

-- Mining
turtle.select(2)
print("Range: ", height, " x ", width, " x ", depth)
print("Minning start")
sleep(1)
print("Now on: ", x, ",", y, ",", z)
turtle.dig()
turtle.forward()
turtle.turnRight()
z=z+1
print("Now on: ", x, ",", y, ",", z)

for i=1, depth do
  moving()

  if turtle.getItemCount(15)>0 then
    itemfull(z)
  end

  if turtle.getFuelLevel()<40+depth then
    fuelerror(z)
  end

  if i-1~=depth-1 then
    turtle.dig()
    turtle.forward()
    turtle.turnRight()
    z=z+1
    print("Now on: ", x, ",", y, ",", z)
  end
end

--Finish
turtle.turnRight()
turtle.turnRight()
for i=1, depth do
  turtle.forward()
end

-- Item
for i=2, 16 do
  turtle.select(i)
  turtle.drop()
end
turtle.select(1)

turtle.turnRight()
turtle.turnRight()
turtle.turnRight()
turtle.forward()
turtle.turnRight()
turtle.dig()
turtle.forward()

print("Mining has ended!")