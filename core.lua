-- Script: KONKHMER NAK PHLIT
-- Language: Khmer
-- Version: 6 (Persistent WalkSpeed Enforcement & Refinements)
-- Filename: core.lua

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService") -- Used for GenerateGUID to obfuscate internal names

-- Configuration
local CONFIG = {
    WindowSize = UDim2.new(0, 500, 0, 350),
    SidebarWidth = 0.3,
    DefaultWalkSpeed = 16,
    SlowWalkSpeed = 5,
    FastWalkSpeed = 30,
    DefaultJumpPower = 50,
    InfiniteJumpPower = 100,
    FlySpeed = 0.5,
    MenuToggleKey = Enum.KeyCode.RightShift,
    TweenInfoDefault = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0),
    TweenInfoFast = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0),
    WalkSpeedEnforcementInterval = 0.1, -- How often to re-apply walkspeed (in seconds)
}

-- Khmer Translations
local TRANSLATIONS = {
    WindowTitle = "កូនខ្មែរ អ្នកផលិត",
    HomeTab = "ទំព័រដើម",
    MovementTab = "ចលនា",
    VisualsTab = "រូបភាព",
    StealTab = "លួច",
    UtilityTab = "ឧបករណ៍ប្រើប្រាស់",
    SettingsTab = "កំណត់",

    -- Home Tab
    WelcomeMessage = "សូមស្វាគមន៍មកកាន់ កូនខ្មែរ អ្នកផលិត!",
    Instructions = "ប្រើផ្ទាំងចំហៀងដើម្បីចូលប្រើមុខងារ។",
    EnjoyScript = "សូមរីករាយជាមួយ Script របស់យើង!",

    -- Movement Tab
    WalkSpeedSection = "ល្បឿណជើង",
    SelectPlayer = "ជ្រើសរើសអ្នកលេង",
    SlowAllPlayers = "បន្ថយល្បឿនជើងទាំងអស់",
    WalkSpeedAmount = "បរិមាណល្បឿនជើង",
    ApplySpeed = "អនុវត្តល្បឿន",
    ResetSpeed = "កំណត់ល្បឿនដើម",
    PlayerWalkSpeedSet = "បានកំណត់ល្បឿនជើងរបស់ %s ទៅ %d",
    AllPlayersWalkSpeedSet = "បានកំណត់ល្បឿនជើងអ្នកលេងទាំងអស់ទៅ %d",
    PlayerNotFound = "រកមិនឃើញអ្នកលេង '%s' ទេ",

    InfiniteJump = "លោតគ្មានកំណត់",
    Fly = "ហោះហើរ",
    Noclip = "ដើរឆ្លងកាត់ជញ្ជាំង",
    MovementWarning = "ការហោះហើរ/Noclip អាចត្រូវបានចាប់ដោយ Anti-cheat!",
    PersistentSpeedWarning = "ការកំណត់ល្បឿនជើងជានិច្ចមានហានិភ័យខ្ពស់ក្នុងការត្រូវបានចាប់ដោយ Anti-cheat!",

    -- Visuals Tab
    PlayerESP = "បង្ហាញអ្នកលេង (ESP)",
    PlayerNames = "ឈ្មោះអ្នកលេង",
    PlayerBoxes = "ប្រអប់ព័ទ្ធអ្នកលេង",
    ItemESP = "បង្ហាញរបស់របរ (ESP)",
    ItemESPPlaceholder = "របស់របរ (Needs Game Specifics)",
    VisualsWarning = "ESP អាចត្រូវបានចាប់ដោយ Anti-cheat មួយចំនួន!",

    -- Steal Tab
    StealPanelTitle = "ផ្ទាំងលួច",
    TeleportToPlayer = "បញ្ជូនទៅអ្នកលេង",
    StealItem = "លួចរបស់របរ",
    AutoSteal = "លួចដោយស្វ័យប្រវត្តិ",
    InstantSteal = "លួចភ្លាមៗ",
    InvisibleSteal = "លួចបំបាំងកាយ",
    StealPlayerInputPlaceholder = "ឈ្មោះអ្នកលេង",
    StealActionWarning = "មុខងារលួចអាចមានហានិភ័យខ្ពស់!",
    TeleportedTo = "បានបញ្ជូនទៅ %s",

    -- Utility Tab
    AntiAFK = "ប្រឆាំង AFK",
    AntiAFKStatus = "ស្ថានភាព Anti-AFK៖ %s",
    Enabled = "បើក",
    Disabled = "បិទ",

    -- Settings Tab
    ToggleUIVisibility = "បង្ហាញ/លាក់ UI",
    UICustomization = "ការកំណត់ UI",
    UIBackgroundTransparency = "តម្លាភាពផ្ទៃខាងក្រោយ UI",
    UISize = "ទំហំ UI (ទទឹង x កម្ពស់)",
    ApplyUISettings = "អនុវត្តការកំណត់ UI",
    UIVisibilityMessage = "UI ឥឡូវ %s",
    Visible = "បង្ហាញ",
    Hidden = "លាក់",

    Notification = "ជូនដំណឹង",
}

