-- It's recommended that you know Luau and how most jab scripts work/have watched the tutorial yet
-- I haven't covered much but here ya go
local playersService = game:GetService('Players')
local replicatedStorage = game:GetService('ReplicatedStorage')
local runService = game:GetService('RunService')
local userInputService = game:GetService('UserInputService')

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
local camera = workspace.CurrentCamera

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
            return humanoid.RigType == Enum.HumanoidRigType.R6
        end)
    end
end

local function permaDeath()
    runCmd('-pd', 1, function() return true end)
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



-- self.currentAnimation: What animation is playing right now
-- self.Animations: List of character animations
-- self.defaultAnimation: Fallback animation if a animation is empty (empty table)
-- self.Hats (id, name): Hats required for the animation, if you are going to use this, set "id" to the hat's id, and "name" to the hats name on your character!
-- more self.Hats: To check this, you can use dex, check your character instance, do -ch then -gh <your-hat-id>, and get the newest accessory added onto your character
-- animations: Idle, Falling, Walking, Jumping, Climbing, Sitting

local Characters = {
    TheoTemp = function() -- Love to theo, you inspire me alot so I made you a template for others to use!
        local self = {}
        self.currentAnimation = 'Idle' -- No need for modifying =)
        self.defaultAnimation = 'Idle'
        self.isRig = true -- Only turn this on when you are considering about making your player using accessory limbs (/custom rig)
        self.cameraSubject = nil -- Recommended for rigs! Set to nil for the default camera
        self.rigSize = Vector3.new(2, 6, 2)

        self.Settings = {
            WalkSpeed = 30,
            JumpPower = 0,
            CameraHeight = 2,
        }

        self.Animations = {
            Idle = {
                RootJoint={xpos=0,ypos=0,zpos=-0.1,xpossine=0,ypossine=0,zpossine=-0.1,xpossinespd=1,ypossinespd=1,zpossinespd=4,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=6,yrot=0,zrot=0,xrotsine=2,yrotsine=0,zrotsine=0,xrotsinespd=4,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Right Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-5,yrot=0,zrot=0,xrotsine=-5,yrotsine=0,zrotsine=0,xrotsinespd=4,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Left Shoulder"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-9,yrot=0,zrot=0,xrotsine=-5,yrotsine=0,zrotsine=0,xrotsinespd=4,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Right Shoulder"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-9,yrot=0,zrot=0,xrotsine=-5,yrotsine=0,zrotsine=0,xrotsinespd=4,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Left Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-5,yrot=0,zrot=0,xrotsine=-5,yrotsine=0,zrotsine=0,xrotsinespd=4,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                Neck={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=6,yrot=0,zrot=0,xrotsine=4,yrotsine=0,zrotsine=0,xrotsinespd=4,yrotsinespd=1,zrotsinespd=1,xrotsineoff=2,yrotsineoff=0,zrotsineoff=0},
                ["Accessory (NepV)"]={xpos=0,ypos=0,zpos=1,xpossine=1,ypossine=0,zpossine=0,xpossinespd=4,ypossinespd=0,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=2,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=900,xrotsinespd=1,yrotsinespd=0,zrotsinespd=0.4,xrotsineoff=0,yrotsineoff=4,zrotsineoff=2},
                ["Accessory (TrafficCone)"]={xpos=0,ypos=2.7,zpos=-0.2,xpossine=0,ypossine=-0.1,zpossine=-0.08,xpossinespd=1,ypossinespd=4,zpossinespd=4,xpossineoff=0,ypossineoff=0,zpossineoff=1,xrot=1,yrot=1,zrot=0,xrotsine=2,yrotsine=5,zrotsine=0,xrotsinespd=4,yrotsinespd=2,zrotsinespd=1,xrotsineoff=2,yrotsineoff=0,zrotsineoff=0}
            },
            Falling = {
                RootJoint={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=-10,yrotsine=0,zrotsine=0,xrotsinespd=4,yrotsinespd=1,zrotsinespd=1,xrotsineoff=2,yrotsineoff=0,zrotsineoff=0},
                ["Right Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=-30,xrotsine=0,yrotsine=0,zrotsine=10,xrotsinespd=1,yrotsinespd=1,zrotsinespd=4,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Left Hip"]={xpos=-1,ypos=0.5,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=40,xrotsine=0,yrotsine=0,zrotsine=5,xrotsinespd=1,yrotsinespd=1,zrotsinespd=4,xrotsineoff=0,yrotsineoff=0,zrotsineoff=2},
                ["Left Shoulder"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-40,yrot=30,zrot=0,xrotsine=10,yrotsine=10,zrotsine=0,xrotsinespd=4,yrotsinespd=4,zrotsinespd=1,xrotsineoff=2,yrotsineoff=1,zrotsineoff=0},
                Neck={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=25,yrot=0,zrot=0,xrotsine=2,yrotsine=0,zrotsine=0,xrotsinespd=4,yrotsinespd=1,zrotsinespd=1,xrotsineoff=7,yrotsineoff=0,zrotsineoff=0},
                ["Right Shoulder"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-40,yrot=-30,zrot=0,xrotsine=10,yrotsine=10,zrotsine=0,xrotsinespd=4,yrotsinespd=4,zrotsinespd=1,xrotsineoff=3,yrotsineoff=4,zrotsineoff=0},
                ["Accessory (NepV)"]={xpos=0,ypos=0,zpos=1,xpossine=0,ypossine=0,zpossine=0.2,xpossinespd=1,ypossinespd=1,zpossinespd=4,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=666,xrotsinespd=1,yrotsinespd=1,zrotsinespd=0.5,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Accessory (TrafficCone)"]={xpos=0,ypos=2.8,zpos=-0.2,xpossine=0,ypossine=0.1,zpossine=0.2,xpossinespd=4,ypossinespd=4,zpossinespd=4,xpossineoff=0,ypossineoff=2,zpossineoff=2,xrot=-3,yrot=0,zrot=-1,xrotsine=0,yrotsine=0,zrotsine=1,xrotsinespd=1,yrotsinespd=1,zrotsinespd=4,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0}
            },
            Walking = {
                RootJoint={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0.2,xpossinespd=1,ypossinespd=1,zpossinespd=12,xpossineoff=0,ypossineoff=0,zpossineoff=1,xrot=8,yrot=0,zrot=0,xrotsine=1,yrotsine=4,zrotsine=0,xrotsinespd=12,yrotsinespd=4,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Right Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0.3,zpossine=0,xpossinespd=1,ypossinespd=8,zpossinespd=1,xpossineoff=0,ypossineoff=1,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=30,xrotsinespd=4,yrotsinespd=1,zrotsinespd=12,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Left Shoulder"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-6,yrot=2,zrot=0,xrotsine=2,yrotsine=0,zrotsine=25,xrotsinespd=12,yrotsinespd=1,zrotsinespd=12,xrotsineoff=0,yrotsineoff=0,zrotsineoff=1},
                ["Right Shoulder"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=5,zrot=-30,xrotsine=0,yrotsine=3,zrotsine=20,xrotsinespd=4,yrotsinespd=4,zrotsinespd=4,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Left Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0.3,zpossine=0,xpossinespd=1,ypossinespd=8,zpossinespd=1,xpossineoff=0,ypossineoff=2,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=30,xrotsinespd=4,yrotsinespd=1,zrotsinespd=12,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                Neck={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=0,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-5,yrot=0,zrot=0,xrotsine=2,yrotsine=0,zrotsine=0,xrotsinespd=12,yrotsinespd=1,zrotsinespd=1,xrotsineoff=2,yrotsineoff=0,zrotsineoff=0},
                ["Accessory (NepV)"]={xpos=-1.5,ypos=-1.4,zpos=-2.5,xpossine=0.1,ypossine=0.2,zpossine=0.3,xpossinespd=4,ypossinespd=12,zpossinespd=12,xpossineoff=0,ypossineoff=1,zpossineoff=13,xrot=0,yrot=-90,zrot=5,xrotsine=0,yrotsine=0,zrotsine=2,xrotsinespd=0,yrotsinespd=0,zrotsinespd=12,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Accessory (TrafficCone)"]={xpos=-0.1,ypos=2.9,zpos=-0.3,xpossine=-0.4,ypossine=0.2,zpossine=-0.03,xpossinespd=4,ypossinespd=12,zpossinespd=12,xpossineoff=0,ypossineoff=1,zpossineoff=1,xrot=-7,yrot=0,zrot=5,xrotsine=0,yrotsine=0,zrotsine=10,xrotsinespd=4,yrotsinespd=2,zrotsinespd=4,xrotsineoff=2,yrotsineoff=0,zrotsineoff=0}
            },
            Jumping = {
                RootJoint={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=-10,yrotsine=0,zrotsine=0,xrotsinespd=4,yrotsinespd=1,zrotsinespd=1,xrotsineoff=2,yrotsineoff=0,zrotsineoff=0},
                ["Right Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=-30,xrotsine=0,yrotsine=0,zrotsine=10,xrotsinespd=1,yrotsinespd=1,zrotsinespd=4,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Left Hip"]={xpos=-1,ypos=0.5,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=40,xrotsine=0,yrotsine=0,zrotsine=5,xrotsinespd=1,yrotsinespd=1,zrotsinespd=4,xrotsineoff=0,yrotsineoff=0,zrotsineoff=2},
                ["Left Shoulder"]={xpos=0,ypos=0.5,zpos=1,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-160,yrot=30,zrot=0,xrotsine=10,yrotsine=10,zrotsine=0,xrotsinespd=4,yrotsinespd=4,zrotsinespd=1,xrotsineoff=2,yrotsineoff=1,zrotsineoff=0},
                Neck={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=12,yrot=0,zrot=0,xrotsine=2,yrotsine=0,zrotsine=0,xrotsinespd=4,yrotsinespd=1,zrotsinespd=1,xrotsineoff=7,yrotsineoff=0,zrotsineoff=0},
                ["Right Shoulder"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-40,yrot=-30,zrot=0,xrotsine=10,yrotsine=10,zrotsine=0,xrotsinespd=4,yrotsinespd=4,zrotsinespd=1,xrotsineoff=3,yrotsineoff=4,zrotsineoff=0},
                ["Accessory (NepV)"]={xpos=0,ypos=3,zpos=1,xpossine=0,ypossine=0,zpossine=0.2,xpossinespd=1,ypossinespd=1,zpossinespd=4,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=130,yrot=16,zrot=0,xrotsine=0,yrotsine=-10,zrotsine=0,xrotsinespd=1,yrotsinespd=4,zrotsinespd=1,xrotsineoff=0,yrotsineoff=2,zrotsineoff=2},
                ["Accessory (TrafficCone)"]={xpos=0,ypos=2.9,zpos=-0.2,xpossine=0,ypossine=0.1,zpossine=0.2,xpossinespd=4,ypossinespd=4,zpossinespd=4,xpossineoff=0,ypossineoff=2,zpossineoff=2,xrot=-3,yrot=0,zrot=-1,xrotsine=0,yrotsine=0,zrotsine=1,xrotsinespd=1,yrotsinespd=1,zrotsinespd=4,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0}
            },
            Climbing = {},
            Sitting = {}
        }
        self.Hats = {
            { id = 112934510372081, name = 'Accessory (NepV)' },
            { id = 75869582622966, name = 'Accessory (TrafficCone)' },
        }
        return self
    end
} -- -gh 112934510372081 75869582622966

local function findNamed(char, name)
    local base, idx = name:match('^(.-)(%d+)$')
    idx = tonumber(idx)
    if base and base ~= '' and idx and idx >= 2 then
        local count = 0
        for _, v in char:GetDescendants() do
            if v.Name == base and (v:IsA('Accessory') or v:IsA('Motor6D')) then
                count += 1
                if count == idx then
                    return v
                end
            end
        end
    end
    return char:FindFirstChild(name, true)
end

local function RunChar(char) -- You shouldn't need to worry about this function, it's basically a character handler, unless you are adding more stuff it doesn't already have
    local loadedCharacter = char

    local character = assert(Characters[loadedCharacter], 'unknown character: ' .. tostring(loadedCharacter))()

    local rigBox = nil
    local camPart = nil
    local rigLinear = nil
    local rigAlign = nil
    local rigFacing = Vector3.new(0, 0, -1)
    
    local function getHats()
        local char = lplr.Character or lplr.CharacterAdded:Wait()
        local ids = {}
        local names = {}
        for _, hat in character.Hats do
            table.insert(ids, hat.id)
            table.insert(names, hat.name)
        end
        if #ids == 0 then
            return
        end
        local started = os.clock()
        runCmd('-gh ' .. table.concat(ids, ' '), 5, function()
            if os.clock() - started > 15 then
                return true
            end
            local need = {}
            for _, name in names do
                need[name] = (need[name] or 0) + 1
            end
            for name, count in need do
                local have = 0
                for _, c in char:GetChildren() do
                    if c.Name == name then
                        have += 1
                    end
                end
                if have < count then
                    return false
                end
            end
            return true
        end)
    end
    
    local function setupPlayer()
        setR6()
        resetPlr()
        lplr.Character:WaitForChild('Humanoid').WalkSpeed = character.Settings.WalkSpeed
        getHats()
        task.wait(0.05)
        loadReanimation()
        task.wait(0.05)
        stopAnims()
        runNet()
        if character.isRig then
            task.wait(1)
            permaDeath()
            task.wait(0.8)
            task.delay(1, function()
                local subject = character.cameraSubject or camPart
                if subject then
                    camera.CameraSubject = subject
                end
                lplr.Character.Humanoid.Health = 0
            end)
        end
    end
    
    setupPlayer()
    
    local origins = {}
    
    local function wave(d, k, t)
        return (d[k] or 0) + math.sin(t * (d[k .. 'sinespd'] or 0) + (d[k .. 'sineoff'] or 0)) * (d[k .. 'sine'] or 0)
    end

    local riseSpeed = 2

    local function pickAnimation(humanoid, root)
        if humanoid.Sit then
            return 'Sitting'
        end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Climbing then
            return 'Climbing'
        end
        if state == Enum.HumanoidStateType.Jumping then
            return 'Jumping'
        end
        if state == Enum.HumanoidStateType.Freefall then
            if root.AssemblyLinearVelocity.Y > riseSpeed then
                return 'Jumping'
            end
            return 'Falling'
        end
        if humanoid.MoveDirection.Magnitude > 0.1 then
            return 'Walking'
        end
        return 'Idle'
    end

    local groundParams = RaycastParams.new()
    groundParams.FilterType = Enum.RaycastFilterType.Exclude

    local function buildRig()
        local source = lplr.Character and lplr.Character:FindFirstChild('HumanoidRootPart')
        local spawnPosition = source and source.Position or Vector3.new(0, 10, 0)
        local _, spawnYaw = (source and source.CFrame or CFrame.new()):ToOrientation()

        local box = Instance.new('Part')
        box.Name = 'RigBox'
        box.Size = character.rigSize or Vector3.new(2, 6, 2)
        box.Transparency = 1
        box.CanCollide = true
        box.CanQuery = false
        box.CanTouch = false
        box.CustomPhysicalProperties = PhysicalProperties.new(1, 0, 0, 100, 100)
        box.CFrame = CFrame.new(spawnPosition) * CFrame.Angles(0, spawnYaw, 0)
        rigFacing = box.CFrame.LookVector

        camPart = clean(Instance.new('Part'))
        camPart.Anchored = true
        camPart.Transparency = 1
        camPart.CanCollide = false
        camPart.Parent = workspace
        clean(runService.Heartbeat:Connect(function()
            camPart.Position = box.Position + Vector3.new(0, character.Settings.CameraHeight, 0)
        end))

        local attachment = Instance.new('Attachment')
        attachment.Parent = box

        rigLinear = Instance.new('LinearVelocity')
        rigLinear.Attachment0 = attachment
        rigLinear.RelativeTo = Enum.ActuatorRelativeTo.World
        rigLinear.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
        rigLinear.PrimaryTangentAxis = Vector3.xAxis
        rigLinear.SecondaryTangentAxis = Vector3.zAxis
        rigLinear.PlaneVelocity = Vector2.zero
        rigLinear.MaxForce = math.huge
        rigLinear.Parent = box

        rigAlign = Instance.new('AlignOrientation')
        rigAlign.Mode = Enum.OrientationAlignmentMode.OneAttachment
        rigAlign.Attachment0 = attachment
        rigAlign.RigidityEnabled = false
        rigAlign.MaxTorque = math.huge
        rigAlign.Responsiveness = 30
        rigAlign.CFrame = box.CFrame.Rotation
        rigAlign.Parent = box

        local realChar = lplr.Character
        if realChar then
            local function ignorePart(part)
                if part:IsA('BasePart') then
                    local constraint = Instance.new('NoCollisionConstraint')
                    constraint.Part0 = box
                    constraint.Part1 = part
                    constraint.Parent = box
                end
            end
            for _, part in realChar:GetDescendants() do
                ignorePart(part)
            end
            clean(realChar.DescendantAdded:Connect(ignorePart))
        end

        box.Parent = workspace
        rigBox = clean(box)
    end

    local function stepRig()
        local cam = workspace.CurrentCamera
        local typing = userInputService:GetFocusedTextBox() ~= nil
        local forward = 0
        local side = 0
        local jumpHeld = false

        if not typing then
            if userInputService:IsKeyDown(Enum.KeyCode.W) then forward += 1 end
            if userInputService:IsKeyDown(Enum.KeyCode.S) then forward -= 1 end
            if userInputService:IsKeyDown(Enum.KeyCode.D) then side += 1 end
            if userInputService:IsKeyDown(Enum.KeyCode.A) then side -= 1 end
            jumpHeld = userInputService:IsKeyDown(Enum.KeyCode.Space)
        end

        local move = Vector3.zero
        if cam then
            local look = cam.CFrame.LookVector * Vector3.new(1, 0, 1)
            local right = cam.CFrame.RightVector * Vector3.new(1, 0, 1)
            if look.Magnitude > 0.001 then look = look.Unit end
            if right.Magnitude > 0.001 then right = right.Unit end
            move = look * forward + right * side
        end

        if move.Magnitude > 0.001 then
            move = move.Unit
            rigFacing = move
        else
            move = Vector3.zero
        end

        local settings = character.Settings or {}
        local speed = settings.WalkSpeed or 16
        rigLinear.PlaneVelocity = Vector2.new(move.X * speed, move.Z * speed)
        rigAlign.CFrame = CFrame.lookAt(Vector3.zero, rigFacing)

        groundParams.FilterDescendantsInstances = {rigBox, lplr.Character}
        local grounded = workspace:Raycast(
            rigBox.Position,
            Vector3.new(0, -(rigBox.Size.Y / 2 + 0.3), 0),
            groundParams
        ) ~= nil

        local jumpPower = settings.JumpPower or 50
        local velocity = rigBox.AssemblyLinearVelocity
        if grounded and jumpHeld and velocity.Y < jumpPower * 0.5 then
            rigBox.AssemblyLinearVelocity = Vector3.new(velocity.X, jumpPower, velocity.Z)
        end

        return move.Magnitude > 0, grounded
    end

    local function pickRigAnimation(moving, grounded)
        if not grounded then
            if rigBox.AssemblyLinearVelocity.Y > riseSpeed then
                return 'Jumping'
            end
            return 'Falling'
        end
        if moving then
            return 'Walking'
        end
        return 'Idle'
    end

    if character.isRig then
        buildRig()
    end
    
    local freed = setmetatable({}, {__mode = 'k'})
    
    local smooth = setmetatable({}, {__mode = 'k'})
    local seen = {}
    
    clean(runService.Heartbeat:Connect(function(dt)
        local blendSpeed = character.Settings.AnimationBlending
        local char = lplr.Character
        local root = character.isRig and rigBox or (char and char:FindFirstChild('HumanoidRootPart'))
        if not char or not root then return end

        local moving, grounded = false, true
        if character.isRig and rigBox then
            moving, grounded = stepRig()
        end

        if character.autoAnimate ~= false then
            if character.isRig and rigBox then
                character.currentAnimation = pickRigAnimation(moving, grounded)
            else
                local humanoid = char:FindFirstChildOfClass('Humanoid')
                if humanoid then
                    character.currentAnimation = pickAnimation(humanoid, root)
                end
            end
        end

        local pose = character.Animations[character.currentAnimation]
        if not pose or next(pose) == nil then
            pose = character.Animations[character.defaultAnimation]
        end
        pose = pose or {}

        table.clear(seen)
        local t = os.clock()
        local alpha = 1 - math.exp(-dt * blendSpeed)
        for name, d in pose do
            local inst = findNamed(char, name)
            if inst then
                seen[inst] = true
                local cf = CFrame.new(wave(d, 'xpos', t), wave(d, 'ypos', t), wave(d, 'zpos', t))
                    * CFrame.Angles(math.rad(wave(d, 'xrot', t)), math.rad(wave(d, 'yrot', t)), math.rad(wave(d, 'zrot', t)))
                local prev = smooth[inst] or (inst:IsA('Motor6D') and CFrame.identity)
                if prev then
                    cf = prev:Lerp(cf, alpha)
                end
                smooth[inst] = cf
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

        for inst, prev in smooth do
            if not seen[inst] and inst.Parent and inst:IsA('Motor6D') and origins[inst] then
                local cf = prev:Lerp(CFrame.identity, alpha)
                smooth[inst] = cf
                inst.C0 = origins[inst] * cf
            end
        end
    end))
end

RunChar('TheoTemp') -- Replace this with your actual character!
