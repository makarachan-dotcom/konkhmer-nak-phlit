--[[
    KONKHMER NAK PHLIT  v2
    Steal An Egg | ជំនាន់ខ្មែរ
    UI: Rayfield | Mobile friendly | No bobloscript
]]

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Workspace         = game:GetService("Workspace")
local VirtualUser       = game:GetService("VirtualUser")
local TeleportService   = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local genv = (getgenv and getgenv()) or _G

if genv.__KONKHMER_RUNNING then return end
genv.__KONKHMER_RUNNING = true

-- ========== Anti AFK ==========
pcall(function()
    for _, c in ipairs(getconnections(LocalPlayer.Idled)) do
        pcall(function() c:Disable() end)
    end
end)
pcall(function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- ========== State ==========
local State = {
    -- Steal
    AutoSteal      = false,
    AutoStealAll   = false,
    StealBigEggs   = false,
    AutoReturn     = true,
    AutoDrop       = false,
    AutoPlace      = false,
    AutoHatch      = false,
    StealSpeed     = 200,
    -- Movement
    WalkSpeedOn    = false,
    WalkSpeed      = 32,
    JumpPowerOn    = false,
    JumpPower      = 50,
    InfJump        = false,
    NoClip         = false,
    Fly            = false,
    FlySpeed       = 60,
    -- Slow
    SlowMode       = "គ្មាន",
    SlowValue      = 6,
    SlowTargets    = {},
    -- System
    AntiAfk        = true,
}

local Connections = {}
local function track(c)
    table.insert(Connections, c)
    return c
end

local function getHum()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function buildPlayerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name .. "  [" .. p.UserId .. "]")
        end
    end
    table.sort(list)
    return list
end

local function nameFromEntry(entry)
    return entry:match("^(.-)%s+%[") or entry
end

local function findPlayerByName(name)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == name then return p end
    end
    return nil
end

-- ========== Core loops ==========
track(RunService.RenderStepped:Connect(function(dt)
    if not genv.__KONKHMER_RUNNING then return end
    local hum  = getHum()
    local root = getRoot()

    if State.WalkSpeedOn and hum then
        hum.WalkSpeed = State.WalkSpeed
    end
    if State.JumpPowerOn and hum then
        hum.UseJumpPower = true
        hum.JumpPower = State.JumpPower
    end

    if State.Fly and root and hum then
        hum.PlatformStand = true
        local cam = Workspace.CurrentCamera
        if cam then
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
            root.AssemblyLinearVelocity = Vector3.zero
            if dir.Magnitude > 0 then
                root.CFrame += dir.Unit * State.FlySpeed * dt
            end
        end
    end
end))

track(RunService.Stepped:Connect(function()
    if not genv.__KONKHMER_RUNNING or not State.NoClip then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end))

track(UserInputService.JumpRequest:Connect(function()
    if not genv.__KONKHMER_RUNNING or not State.InfJump then return end
    local hum = getHum()
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

-- Slow loop
task.spawn(function()
    while genv.__KONKHMER_RUNNING do
        task.wait(0.35)
        if State.SlowMode == "គ្មាន" then
            -- skip
        else
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local should = false
                    if State.SlowMode == "ទាំងអស់" then
                        should = true
                    elseif State.SlowMode == "ជ្រើសរើស" then
                        should = State.SlowTargets[plr.UserId] == true
                    end
                    if should and plr.Character then
                        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                        if hum then
                            pcall(function() hum.WalkSpeed = State.SlowValue end)
                        end
                    end
                end
            end
        end
    end
end)

-- Steal placeholder loop
task.spawn(function()
    while genv.__KONKHMER_RUNNING do
        task.wait(0.4)
        if not (State.AutoSteal or State.AutoStealAll) then
            -- idle
        else
            -- remote bind point for live egg steal
        end
    end
end)

-- ========== Rayfield ==========
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name = "KONKHMER NAK PHLIT",
    LoadingTitle = "KONKHMER NAK PHLIT",
    LoadingSubtitle = "ជំនាន់ខ្មែរ | Steal An Egg",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KONKHMER",
        FileName = "NAK_PHLIT_V2"
    },
    KeySystem = false,
})

Rayfield:Notify({
    Title = "KONKHMER NAK PHLIT",
    Content = "ផ្ទុករួចរាល់ ✓",
    Duration = 4,
})

local function notify(title, content)
    pcall(function()
        Rayfield:Notify({ Title = title, Content = content, Duration = 3 })
    end)
end

