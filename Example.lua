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

local function setupPlayer()
    setR6()
    resetPlr()
    loadReanimation()
    task.wait(0.05)
    stopAnims()
    runNet()
end

setupPlayer()

local currentAnimation = 'Masturbate'

local Animations = {
    Walking = {
        RootJoint={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=12,xrotsinespd=1,yrotsinespd=1,zrotsinespd=2,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
        ["Left Shoulder"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=-40,xrotsinespd=1,yrotsinespd=1,zrotsinespd=4,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
        ["Left Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=40,xrotsinespd=1,yrotsinespd=1,zrotsinespd=4,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
        Neck={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=6,yrot=0,zrot=0,xrotsine=4,yrotsine=0,zrotsine=0,xrotsinespd=4,yrotsinespd=1,zrotsinespd=0,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
        ["Right Shoulder"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=-40,xrotsinespd=1,yrotsinespd=1,zrotsinespd=4,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
        ["Right Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=40,xrotsinespd=1,yrotsinespd=1,zrotsinespd=4,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0}
    }
}

local origins = {}

local function wave(d, k, t)
    return (d[k] or 0) + math.sin(t * (d[k .. 'sinespd'] or 0) + (d[k .. 'sineoff'] or 0)) * (d[k .. 'sine'] or 0)
end

clean(runService.Heartbeat:Connect(function()
    local char = lplr.Character
    local pose = Animations[currentAnimation]
    if not char or not pose then
        return
    end
    local t = os.clock()
    for name, d in pose do
        local motor = char:FindFirstChild(name, true)
        if motor and motor:IsA('Motor6D') then
            origins[motor] = origins[motor] or motor.C0
            motor.C0 = origins[motor]
                * CFrame.new(wave(d, 'xpos', t), wave(d, 'ypos', t), wave(d, 'zpos', t))
                * CFrame.Angles(math.rad(wave(d, 'xrot', t)), math.rad(wave(d, 'yrot', t)), math.rad(wave(d, 'zrot', t)))
        end
    end
end))
