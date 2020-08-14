
walk = 13
trees = 6 --one side of the trees
CHECKTIME = 120 --seconds
sapChest = "minecraft:chest_4086"
buffer = "minecraft:chest_4091" -- This is the only field that should be edited.
fuelChest = "minecraft:chest_4089" 
outputChest = "minecraft:chest_4090" 

function fuelOk()
  return turtle.getFuelLevel() > walk+trees*2*6*2
end

function justRefuel()
  if not fuelOk() then
    local fuelchest = peripheral.wrap(fuelChest)
    for i, v in pairs(fuelchest.list()) do
      if v.name == "minecraft:coal" then
        fuelchest.pushItems(buffer, i)
        break
      end
    end
    turtle.select(2) --fuel slot
    turtle.suck()
    turtle.refuel()
    if not fuelOk() then --still not enough fuel
      print("NEF")
      sleep(1000)
    end
  end
  turtle.select(1) -- sapling slot
  if turtle.getItemCount() < 20 then
    local chest = peripheral.wrap(sapChest)
    for i, v in pairs(chest.list()) do
      if v.name == "minecraft:sapling" then
        chest.pushItems(buffer, 1)
        turtle.suck(20-turtle.getItemCount())
        peripheral.wrap(buffer).pushItems(sapChest, 1)
        break
      end
    end
  end
end

function dumpItems()
  local buf = peripheral.wrap(buffer)
  for i=2,16 do
    turtle.select(i)
    turtle.drop()
    buf.pushItems(outputChest, 1)
  end
  turtle.select(1)
end

function chopTree()
  local worked, thing = turtle.inspect()
  if worked and thing.name == "minecraft:log" then
    turtle.dig()
    turtle.forward()
    local success, block = turtle.inspectUp()
    while success and block.name=="minecraft:log" do
      turtle.digUp()
      turtle.up()
      success, block = turtle.inspectUp()
    end
    worked, thing = turtle.inspectDown()
    while worked and thing.name == "minecraft:leaves" do
      turtle.digDown()
      turtle.down()
      worked, thing = turtle.inspectDown()
    end
    while turtle.down() do end
    turtle.back()
    turtle.place()
  end
end

function treeWalk()
  for i=1,walk do
    turtle.forward()
    if i%2 == 1 then
      turtle.turnRight()
      chopTree()
      turtle.turnLeft()
      turtle.turnLeft()
      chopTree()
      turtle.turnRight()
    end
  end
  for i=1, walk do
    turtle.back()
  end
  turtle.turnRight()
end

function reState()
  local worked, wood = turtle.inspectDown()
  local worked_sap, sap = turtle.inspect()
  if worked and wood.name == "minecraft:chest" then
    return
  elseif worked_sap and (sap.name == "minecraft:sapling" or sap.name == "minecraft:log") then
    -- Handle the special case where turtle is staring at sapling or log
    turtle.turnRight() -- take a guess
    while turtle.forward() do end
    local worked_c, chest = turtle.inspect()
    if worked_c and chest.name == "minecraft:chest" then
      turtle.turnLeft()
      return
    end
  elseif worked and wood.name == "minecraft:chest" then
    -- Turtle is sitting on the chest but facing forward
    turtle.turnRight()
    return
  elseif not worked or wood.name == "minecraft:leaves" then
    while worked and wood.name == "minecraft:leaves" do 
      turtle.digDown()
      turtle.down()
      worked, wood = turtle.inspectDown()
    end --will have to break down leaves in future if grow as soon as start
    while turtle.down() do end
    turtle.forward()
    turtle.turnLeft()
    local success, block = turtle.inspectDown()
    local call = "turnLeft"
    if success and block.name == "minecraft:torch" then
      call = "turnRight"
    end  
    turtle.turnRight()
    turtle.back()
    turtle.back()
    turtle.place()
    turtle[call]()
  end
  while turtle.back() do end
  turtle.turnRight()
end

function begin()
  reState()  
  while true do
    justRefuel()
    turtle.turnLeft()
    treeWalk()
    dumpItems()
    sleep(CHECKTIME)
  end
end

begin()