-- Helper function for notifications
local function Notify(message)
    print(TRANSLATIONS.Notification .. ": " .. message)
end

-- UI Elements Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KONKHMER_NAK_PHLIT_GUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local UIScale = Instance.new("UIScale")
UIScale.Scale = 0.8
UIScale.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = CONFIG.WindowSize
MainFrame.Position = UDim2.new(0.5, -CONFIG.WindowSize.X.Offset / 2, 0.5, -CONFIG.WindowSize.Y.Offset / 2)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

local UICorner_Main = Instance.new("UICorner")
UICorner_Main.CornerRadius = UDim.new(0, 10)
UICorner_Main.Parent = MainFrame

local UIStroke_Main = Instance.new("UIStroke")
UIStroke_Main.Color = Color3.fromRGB(50, 50, 50)
UIStroke_Main.Thickness = 1
UIStroke_Main.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_Main.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(25, 25, 25))
TitleGradient.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = TRANSLATIONS.WindowTitle
TitleLabel.TextColor3 = Color3.fromRGB(200, 255, 255)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextWrapped = true
TitleLabel.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 35, 1, 0)
CloseButton.Position = UDim2.new(1, -35, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

-- Sidebar / Tab Buttons Frame
local SidebarFrame = Instance.new("Frame")
SidebarFrame.Name = "SidebarFrame"
SidebarFrame.Size = UDim2.new(CONFIG.SidebarWidth, 0, 1, -35)
SidebarFrame.Position = UDim2.new(0, 0, 0, 35)
SidebarFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SidebarFrame.BorderSizePixel = 0
SidebarFrame.Parent = MainFrame

local UIListLayout_Sidebar = Instance.new("UIListLayout")
UIListLayout_Sidebar.Name = "SidebarLayout"
UIListLayout_Sidebar.FillDirection = Enum.FillDirection.Vertical
UIListLayout_Sidebar.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout_Sidebar.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout_Sidebar.Padding = UDim.new(0, 5)
UIListLayout_Sidebar.Parent = SidebarFrame

local UIPadding_Sidebar = Instance.new("UIPadding")
UIPadding_Sidebar.PaddingTop = UDim.new(0, 10)
UIPadding_Sidebar.PaddingBottom = UDim.new(0, 10)
UIPadding_Sidebar.PaddingLeft = UDim.new(0, 10)
UIPadding_Sidebar.PaddingRight = UDim.new(0, 10)
UIPadding_Sidebar.Parent = SidebarFrame

-- Main Content Frame (where actual tab content goes)
local ContentPageFrame = Instance.new("Frame")
ContentPageFrame.Name = "ContentPageFrame"
ContentPageFrame.Size = UDim2.new(1 - CONFIG.SidebarWidth, 0, 1, -35)
ContentPageFrame.Position = UDim2.new(CONFIG.SidebarWidth, 0, 0, 35)
ContentPageFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentPageFrame.BorderSizePixel = 0
ContentPageFrame.Parent = MainFrame
ContentPageFrame.ClipsDescendants = true

local UIPageLayout_Content = Instance.new("UIPageLayout")
UIPageLayout_Content.Name = "ContentPageLayout"
UIPageLayout_Content.EasingStyle = Enum.EasingStyle.Quad
UIPageLayout_Content.EasingDirection = Enum.EasingDirection.Out
UIPageLayout_Content.TweenTime = 0.3
UIPageLayout_Content.Parent = ContentPageFrame

local UIPadding_Content = Instance.new("UIPadding")
UIPadding_Content.PaddingTop = UDim.new(0, 15)
UIPadding_Content.PaddingBottom = UDim.new(0, 15)
UIPadding_Content.PaddingLeft = UDim.new(0, 15)
UIPadding_Content.PaddingRight = UDim.new(0, 15)
UIPadding_Content.Parent = ContentPageFrame

local activeTab = nil

-- Helper function to create a tab button for the sidebar
local function createTabButton(name, translation)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "TabButton"
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.BorderSizePixel = 0
    Button.Text = translation
    Button.TextColor3 = Color3.fromRGB(220, 220, 220)
    Button.TextSize = 16
    Button.Font = Enum.Font.Gotham
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.TextWrapped = true
    Button.Parent = SidebarFrame

    local UICorner_Btn = Instance.new("UICorner")
    UICorner_Btn.CornerRadius = UDim.new(0, 6)
    UICorner_Btn.Parent = Button

    Button.MouseEnter:Connect(function()
        if activeTab ~= name then
            Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        end
    end)
    Button.MouseLeave:Connect(function()
        if activeTab ~= name then
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
    end)

    return Button
end

-- Helper function to create content frame for each tab
local function createTabContent(name)
    local Frame = Instance.new("Frame")
    Frame.Name = name .. "TabContent"
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.Position = UDim2.new(0, 0, 0, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Parent = ContentPageFrame

    local UIListLayout_Content = Instance.new("UIListLayout")
    UIListLayout_Content.Name = "ContentListLayout"
    UIListLayout_Content.FillDirection = Enum.FillDirection.Vertical
    UIListLayout_Content.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout_Content.VerticalAlignment = Enum.VerticalAlignment.Top
    UIListLayout_Content.Padding = UDim.new(0, 10)
    UIListLayout_Content.Parent = Frame

    return Frame
end

local Tabs = {
    Home = {
        Button = createTabButton("Home", TRANSLATIONS.HomeTab),
        Content = createTabContent("Home")
    },
    Movement = {
        Button = createTabButton("Movement", TRANSLATIONS.MovementTab),
        Content = createTabContent("Movement")
    },
    Visuals = {
        Button = createTabButton("Visuals", TRANSLATIONS.VisualsTab),
        Content = createTabContent("Visuals")
    },
    Steal = {
        Button = createTabButton("Steal", TRANSLATIONS.StealTab),
        Content = createTabContent("Steal")
    },
    Utility = {
        Button = createTabButton("Utility", TRANSLATIONS.UtilityTab),
        Content = createTabContent("Utility")
    },
    Settings = {
        Button = createTabButton("Settings", TRANSLATIONS.SettingsTab),
        Content = createTabContent("Settings")
    },
}

-- Function to switch active tab
local function setActiveTab(tabName)
    if activeTab then
        Tabs[activeTab].Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Tabs[activeTab].Button.TextColor3 = Color3.fromRGB(220, 220, 220)
    end
    Tabs[tabName].Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Tabs[tabName].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    UIPageLayout_Content:JumpTo(Tabs[tabName].Content)
    activeTab = tabName
end

-- Generic UI Creator Functions for consistency
local function createToggleButton(parent, text, defaultState, callback)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = HttpService:GenerateGUID(false)
    ToggleButton.Size = UDim2.new(1, 0, 0, 30)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = text .. ": " .. (defaultState and TRANSLATIONS.Enabled or TRANSLATIONS.Disabled)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 15
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.Parent = parent

    local UICorner_Toggle = Instance.new("UICorner")
    UICorner_Toggle.CornerRadius = UDim.new(0, 5)
    UICorner_Toggle.Parent = ToggleButton

    local state = defaultState
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        ToggleButton.Text = text .. ": " .. (state and TRANSLATIONS.Enabled or TRANSLATIONS.Disabled)
        ToggleButton.BackgroundColor3 = state and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
        if callback then callback(state) end
    end)
    ToggleButton.BackgroundColor3 = state and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
    return ToggleButton, function() return state end
end

local function createSliderWithInput(parent, text, minVal, maxVal, defaultVal, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = HttpService:GenerateGUID(false)
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SliderFrame.BackgroundTransparency = 0
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent

    local UICorner_SliderFrame = Instance.new("UICorner")
    UICorner_SliderFrame.CornerRadius = UDim.new(0, 5)
    UICorner_SliderFrame.Parent = SliderFrame

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Position = UDim2.new(0, 5, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. tostring(defaultVal)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local InputField = Instance.new("TextBox")
    InputField.Name = "InputField"
    InputField.Size = UDim2.new(1, -10, 0, 25)
    InputField.Position = UDim2.new(0, 5, 0, 20)
    InputField.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    InputField.BorderSizePixel = 0
    InputField.Text = tostring(defaultVal)
    InputField.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputField.TextSize = 14
    InputField.Font = Enum.Font.Gotham
    InputField.TextXAlignment = Enum.TextXAlignment.Left
    InputField.Parent = SliderFrame

    local UICorner_InputField = Instance.new("UICorner")
    UICorner_InputField.CornerRadius = UDim.new(0, 5)
    UICorner_InputField.Parent = InputField

    InputField.Changed:Connect(function(property)
        if property == "Text" then
            local value = tonumber(InputField.Text)
            if value and value >= minVal and value <= maxVal then
                Label.Text = text .. ": " .. tostring(math.floor(value * 10) / 10)
                if callback then callback(value) end
            else
                Label.Text = text .. ": " .. "មិនត្រឹមត្រូវ"
            end
        end
    end)

    return SliderFrame, InputField
end

local function createPlayerInputField(parent, placeholder, defaultText)
    local InputField = Instance.new("TextBox")
    InputField.Name = HttpService:GenerateGUID(false)
    InputField.Size = UDim2.new(1, 0, 0, 30)
    InputField.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    InputField.BorderSizePixel = 0
    InputField.PlaceholderText = placeholder
    InputField.Text = defaultText or ""
    InputField.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputField.TextSize = 14
    InputField.Font = Enum.Font.Gotham
    InputField.Parent = parent

    local UICorner_InputField = Instance.new("UICorner")
    UICorner_InputField.CornerRadius = UDim.new(0, 5)
    UICorner_InputField.Parent = InputField
    return InputField
end

local function createButton(parent, text, callback, bgColor)
    local Button = Instance.new("TextButton")
    Button.Name = HttpService:GenerateGUID(false)
    Button.Size = UDim2.new(1, 0, 0, 30)
    Button.BackgroundColor3 = bgColor or Color3.fromRGB(50, 100, 150)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16
    Button.Font = Enum.Font.GothamBold
    Button.Parent = parent

    local UICorner_Button = Instance.new("UICorner")
    UICorner_Button.CornerRadius = UDim.new(0, 5)
    UICorner_Button.Parent = Button

    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- Home Tab Content
do
    local HomeContent = Tabs.Home.Content

    local WelcomeLabel = Instance.new("TextLabel")
    WelcomeLabel.Name = "WelcomeLabel"
    WelcomeLabel.Size = UDim2.new(1, 0, 0, 50)
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Text = TRANSLATIONS.WelcomeMessage
    WelcomeLabel.TextColor3 = Color3.fromRGB(200, 255, 255)
    WelcomeLabel.TextSize = 22
    WelcomeLabel.Font = Enum.Font.GothamBold
    WelcomeLabel.TextWrapped = true
    WelcomeLabel.Parent = HomeContent

    local InstructionsLabel = Instance.new("TextLabel")
    InstructionsLabel.Name = "InstructionsLabel"
    InstructionsLabel.Size = UDim2.new(1, 0, 0, 80)
    InstructionsLabel.BackgroundTransparency = 1
    InstructionsLabel.Text = TRANSLATIONS.Instructions .. "\n" .. TRANSLATIONS.EnjoyScript
    InstructionsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    InstructionsLabel.TextSize = 16
    InstructionsLabel.Font = Enum.Font.Gotham
    InstructionsLabel.TextWrapped = true
    InstructionsLabel.Parent = HomeContent
end

-- Movement Tab Content
local activeSpeedTargets = {} -- {UserId = targetSpeed, ...}
local speedEnforcementConnection = nil

local function enforceWalkSpeed()
    if not speedEnforcementConnection then
        speedEnforcementConnection = RunService.Heartbeat:Connect(function()
            for userId, targetSpeed in pairs(activeSpeedTargets) do
                local player = Players:GetPlayerByUserId(userId)
                if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    local humanoid = player.Character.Humanoid
                    if humanoid.WalkSpeed ~= targetSpeed then
                        TweenService:Create(humanoid, CONFIG.TweenInfoFast, {WalkSpeed = targetSpeed}):Play()
                    end
                else
                    activeSpeedTargets[userId] = nil
                end
            end
            if next(activeSpeedTargets) == nil then
                stopEnforceWalkSpeed()
            end
        end)
    end
end

local function stopEnforceWalkSpeed()
    if speedEnforcementConnection then
        speedEnforcementConnection:Disconnect()
        speedEnforcementConnection = nil
    end
end

do
    local MovementContent = Tabs.Movement.Content

    local WalkSpeedSectionLabel = Instance.new("TextLabel")
    WalkSpeedSectionLabel.Name = HttpService:GenerateGUID(false)
    WalkSpeedSectionLabel.Size = UDim2.new(1, 0, 0, 25)
    WalkSpeedSectionLabel.BackgroundTransparency = 1
    WalkSpeedSectionLabel.Text = TRANSLATIONS.WalkSpeedSection
    WalkSpeedSectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WalkSpeedSectionLabel.TextSize = 18
    WalkSpeedSectionLabel.Font = Enum.Font.GothamBold
    WalkSpeedSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    WalkSpeedSectionLabel.Parent = MovementContent

    local PlayerSelectLabel = Instance.new("TextLabel")
    PlayerSelectLabel.Name = HttpService:GenerateGUID(false)
    PlayerSelectLabel.Size = UDim2.new(1, 0, 0, 20)
    PlayerSelectLabel.BackgroundTransparency = 1
    PlayerSelectLabel.Text = TRANSLATIONS.SelectPlayer
    PlayerSelectLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayerSelectLabel.TextSize = 14
    PlayerSelectLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerSelectLabel.Parent = MovementContent

    local PlayerInputField = createPlayerInputField(MovementContent, TRANSLATIONS.SelectPlayer, "")
    
    local SlowAllToggle, getSlowAllState = createToggleButton(MovementContent, TRANSLATIONS.SlowAllPlayers, false, function(state)
        if state then
            Notify(TRANSLATIONS.PersistentSpeedWarning)
        end
    end)
    
    local WalkSpeedSliderFrame, WalkSpeedInput = createSliderWithInput(MovementContent, TRANSLATIONS.WalkSpeedAmount, 0, 100, CONFIG.DefaultWalkSpeed)
    
    local function applyWalkSpeedToTarget(player, speed)
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            activeSpeedTargets[player.UserId] = speed
            TweenService:Create(player.Character.Humanoid, CONFIG.TweenInfoDefault, {WalkSpeed = speed}):Play()
            enforceWalkSpeed()
        end
    end

    local function resetWalkSpeedForTarget(player)
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            activeSpeedTargets[player.UserId] = nil
            TweenService:Create(player.Character.Humanoid, CONFIG.TweenInfoDefault, {WalkSpeed = CONFIG.DefaultWalkSpeed}):Play()
            if next(activeSpeedTargets) == nil then
                stopEnforceWalkSpeed()
            end
        end
    end

    createButton(MovementContent, TRANSLATIONS.ApplySpeed, function()
        local targetSpeed = tonumber(WalkSpeedInput.Text) or CONFIG.DefaultWalkSpeed
        if targetSpeed < 0 then targetSpeed = 0 end

        if getSlowAllState() then
            Notify(TRANSLATIONS.PersistentSpeedWarning)
            for _, player in ipairs(Players:GetPlayers()) do
                applyWalkSpeedToTarget(player, targetSpeed)
            end
            Notify(string.format(TRANSLATIONS.AllPlayersWalkSpeedSet, targetSpeed))
        else
            local targetPlayerName = PlayerInputField.Text
            if targetPlayerName == "" then
                applyWalkSpeedToTarget(LocalPlayer, targetSpeed)
                Notify(string.format(TRANSLATIONS.PlayerWalkSpeedSet, LocalPlayer.Name, targetSpeed))
            else
                local targetPlayer = Players:FindFirstChild(targetPlayerName)
                if targetPlayer then
                    applyWalkSpeedToTarget(targetPlayer, targetSpeed)
                    Notify(string.format(TRANSLATIONS.PlayerWalkSpeedSet, targetPlayer.Name, targetSpeed))
                else
                    Notify(string.format(TRANSLATIONS.PlayerNotFound, targetPlayerName))
                end
            end
        end
    end)

    createButton(MovementContent, TRANSLATIONS.ResetSpeed, function()
        if getSlowAllState() then
            Notify(TRANSLATIONS.PersistentSpeedWarning)
            for _, player in ipairs(Players:GetPlayers()) do
                resetWalkSpeedForTarget(player)
            end
            Notify(string.format(TRANSLATIONS.AllPlayersWalkSpeedSet, CONFIG.DefaultWalkSpeed))
        else
            local targetPlayerName = PlayerInputField.Text
            if targetPlayerName == "" then
                resetWalkSpeedForTarget(LocalPlayer)
                Notify(string.format(TRANSLATIONS.PlayerWalkSpeedSet, LocalPlayer.Name, CONFIG.DefaultWalkSpeed))
            else
                local targetPlayer = Players:FindFirstChild(targetPlayerName)
                if targetPlayer then
                    resetWalkSpeedForTarget(targetPlayer)
                    Notify(string.format(TRANSLATIONS.PlayerWalkSpeedSet, targetPlayer.Name, CONFIG.DefaultWalkSpeed))
                else
                    Notify(string.format(TRANSLATIONS.PlayerNotFound, targetPlayerName))
                end
            end
        end
    end, Color3.fromRGB(150, 100, 50))

    -- Other Movement Features
    local function setupInfiniteJump(state)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            if state then
                LocalPlayer.Character.Humanoid.JumpPower = CONFIG.InfiniteJumpPower
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if input.KeyCode == Enum.KeyCode.Space and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and getInfiniteJumpState() then
                        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            else
                LocalPlayer.Character.Humanoid.JumpPower = CONFIG.DefaultJumpPower
            end
        end
    end

    local FlyConnection = nil
    local function setupFly(state)
        local Character = LocalPlayer.Character
        if not Character then return end
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not RootPart then return end

        if state then
            Notify(TRANSLATIONS.MovementWarning)
            RootPart.Anchored = true
            Humanoid.Parent:SetAttribute("OldGravity", Workspace.Gravity)
            Workspace.Gravity = 0

            FlyConnection = RunService.RenderStepped:Connect(function()
                local Camera = Workspace.CurrentCamera
                local CameraCFrame = Camera.CFrame
                local moveSpeed = Humanoid.WalkSpeed * CONFIG.FlySpeed * RunService.RenderStepped:Wait()

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then RootPart.CFrame = RootPart.CFrame + CameraCFrame.lookVector * moveSpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then RootPart.CFrame = RootPart.CFrame - CameraCFrame.lookVector * moveSpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then RootPart.CFrame = RootPart.CFrame - CameraCFrame.rightVector * moveSpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then RootPart.CFrame = RootPart.CFrame + CameraCFrame.rightVector * moveSpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then RootPart.CFrame = RootPart.CFrame + CameraCFrame.UpVector * moveSpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then RootPart.CFrame = RootPart.CFrame - CameraCFrame.UpVector * moveSpeed end
            end)
        else
            if FlyConnection then
                FlyConnection:Disconnect()
                FlyConnection = nil
            end
            RootPart.Anchored = false
            if Humanoid.Parent:GetAttribute("OldGravity") then
                Workspace.Gravity = Humanoid.Parent:GetAttribute("OldGravity")
                Humanoid.Parent:SetAttribute("OldGravity", nil)
            end
        end
    end

    local NoclipParts = {}
    local function setupNoclip(state)
        local Character = LocalPlayer.Character
        if not Character then return end

        if state then
            Notify(TRANSLATIONS.MovementWarning)
            for _, child in ipairs(Character:GetChildren()) do
                if child:IsA("BasePart") and child.CanCollide then
                    child.CanCollide = false
                    table.insert(NoclipParts, child)
                end
            end
        else
            for _, part in ipairs(NoclipParts) do
                if part.Parent == Character then
                    part.CanCollide = true
                end
            end
            NoclipParts = {}
        end
    end

    local InfiniteJumpToggle, getInfiniteJumpState = createToggleButton(MovementContent, TRANSLATIONS.InfiniteJump, false, setupInfiniteJump)
    local FlyToggle, getFlyState = createToggleButton(MovementContent, TRANSLATIONS.Fly, false, setupFly)
    local NoclipToggle, getNoclipState = createToggleButton(MovementContent, TRANSLATIONS.Noclip, false, setupNoclip)
end

-- Visuals Tab Content
do
    local VisualsContent = Tabs.Visuals.Content

    local PlayerESPLabel = Instance.new("TextLabel")
    PlayerESPLabel.Name = HttpService:GenerateGUID(false)
    PlayerESPLabel.Size = UDim2.new(1, 0, 0, 25)
    PlayerESPLabel.BackgroundTransparency = 1
    PlayerESPLabel.Text = TRANSLATIONS.PlayerESP
    PlayerESPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerESPLabel.TextSize = 18
    PlayerESPLabel.Font = Enum.Font.GothamBold
    PlayerESPLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerESPLabel.Parent = VisualsContent

    local espConnections = {}
    local espBoxes = {}

    local function updatePlayerESP(state)
        if state then
            Notify(TRANSLATIONS.VisualsWarning)
            local function createPlayerESPBox(player)
                if player == LocalPlayer then return end
                
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                local box = Instance.new("BillboardGui")
                box.Size = UDim2.new(0, 150, 0, 70)
                box.AlwaysOnTop = true
                box.ExtentsOffset = Vector3.new(0, char.Humanoid.Head.Size.Y, 0)
                box.Adornee = char.HumanoidRootPart
                box.Parent = PlayerGui

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                frame.BackgroundTransparency = 0.7
                frame.BorderSizePixel = 1
                frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
                frame.Parent = box

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.Position = UDim2.new(0,0,0,0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = player.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextSize = 16
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextWrapped = true
                nameLabel.Parent = frame

                local healthLabel = Instance.new("TextLabel")
                healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
                healthLabel.Position = UDim2.new(0,0,0.5,0)
                healthLabel.BackgroundTransparency = 1
                healthLabel.Text = "HP: " .. math.floor(char.Humanoid.Health)
                healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                healthLabel.TextSize = 14
                healthLabel.Font = Enum.Font.Gotham
                healthLabel.Parent = frame
                
                espBoxes[player.UserId] = {Box = box, HealthLabel = healthLabel}
                
                table.insert(espConnections, char.Humanoid.HealthChanged:Connect(function(health)
                    healthLabel.Text = "HP: " .. math.floor(health)
                    healthLabel.TextColor3 = Color3.new(1 - (health / char.Humanoid.MaxHealth), (health / char.Humanoid.MaxHealth), 0)
                end))

                table.insert(espConnections, player.CharacterRemoving:Connect(function()
                    if espBoxes[player.UserId] then
                        espBoxes[player.UserId].Box:Destroy()
                        espBoxes[player.UserId] = nil
                    end
                end))
            end

            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    createPlayerESPBox(player)
                end
                table.insert(espConnections, player.CharacterAdded:Connect(createPlayerESPBox))
            end
        else
            for _, conn in ipairs(espConnections) do
                conn:Disconnect()
            end
            espConnections = {}
            for _, boxData in pairs(espBoxes) do
                boxData.Box:Destroy()
            end
            espBoxes = {}
        end
    end

    local PlayerESP_Toggle, getPlayerESPState = createToggleButton(VisualsContent, TRANSLATIONS.PlayerESP, false, updatePlayerESP)

    local ItemESP_Toggle, getItemESPState = createToggleButton(VisualsContent, TRANSLATIONS.ItemESPPlaceholder, false, function(state)
        Notify("Item ESP functionality requires game-specific implementation. This is a placeholder.")
    end)
end

-- Steal Tab Content
do
    local StealContent = Tabs.Steal.Content

    local StealTitle = Instance.new("TextLabel")
    StealTitle.Name = HttpService:GenerateGUID(false)
    StealTitle.Size = UDim2.new(1, 0, 0, 30)
    StealTitle.BackgroundTransparency = 1
    StealTitle.Text = TRANSLATIONS.StealPanelTitle
    StealTitle.TextColor3 = Color3.fromRGB(200, 255, 255)
    StealTitle.TextSize = 18
    StealTitle.Font = Enum.Font.GothamBold
    StealTitle.Parent = StealContent

    local PlayerSelectLabel = Instance.new("TextLabel")
    PlayerSelectLabel.Name = HttpService:GenerateGUID(false)
    PlayerSelectLabel.Size = UDim2.new(1, 0, 0, 20)
    PlayerSelectLabel.BackgroundTransparency = 1
    PlayerSelectLabel.Text = TRANSLATIONS.SelectPlayerToSteal
    PlayerSelectLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayerSelectLabel.TextSize = 14
    PlayerSelectLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerSelectLabel.Parent = StealContent

    local StealPlayerInputField = createPlayerInputField(StealContent, TRANSLATIONS.StealPlayerInputPlaceholder, "")
    
    createButton(StealContent, TRANSLATIONS.TeleportToPlayer, function()
        local targetPlayerName = StealPlayerInputField.Text
        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        if targetPlayer and targetPlayer.Character and LocalPlayer.Character then
            if targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                Notify(string.format(TRANSLATIONS.TeleportedTo, targetPlayer.Name))
                Notify(TRANSLATIONS.StealActionWarning)
            end
        else
            Notify(string.format(TRANSLATIONS.PlayerNotFound, targetPlayerName))
        end
    end, Color3.fromRGB(80, 50, 150))

    local AutoStealToggle, getAutoStealState = createToggleButton(StealContent, TRANSLATIONS.AutoSteal, false, function(state)
        if state then Notify(TRANSLATIONS.StealActionWarning) end
        Notify("Auto Steal functionality requires game-specific implementation. This is a placeholder.")
    end)
    local InstantStealToggle, getInstantStealState = createToggleButton(StealContent, TRANSLATIONS.InstantSteal, false, function(state)
        if state then Notify(TRANSLATIONS.StealActionWarning) end
        Notify("Instant Steal functionality requires game-specific implementation. This is a placeholder.")
    end)
    local InvisibleStealToggle, getInvisibleStealState = createToggleButton(StealContent, TRANSLATIONS.InvisibleSteal, false, function(state)
        if state then Notify(TRANSLATIONS.StealActionWarning) end
        Notify("Invisible Steal functionality requires game-specific implementation. This is a placeholder.")
    end)
end

-- Utility Tab Content
do
    local UtilityContent = Tabs.Utility.Content
    
    local antiAFK_Connection = nil
    local function setupAntiAFK(state)
        if state then
            Notify(TRANSLATIONS.AntiAFKStatus:format(TRANSLATIONS.Enabled))
            antiAFK_Connection = RunService.Heartbeat:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            Notify(TRANSLATIONS.AntiAFKStatus:format(TRANSLATIONS.Disabled))
            if antiAFK_Connection then
                antiAFK_Connection:Disconnect()
                antiAFK_Connection = nil
            end
        end
    end

    local AntiAFK_Toggle, getAntiAFKState = createToggleButton(UtilityContent, TRANSLATIONS.AntiAFK, false, setupAntiAFK)
end

-- Settings Tab Content
do
    local SettingsContent = Tabs.Settings.Content

    local ToggleUILabel = createButton(SettingsContent, TRANSLATIONS.ToggleUIVisibility .. ": " .. TRANSLATIONS.Visible, function()
        MainFrame.Visible = not MainFrame.Visible
        local isVisible = MainFrame.Visible
        ToggleUILabel.Text = TRANSLATIONS.ToggleUIVisibility .. ": " .. (isVisible and TRANSLATIONS.Visible or TRANSLATIONS.Hidden)
        ToggleUILabel.BackgroundColor3 = isVisible and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(80, 80, 80)
        Notify(string.format(TRANSLATIONS.UIVisibilityMessage, if isVisible then TRANSLATIONS.Visible else TRANSLATIONS.Hidden))
    end, Color3.fromRGB(60, 60, 60))

    local BGTransparencyLabel = Instance.new("TextLabel")
    BGTransparencyLabel.Name = HttpService:GenerateGUID(false)
    BGTransparencyLabel.Size = UDim2.new(1, 0, 0, 20)
    BGTransparencyLabel.BackgroundTransparency = 1
    BGTransparencyLabel.Text = TRANSLATIONS.UIBackgroundTransparency .. ": " .. MainFrame.BackgroundTransparency
    BGTransparencyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    BGTransparencyLabel.TextSize = 14
    BGTransparencyLabel.TextXAlignment = Enum.TextXAlignment.Left
    BGTransparencyLabel.Parent = SettingsContent

    local BGTransparencyInput = createPlayerInputField(SettingsContent, "0 - 1 (e.g., 0.2)", tostring(MainFrame.BackgroundTransparency))
    BGTransparencyInput.Changed:Connect(function(property)
        if property == "Text" then
            local newTransparency = tonumber(BGTransparencyInput.Text)
            if newTransparency ~= nil and newTransparency >= 0 and newTransparency <= 1 then
                BGTransparencyLabel.Text = TRANSLATIONS.UIBackgroundTransparency .. ": " .. newTransparency
            end
        end
    end)

    local UISizeLabel = Instance.new("TextLabel")
    UISizeLabel.Name = HttpService:GenerateGUID(false)
    UISizeLabel.Size = UDim2.new(1, 0, 0, 20)
    UISizeLabel.BackgroundTransparency = 1
    UISizeLabel.Text = TRANSLATIONS.UISize .. ": " .. MainFrame.Size.X.Offset .. " x " .. MainFrame.Size.Y.Offset
    UISizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    UISizeLabel.TextSize = 14
    UISizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    UISizeLabel.Parent = SettingsContent

    local UISizeInput = createPlayerInputField(SettingsContent, "ទទឹង x កម្ពស់ (ឧ. 500x350)", MainFrame.Size.X.Offset .. "x" .. MainFrame.Size.Y.Offset)
    UISizeInput.Changed:Connect(function(property)
        if property == "Text" then
            local parts = string.split(UISizeInput.Text, "x")
            if #parts == 2 then
                local width = tonumber(parts[1])
                local height = tonumber(parts[2])
                if width and height then
                    UISizeLabel.Text = TRANSLATIONS.UISize .. ": " .. width .. " x " .. height
                end
            end
        end
    end)

    createButton(SettingsContent, TRANSLATIONS.ApplyUISettings, function()
        local newTransparency = tonumber(BGTransparencyInput.Text)
        if newTransparency ~= nil and newTransparency >= 0 and newTransparency <= 1 then
            MainFrame.BackgroundTransparency = newTransparency
            TitleBar.BackgroundTransparency = newTransparency * 0.5
            SidebarFrame.BackgroundTransparency = newTransparency * 0.5
            ContentPageFrame.BackgroundTransparency = newTransparency
        end

        local parts = string.split(UISizeInput.Text, "x")
        if #parts == 2 then
            local width = tonumber(parts[1])
            local height = tonumber(parts[2])
            if width and height and width >= 200 and height >= 150 then
                MainFrame.Size = UDim2.new(0, width, 0, height)
                MainFrame.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
                SidebarFrame.Size = UDim2.new(CONFIG.SidebarWidth, 0, 1, -35)
                ContentPageFrame.Size = UDim2.new(1 - CONFIG.SidebarWidth, 0, 1, -35)
                ContentPageFrame.Position = UDim2.new(CONFIG.SidebarWidth, 0, 0, 35)
            end
        end
    end, Color3.fromRGB(50, 150, 100))
end

-- Event Connections
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    Tabs.Settings.Content.ToggleUILabel.Text = TRANSLATIONS.ToggleUIVisibility .. ": " .. TRANSLATIONS.Hidden
    Tabs.Settings.Content.ToggleUILabel.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end)

for tabName, tab in pairs(Tabs) do
    tab.Button.MouseButton1Click:Connect(function()
        setActiveTab(tabName)
    end)
end

-- Initial tab selection
setActiveTab("Home")

-- Toggle UI visibility with a keybind
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == CONFIG.MenuToggleKey and not gameProcessedEvent then
        MainFrame.Visible = not MainFrame.Visible
        local isVisible = MainFrame.Visible
        Tabs.Settings.Content.ToggleUILabel.Text = TRANSLATIONS.ToggleUIVisibility .. ": " .. (isVisible and TRANSLATIONS.Visible or TRANSLATIONS.Hidden)
        Tabs.Settings.Content.ToggleUILabel.BackgroundColor3 = isVisible and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(80, 80, 80)
        Notify(string.format(TRANSLATIONS.UIVisibilityMessage, if isVisible then TRANSLATIONS.Visible else TRANSLATIONS.Hidden))
    end
end)

-- Handle CharacterAdded for active speed targets and other movement states
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Re-apply targeted walkspeed if player is in activeSpeedTargets
        if activeSpeedTargets[player.UserId] then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                TweenService:Create(humanoid, CONFIG.TweenInfoDefault, {WalkSpeed = activeSpeedTargets[player.UserId]}):Play()
            end
        end
    end)
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    -- Reset Movement states on character respawn
    if getFlyState() then setupFly(false) setupFly(true) end
    if getNoclipState() then setupNoclip(false) setupNoclip(true) end
    if getInfiniteJumpState() and character:FindFirstChildOfClass("Humanoid") then
        character.Humanoid.JumpPower = CONFIG.InfiniteJumpPower
    end
    -- Ensure local player's walkspeed is re-enforced if they are a target
    if activeSpeedTargets[LocalPlayer.UserId] then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            TweenService:Create(humanoid, CONFIG.TweenInfoDefault, {WalkSpeed = activeSpeedTargets[LocalPlayer.UserId]}):Play()
        end
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    if getFlyState() then setupFly(false) end
    if getNoclipState() then setupNoclip(false) end
end)
