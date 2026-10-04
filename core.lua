--[[ KONKHMER NAK PHLIT core ]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")
local TeleportService  = game:GetService("TeleportService")
local VirtualUser      = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local env = (getgenv and getgenv()) or _G
if env.__KNP_ON then return end
env.__KNP_ON = true

if not game:IsLoaded() then
    game.Loaded:Wait()
end
task.wait(1.2)

pcall(function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

local S = {
    AutoSteal = false,
    AutoStealAll = false,
    StealBig = false,
    AutoReturn = true,
    AutoDrop = false,
    AutoPlace = false,
    AutoHatch = false,
    StealSpeed = 200,
    WSOn = false,
    WS = 32,
    JPOn = false,
    JP = 50,
    InfJump = false,
    NoClip = false,
    Fly = false,
    FlySpeed = 60,
    SlowMode = "គ្មាន",
    SlowVal = 6,
    SlowTargets = {},
}

local alive = true
local cons = {}
local function hook(c)
    cons[#cons + 1] = c
    return c
end

local function hum()
    local ch = LocalPlayer.Character
    return ch and ch:FindFirstChildOfClass("Humanoid")
end

local function root()
    local ch = LocalPlayer.Character
    return ch and ch:FindFirstChild("HumanoidRootPart")
end

local function playerList()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            t[#t + 1] = p.Name
        end
    end
    table.sort(t)
    if #t == 0 then t[1] = "(មិនមាន)" end
    return t
end

local function findPlr(name)
    return Players:FindFirstChild(name)
end

hook(RunService.RenderStepped:Connect(function(dt)
    if not alive then return end
    local h = hum()
    local r = root()
    if S.WSOn and h then
        h.WalkSpeed = S.WS
    end
    if S.JPOn and h then
        h.UseJumpPower = true
        h.JumpPower = S.JP
    end
    if S.Fly and r and h then
        h.PlatformStand = true
        local cam = Workspace.CurrentCamera
        if cam then
            local d = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then d += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then d -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then d -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then d += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then d += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then d -= Vector3.new(0, 1, 0) end
            r.AssemblyLinearVelocity = Vector3.zero
            if d.Magnitude > 0 then
                r.CFrame += d.Unit * S.FlySpeed * dt
            end
        end
    end
end))

hook(RunService.Stepped:Connect(function()
    if not alive or not S.NoClip then return end
    local ch = LocalPlayer.Character
    if not ch then return end
    for _, p in ipairs(ch:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = false
        end
    end
end))

hook(UserInputService.JumpRequest:Connect(function()
    if not alive or not S.InfJump then return end
    local h = hum()
    if h then
        h:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

task.spawn(function()
    while alive do
        task.wait(0.45)
        if S.SlowMode ~= "គ្មាន" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local ok = (S.SlowMode == "ទាំងអស់") or (S.SlowMode == "ជ្រើសរើស" and S.SlowTargets[p.UserId])
                    if ok then
                        local h = p.Character:FindFirstChildOfClass("Humanoid")
                        if h then
                            pcall(function()
                                h.WalkSpeed = S.SlowVal
                            end)
                        end
                    end
                end
            end
        end
    end
end)

local Rayfield
do
    local ok, src = pcall(game.HttpGet, game, "https://sirius.menu/rayfield")
    if not ok or type(src) ~= "string" or src == "" then
        ok, src = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua")
    end
    if ok and type(src) == "string" then
        local fn = loadstring(src)
        if fn then
            Rayfield = fn()
        end
    end
end
if not Rayfield then
    warn("[KNP] UI load failed")
    return
end

local Window = Rayfield:CreateWindow({
    Name = "KONKHMER NAK PHLIT",
    LoadingTitle = "KONKHMER NAK PHLIT",
    LoadingSubtitle = "ជំនានខ្មែរ",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KNP",
        FileName = "v3",
    },
    KeySystem = false,
    DisableRayfieldPrompts = true,
})

local function note(t, c)
    pcall(function()
        Rayfield:Notify({ Title = t, Content = c, Duration = 3 })
    end)
end

local TabHome = Window:CreateTab("ផ្ទាះ", 4483362458)
TabHome:CreateSection("ស្ថានភាព")
TabHome:CreateParagraph({
    Title = "KONKHMER NAK PHLIT",
    Content = "loader ខ្លី + core ដាច់ដោយឡែក\nPC + ទូរស័ព្ទ",
})
TabHome:CreateButton({
    Name = "ចូល Server ឡើងវិញ",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

local TabSteal = Window:CreateTab("លួច", 4483362458)
TabSteal:CreateSection("លួចស័ន")
TabSteal:CreateToggle({
    Name = "លួចស្វ័យប្រវត្តិ",
    CurrentValue = false,
    Flag = "AutoSteal",
    Callback = function(v)
        S.AutoSteal = v
        if v then S.AutoStealAll = false end
    end,
})
TabSteal:CreateToggle({
    Name = "លួចទាំងអស់",
    CurrentValue = false,
    Flag = "AutoStealAll",
    Callback = function(v)
        S.AutoStealAll = v
        if v then S.AutoSteal = false end
    end,
})
TabSteal:CreateToggle({
    Name = "លួចស័នធំ",
    CurrentValue = false,
    Flag = "StealBig",
    Callback = function(v) S.StealBig = v end,
})
TabSteal:CreateSlider({
    Name = "ល្បិហនលួច",
    Range = {50, 500},
    Increment = 10,
    Suffix = "",
    CurrentValue = 200,
    Flag = "StealSpeed",
    Callback = function(v) S.StealSpeed = v end,
})
TabSteal:CreateSection("ការគ្រប់គ្រងស័ន")
TabSteal:CreateToggle({
    Name = "ត្រឡប់មូលដ្នានស្វ័យប្រវត្តិ",
    CurrentValue = true,
    Flag = "AutoReturn",
    Callback = function(v) S.AutoReturn = v end,
})
TabSteal:CreateToggle({
    Name = "ទម្លាក់ស័នស្វ័យប្រវត្តិ",
    CurrentValue = false,
    Flag = "AutoDrop",
    Callback = function(v) S.AutoDrop = v end,
})
TabSteal:CreateToggle({
    Name = "ដាក់ស័នស្វ័យប្រវត្តិ",
    CurrentValue = false,
    Flag = "AutoPlace",
    Callback = function(v) S.AutoPlace = v end,
})
TabSteal:CreateToggle({
    Name = "ញាស់ស័នស្វ័យប្រវត្តិ",
    CurrentValue = false,
    Flag = "AutoHatch",
    Callback = function(v) S.AutoHatch = v end,
})

local TabMove = Window:CreateTab("ចលនា", 4483362458)
TabMove:CreateSection("ល្បិហន & លោត")
TabMove:CreateToggle({
    Name = "បើកល្បិហនដើរ",
    CurrentValue = false,
    Flag = "WSOn",
    Callback = function(v) S.WSOn = v end,
})
TabMove:CreateSlider({
    Name = "ល្បិហនដើរ",
    Range = {16, 200},
    Increment = 1,
    Suffix = "",
    CurrentValue = 32,
    Flag = "WS",
    Callback = function(v) S.WS = v end,
})
TabMove:CreateToggle({
    Name = "បើកកម្លាងលោត",
    CurrentValue = false,
    Flag = "JPOn",
    Callback = function(v) S.JPOn = v end,
})
TabMove:CreateSlider({
    Name = "កម្លាងលោត",
    Range = {10, 200},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "JP",
    Callback = function(v) S.JP = v end,
})
TabMove:CreateToggle({
    Name = "លោតមិនចេះអំស",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(v) S.InfJump = v end,
})
TabMove:CreateToggle({
    Name = "ឦ្លែងកាត់វត្ថុ",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(v) S.NoClip = v end,
})
TabMove:CreateSection("ហើរ")
TabMove:CreateToggle({
    Name = "ហើរ",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(v)
        S.Fly = v
        local h = hum()
        if h and not v then h.PlatformStand = false end
    end,
})
TabMove:CreateSlider({
    Name = "ល្បិហនហើរ",
    Range = {20, 160},
    Increment = 5,
    Suffix = "",
    CurrentValue = 60,
    Flag = "FlySpeed",
    Callback = function(v) S.FlySpeed = v end,
})

local TabTroll = Window:CreateTab("លេងសើច", 4483362458)
TabTroll:CreateSection("ជើងយឺត")
TabTroll:CreateDropdown({
    Name = "រប័ប Slow",
    Options = {"គ្មាន", "ទាំងអស់", "ជ្រើសរើស"},
    CurrentOption = {"គ្មាន"},
    Flag = "SlowMode",
    Callback = function(opt)
        local m = typeof(opt) == "table" and (opt[1] or "គ្មាន") or opt
        S.SlowMode = tostring(m)
        note("Slow", "រប័ប: " .. S.SlowMode)
    end,
})
TabTroll:CreateSlider({
    Name = "ល្បិហន Slow (0 = ឦរ)",
    Range = {0, 16},
    Increment = 1,
    Suffix = "",
    CurrentValue = 6,
    Flag = "SlowVal",
    Callback = function(v) S.SlowVal = v end,
})
TabTroll:CreateDropdown({
    Name = "ជ្រើសអ្នកលេង",
    Options = playerList(),
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "SlowSelect",
    Callback = function(opts)
        S.SlowTargets = {}
        if typeof(opts) ~= "table" then return end
        for _, name in ipairs(opts) do
            local p = findPlr(tostring(name))
            if p then S.SlowTargets[p.UserId] = true end
        end
    end,
})
TabTroll:CreateParagraph({
    Title = "រប័បប្រើ",
    Content = "គ្មាន = បិទ\nទាំងអស់ = slow គ្រប់គ្នា\nជ្រើសរើស = slow តែអ្នកដែលជ្រើស",
})

local TabSys = Window:CreateTab("ប្រព័ន្ធ", 4483362458)
TabSys:CreateSection("ការកំណត់")
TabSys:CreateButton({
    Name = "ចូល Server ឡើងវិញ",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})
TabSys:CreateButton({
    Name = "បិទ UI",
    Callback = function()
        alive = false
        env.__KNP_ON = nil
        for _, c in ipairs(cons) do
            pcall(function() c:Disconnect() end)
        end
        Rayfield:Destroy()
    end,
})

hook(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.End then
        alive = false
        env.__KNP_ON = nil
        for _, c in ipairs(cons) do
            pcall(function() c:Disconnect() end)
        end
        pcall(function() Rayfield:Destroy() end)
    end
end))
