-- This one was pulled from my pastebin, it crafts sand. Replace the for i=1,10000 with a non-terminating loop
for i=1,10000,1 do
  turtle.suck(64)
  for j=1,16,1 do
    item = turtle.getItemDetail(j)
    if item and item.name=="minecraft:sand" and (j ~= 1 and j ~= 2 and j ~= 5 and j ~= 6) then
      turtle.select(j)
      turtle.drop(turtle.getItemCount(j))
    elseif item and item.name=="minecraft:sand" and (j ~= 1 and j~=2 and j~= 5 and j~= 6) then
      turtle.select(j)
      turtle.dropRight(turtle.getItemCount(j))
    end
  end
  turtle.select(1)
  slot_1 = turtle.getItemCount(1)
  split = math.floor(slot_1/4)
  turtle.transferTo(2, split)
  turtle.transferTo(5, split)
  turtle.transferTo(6, split)
  print("hi")
  turtle.craft()
  for j=1,16,1 do
    item = turtle.getItemDetail(j)
    if item and item.name == "minecraft:sandstone" then
      turtle.select(j)
      turtle.dropUp(turtle.getItemCount(j))
    end
  end
  sleep(5)
end
