print("Terminate the program: CTRL+T")
 
while 0 do
 sleep(1)
 tf,data=turtle.inspect()
 
 if tf==true then
  if data.name=="Botania:livingrock" then
   print(data.name, ": detected")
   sleep(5)
   rs.setOutput("bottom",true)
   sleep(1)
   rs.setOutput("bottom",false)
  end
 end
end