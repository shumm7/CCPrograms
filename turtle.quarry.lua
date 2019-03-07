-- Args
ARGS = {...}
length = ARGS[1]
width = ARGS[2]
depth = ARGS[3]

x=0
y=0
z=0

if width-1<1 or length-1<1 or depth-1<0 then
  print("The argument is too low!")
  os.queueEvent("terminate")
  sleep(1)
end

-- Moving
function moving()
  for j=1,width do
    for i=1,length-1 do
      turtle.dig()
      turtle.forward()

      if j%2==0 then
        x=x-1
      else
        x=x+1
      end
      print("Now on: ", x, ",", y, ",", z)
    end

    if y~=(width-1) then
      if j%2==0 then
        turtle.turnLeft()
        turtle.dig()
        turtle.forward()
        turtle.turnLeft()
      else
        turtle.turnRight()
        turtle.dig()
        turtle.forward()
        turtle.turnRight()
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

  for i=1, width-1 do
    turtle.forward()
    y=y-1
    print("Now on: ", x, ",", y, ",", z)
  end

  if x==0 then
    turtle.turnRight()
  else
    turtle.turnLeft()
    for i=1, length-1 do
      turtle.forward()
      x=x-1
      print("Now on: ", x, ",", y, ",", z)
    end
    turtle.turnRight()
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
    turtle.up()
    x_z=x_z-1
    print("Now on: ", x, ",", y, ",", x_z)
  end

  for i=1, 16 do
    turtle.select(i)
    turtle.drop(i)

  end

  for i=1, nowdepth do
    turtle.down()
    x_z=x_z+1
    print("Now on: ", x, ",", y, ",", x_z)
  end
  turtle.turnRight()
  turtle.turnRight()
  turtle.select(1)
end


function fuelerror(z)
  turtle.turnRight()
  turtle.turnRight()
  for i=1, z do
    turtle.up()
  end
  turtle.turnRight()
  turtle.turnRight()

  print("The fuel is too low!")
  os.queueEvent("terminate")
  sleep(1)
end

----------------------------

-- Mining
turtle.select(1)
print("Range: ", length, " x ", width, " x ", depth)
print("Minning start")
sleep(1)
print("Now on: ", x, ",", y, ",", z)
turtle.digDown()
turtle.down()
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
    turtle.digDown()
    turtle.down()
    z=z+1
    print("Now on: ", x, ",", y, ",", z)
  end
end

--Elevation
turtle.turnRight()
turtle.turnRight()
for i=1, depth do
  turtle.up()
end

-- Item
for i=1, 16 do
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