print("STOP: Redstone Signal")

while (not redstone.getInput("right")) and (not redstone.getInput("left")) and (not redstone.getInput("back")) do
  for i=1, 16 do
	turtle.suckUp()
    turtle.select(i)
    turtle.dropDown()
  end
end