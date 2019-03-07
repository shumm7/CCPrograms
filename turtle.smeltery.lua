ARGS={...}
amount=ARGS[1]
amount=amount+1
-----------------------------
for i=1, amount-1 do
  turtle.up()
  turtle.turnRight()
  turtle.turnRight()
  rs.setOutput("back", true)
  sleep(0.2)
  rs.setOutput("back", false)
  turtle.turnRight()
  turtle.turnRight()
  turtle.down()
  sleep(1)

  success=turtle.suck(1)
  while not success do
    success=turtle.suck(1)
    sleep(0.1)
  end
end