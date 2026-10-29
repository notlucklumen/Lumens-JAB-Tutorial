local playersService = game:GetService('Players')
local replicatedStorage = game:GetService('ReplicatedStorage')
local runService = game:GetService('RunService')

-- clean system for multiple executions
if shared.garbageCan then
    for _, obj in shared.garbageCan do
        pcall(function() obj:Disconnect() end)
        pcall(function() obj:Destroy() end)
    end
end
shared.garbageCan = {}
local function clean(obj)
    table.insert(shared.garbageCan, obj)
    return obj
end

local lplr = playersService.LocalPlayer

local cmdRemote = replicatedStorage:WaitForChild('01_server')

local function runCmd(cmd, repDur, expected)
    cmd = '-'..cmd:gsub('-','')
    local start = os.clock()
    local function run()
        cmdRemote:FireServer('cmd', cmd)
    end
    run()
    repeat
        if os.clock() - start > repDur then
            start = os.clock()
            run()
        end
        task.wait()
    until expected()
    task.wait(0.25)
end

local function setR6()
    local char = lplr.Character or lplr.CharacterAdded:Wait()
    local humanoid = char:WaitForChild('Humanoid')

    if humanoid.RigType == Enum.HumanoidRigType.R15 then
        runCmd('-r6', 0.6, function()
            return humanoid.HumanoidRigType == HumanoidEnum.RigType.R6
        end)
    end
end

local function runNet()
    runCmd('-net', 1, function() return true end)
end

local function resetPlr()
    local char = lplr.Character or lplr.CharacterAdded:Wait()
    runCmd('-rs', 0.6, function()
        return char ~= lplr.Character
    end)
end

local function loadReanimation()
    local char = lplr.Character or lplr.CharacterAdded:Wait()
    local url = 'https://raw.githubusercontent.com/notlucklumen/LumensLerping/refs/heads/main/MyWorldsReanimate.lua'
    loadstring(game:HttpGet(url))()
    char:WaitForChild('MoonConvertRealChar')
end

local function stopAnims()
    local char = lplr.Character or lplr.CharacterAdded:Wait()
    char:WaitForChild('Animate'):Destroy()
    for _, anim in char:WaitForChild('Humanoid'):WaitForChild('Animator'):GetPlayingAnimationTracks() do
        anim:Stop()
    end
end

-- Set ID to the hats ID, set name to the hats name when equipped in-game
local Hats = {
    { id = 14978538306, name = 'Accessory (Meshes/sword2Accessory)' }
}

local function getHats()
    local char = lplr.Character or lplr.CharacterAdded:Wait()
    local ids = {}
    local names = {}
    for _, hat in Hats do
        table.insert(ids, hat.id)
        table.insert(names, hat.name)
    end
    local started = os.clock()
    runCmd('-gh ' .. table.concat(ids, ' '), 5, function()
        if os.clock() - started > 15 then
            return true
        end
        for _, name in names do
            if not char:FindFirstChild(name) then
                return false
            end
        end
        return true
    end)
end

local function setupPlayer()
    setR6()
    resetPlr()
    getHats()
    task.wait(0.05)
    loadReanimation()
    task.wait(0.05)
    stopAnims()
    runNet()
end

setupPlayer()

local currentAnimation = 'Sword'

local Animations = {
    Sword = {
        RootJoint={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-6,yrot=0,zrot=0,xrotsine=6,yrotsine=0,zrotsine=0,xrotsinespd=2,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
        ["Right Shoulder"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0.1,zpossine=0,xpossinespd=1,ypossinespd=2,zpossinespd=1,xpossineoff=0,ypossineoff=1,zpossineoff=0,xrot=0,yrot=55,zrot=50,xrotsine=0,yrotsine=0,zrotsine=0,xrotsinespd=1,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
        ["Right Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=2,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=0,xrotsinespd=1,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
        Neck={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=10,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=0,xrotsinespd=1,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
        ["Left Shoulder"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0.1,zpossine=0,xpossinespd=1,ypossinespd=2,zpossinespd=1,xpossineoff=0,ypossineoff=2,zpossineoff=4,xrot=0,yrot=0,zrot=15,xrotsine=0,yrotsine=0,zrotsine=15,xrotsinespd=1,yrotsinespd=1,zrotsinespd=2,xrotsineoff=0,yrotsineoff=0,zrotsineoff=4},
        ["Left Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=2,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=0,xrotsinespd=1,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
        ["Accessory (Meshes/sword2Accessory)"]={xpos=0.5,ypos=1,zpos=-2,xpossine=0,ypossine=0.1,zpossine=0,xpossinespd=1,ypossinespd=2,zpossinespd=1,xpossineoff=0,ypossineoff=2,zpossineoff=0,xrot=0,yrot=77,zrot=190,xrotsine=0,yrotsine=0,zrotsine=0,xrotsinespd=1,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0}
    }
}

local origins = {}

local function wave(d, k, t)
    return (d[k] or 0) + math.sin(t * (d[k .. 'sinespd'] or 0) + (d[k .. 'sineoff'] or 0)) * (d[k .. 'sine'] or 0)
end

local freed = setmetatable({}, {__mode = 'k'})

clean(runService.Heartbeat:Connect(function()
    local char = lplr.Character
    local pose = Animations[currentAnimation]
    local root = char and char:FindFirstChild('HumanoidRootPart')
    if not root or not pose then return end
    local t = os.clock()
    for name, d in pose do
        local inst = char:FindFirstChild(name, true)
        if inst then
            local cf = CFrame.new(wave(d, 'xpos', t), wave(d, 'ypos', t), wave(d, 'zpos', t))
                * CFrame.Angles(math.rad(wave(d, 'xrot', t)), math.rad(wave(d, 'yrot', t)), math.rad(wave(d, 'zrot', t)))
            if inst:IsA('Motor6D') then
                origins[inst] = origins[inst] or inst.C0
                inst.C0 = origins[inst] * cf
            elseif inst:IsA('Accessory') then
                local handle = inst:FindFirstChild('Handle')
                if handle then
                    if not freed[handle] then
                        freed[handle] = true
                        local weld = handle:FindFirstChild('AccessoryWeld')
                        if weld then
                            weld:Destroy()
                        end
                        handle.CanCollide = false
                        handle.Massless = true
                    end
                    handle.CFrame = root.CFrame * cf
                    handle.AssemblyLinearVelocity = Vector3.zero
                    handle.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    end
end))
