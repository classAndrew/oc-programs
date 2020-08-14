size = 14*14 --Used for fuel requirement
R_MRK = "minecraft:stone"
L_MRK = "minecraft:cobblestone"
function justRefuel()
  if turtle.getFuelLevel() < size+30 then
    turtle.turnLeft()
    turtle.select(2)
    turtle.suck()
    turtle.refuel()
    turtle.select(1)
    turtle.turnRight()
  end
end

function tryHarvest()
  local res,block = turtle.inspectDown()
  if res and block.metadata == 7 then
    turtle.digDown()
  end
  turtle.placeDown()
end

function unload()
  for i=2,16 do
    turtle.select(i)
    turtle.dropDown()
  end
  turtle.select(1)
end

function reposition()
  local res, block = turtle.inspect()
  if res and block.name == "minecraft:chest" then
    unload()
    turtle.turnRight()
    return
  end
  turtle.turnRight()
  local ri, val = turtle.inspect()
  turtle.turnLeft()
  if ri then
    turtle.forward()
    turtle.turnLeft()
  end
  turtle.turnLeft()
  local le, val = turtle.inspect()
  turtle.turnRight()
  if le and val.name ~= "minecraft:chest" then
    turtle.forward()
    turtle.turnRight()
  end
end

function begin()
  reposition()
  while true do
    justRefuel()
    while turtle.forward() do 
      tryHarvest()
    end
    local res, block = turtle.inspect()
    if res and block.name == R_MRK then
      turtle.turnRight()
      turtle.forward()
      tryHarvest()
      turtle.turnRight()
    elseif res and block.name == L_MRK then
      turtle.turnLeft()
      turtle.forward()
      tryHarvest()
      turtle.turnLeft()
    elseif res and block.name == "minecraft:planks" then
      turtle.turnRight()
      while turtle.forward() do end
      turtle.turnRight()
      unload()
      sleep(60*60)
    end
  end
end

begin()
