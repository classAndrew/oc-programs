
walk = 13
trees = 6 --one side of the trees

function fuelOk()
  return turtle.getFuelLevel() > walk+trees*2*6*2
end

function justRefuel()
  if not fuelOk() then
    turtle.select(2) --fuel slot
    turtle.suck()
    turtle.refuel()
    if not fuelOk() then --still not enough fuel
      print("NEF")
      sleep(1000)
    end
    turtle.select(1) -- sapling slot
  end
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
    while not turtle.detectDown() do
      turtle.down()
    end
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
  turtle.turnRight()
  turtle.turnRight()
  for i=1, walk do
    turtle.forward()
  end
  turtle.turnLeft()
end

function begin()
  while true do
    turtle.turnRight()
    justRefuel()
    turtle.turnLeft()
    turtle.turnLeft()
    treeWalk()
  end
end

begin()