-- =========================================================
-- TAB 1 : ផ្ទះ
-- =========================================================
local TabHome = Window:CreateTab("ផ្ទះ", 4483362458)
TabHome:CreateSection("ស្ថានភាព")

TabHome:CreateParagraph({
    Title = "KONKHMER NAK PHLIT",
    Content = "ជំនាន់ខ្មែរ | UI Rayfield\nមិនភ្ជាប់ bobloscript\nសម្រាប់ PC + ទូរស័ព្ធ",
})

TabHome:CreateButton({
    Name = "ចូល Server ឡើងវិញ",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

-- =========================================================
-- TAB 2 : លួច  (Steal panel – Chili style layout)
-- =========================================================
local TabSteal = Window:CreateTab("លួច", 4483362458)

TabSteal:CreateSection("លួចស៊ុត")

TabSteal:CreateToggle({
    Name = "លួចស្វ័យប្រវត្តិ (Auto Steal)",
    CurrentValue = false,
    Flag = "AutoSteal",
    Callback = function(v)
        State.AutoSteal = v
        if v then State.AutoStealAll = false end
        notify("លួច", v and "បើក Auto Steal" or "បិទ Auto Steal")
    end,
})

TabSteal:CreateToggle({
    Name = "លួចទាំងអស់ (Auto Steal All)",
    CurrentValue = false,
    Flag = "AutoStealAll",
    Callback = function(v)
        State.AutoStealAll = v
        if v then State.AutoSteal = false end
        notify("លួច", v and "បើក Steal All" or "បិទ Steal All")
    end,
})

TabSteal:CreateToggle({
    Name = "លួចស៊ុតធំ (Big Eggs)",
    CurrentValue = false,
    Flag = "StealBigEggs",
    Callback = function(v) State.StealBigEggs = v end,
})

TabSteal:CreateSlider({
    Name = "ល្បឿនលួច (Steal Speed)",
    Range = {50, 500},
    Increment = 10,
    Suffix = "",
    CurrentValue = 200,
    Flag = "StealSpeed",
    Callback = function(v) State.StealSpeed = v end,
})

TabSteal:CreateSection("ការគ្រប់គ្រងស៊ុត")

TabSteal:CreateToggle({
    Name = "ត្រឡប់មូលដ្ឋានស្វ័យប្រវត្តិ (Auto Return)",
    CurrentValue = true,
    Flag = "AutoReturn",
    Callback = function(v) State.AutoReturn = v end,
})

TabSteal:CreateToggle({
    Name = "ទម្លាក់ស៊ុតស្វ័យប្រវត្តិ (Auto Drop)",
    CurrentValue = false,
    Flag = "AutoDrop",
    Callback = function(v) State.AutoDrop = v end,
})

TabSteal:CreateToggle({
    Name = "ដាក់ស៊ុតស្វ័យប្រវត្តិ (Auto Place)",
    CurrentValue = false,
    Flag = "AutoPlace",
    Callback = function(v) State.AutoPlace = v end,
})

TabSteal:CreateToggle({
    Name = "ញាស់ស៊ុតស្វ័យប្រវត្តិ (Auto Hatch)",
    CurrentValue = false,
    Flag = "AutoHatch",
    Callback = function(v) State.AutoHatch = v end,
})

TabSteal:CreateParagraph({
    Title = "ចំណាំ Steal",
    Content = "Auto Steal ត្រូវ bind remote ពី game។ បើ game update ប្តូរ remote ត្រូវ update path។ Structure រួចហើយសម្រាប់ inject។",
})

-- =========================================================
-- TAB 3 : ចលនា
-- =========================================================
local TabMove = Window:CreateTab("ចលនា", 4483362458)
TabMove:CreateSection("ល្បឿន & លោត")

TabMove:CreateToggle({
    Name = "បើកល្បឿនដើរ",
    CurrentValue = false,
    Flag = "WalkSpeedOn",
    Callback = function(v) State.WalkSpeedOn = v end,
})

TabMove:CreateSlider({
    Name = "ល្បឿនដើរ",
    Range = {16, 300},
    Increment = 1,
    Suffix = "",
    CurrentValue = 32,
    Flag = "WalkSpeed",
    Callback = function(v) State.WalkSpeed = v end,
})

TabMove:CreateToggle({
    Name = "បើកកម្លាំងលោត",
    CurrentValue = false,
    Flag = "JumpPowerOn",
    Callback = function(v) State.JumpPowerOn = v end,
})

TabMove:CreateSlider({
    Name = "កម្លាំងលោត",
    Range = {10, 300},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(v) State.JumpPower = v end,
})

TabMove:CreateToggle({
    Name = "លោតមិនចេះអស់",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(v) State.InfJump = v end,
})

TabMove:CreateToggle({
    Name = "ឆ្លងកាត់វត្ថុ (NoClip)",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(v) State.NoClip = v end,
})

TabMove:CreateSection("ហើរ")

TabMove:CreateToggle({
    Name = "ហើរ (Fly)",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(v)
        State.Fly = v
        local hum = getHum()
        if hum and not v then hum.PlatformStand = false end
    end,
})

TabMove:CreateSlider({
    Name = "ល្បឿនហើរ",
    Range = {20, 200},
    Increment = 5,
    Suffix = "",
    CurrentValue = 60,
    Flag = "FlySpeed",
    Callback = function(v) State.FlySpeed = v end,
})

-- =========================================================
-- TAB 4 : លេងសើច  — Slow: all or select
-- =========================================================
local TabTroll = Window:CreateTab("លេងសើច", 4483362458)
TabTroll:CreateSection("ជើងយឺត")

TabTroll:CreateDropdown({
    Name = "របៀប Slow",
    Options = {"គ្មាន", "ទាំងអស់", "ជ្រើសរើស"},
    CurrentOption = {"គ្មាន"},
    Flag = "SlowMode",
    Callback = function(opt)
        local mode = typeof(opt) == "table" and (opt[1] or opt) or opt
        State.SlowMode = tostring(mode or "គ្មាន")
        notify("Slow", "របៀប: " .. State.SlowMode)
    end,
})

TabTroll:CreateSlider({
    Name = "ល្បឿន Slow (0 = ឈរ)",
    Range = {0, 16},
    Increment = 1,
    Suffix = "",
    CurrentValue = 6,
    Flag = "SlowValue",
    Callback = function(v) State.SlowValue = v end,
})

local playerOptions = buildPlayerList()
if #playerOptions == 0 then
    playerOptions = {"(មិនមានអ្នកលេងផ្សេង)"}
end

TabTroll:CreateDropdown({
    Name = "ជ្រើសអ្នកលេង (សម្រាប់របៀប ជ្រើសរើស)",
    Options = playerOptions,
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "SlowSelect",
    Callback = function(opts)
        table.clear(State.SlowTargets)
        if typeof(opts) ~= "table" then return end
        for _, entry in ipairs(opts) do
            local pname = nameFromEntry(tostring(entry))
            local plr = findPlayerByName(pname)
            if plr then
                State.SlowTargets[plr.UserId] = true
            end
        end
        local n = 0
        for _ in pairs(State.SlowTargets) do n = n + 1 end
        notify("Slow", "បានជ្រើស " .. n .. " នាក់")
    end,
})

TabTroll:CreateButton({
    Name = "ផ្ទុកបញ្ជីអ្នកលេងឡើងវិញ",
    Callback = function()
        notify("Slow", "បិទ UI រួច execute ឡើងវិញ ដើម្បី refresh បញ្ជី")
    end,
})

TabTroll:CreateParagraph({
    Title = "របៀបប្រើ Slow",
    Content = "• គ្មាន = បិទ\n• ទាំងអស់ = slow គ្រប់អ្នកលេង\n• ជ្រើសរើស = slow តែអ្នកដែលជ្រើសក្នុង dropdown\n\nចំណាំ: client-side តែប៉ុណ្ណោះ",
})

-- =========================================================
-- TAB 5 : ប្រព័ន្ធ
-- =========================================================
local TabSys = Window:CreateTab("ប្រព័ន្ធ", 4483362458)
TabSys:CreateSection("ការកំណត់")

TabSys:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Flag = "AntiAfk",
    Callback = function(v) State.AntiAfk = v end,
})

TabSys:CreateButton({
    Name = "ចូល Server ឡើងវិញ",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

TabSys:CreateButton({
    Name = "បិទ UI (Destroy)",
    Callback = function()
        genv.__KONKHMER_RUNNING = false
        for _, c in ipairs(Connections) do
            pcall(function() c:Disconnect() end)
        end
        Rayfield:Destroy()
    end,
})

TabSys:CreateParagraph({
    Title = "អំពី",
    Content = "KONKHMER NAK PHLIT v2\nភាសាខ្មែរ 100%\nUI Rayfield (mobile OK)\nចុច End = បិទ UI",
})

track(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.End then
        genv.__KONKHMER_RUNNING = false
        for _, c in ipairs(Connections) do
            pcall(function() c:Disconnect() end)
        end
        pcall(function() Rayfield:Destroy() end)
    end
end))

print("[KONKHMER NAK PHLIT v2] Ready")
