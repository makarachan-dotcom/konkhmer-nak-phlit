-- Script: KONKHMER NAK PHLIT
-- Language: Khmer
-- Version: 4 (Full Features & Enhanced UI)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService") -- For obfuscation, not direct use in this client script

-- Configuration
local CONFIG = {
    WindowSize = UDim2.new(0, 320, 0, 500), -- Slightly larger for more features
    DefaultWalkSpeed = 16,
    SlowWalkSpeed = 5, -- Default slow speed
    FastWalkSpeed = 30, -- Default fast speed
    DefaultJumpPower = 50,
    InfiniteJumpPower = 100, -- Increased jump power for 'infinite' feel
    FlySpeed = 2, -- Default fly speed multiplier (relative to WalkSpeed)
    MenuToggleKey = Enum.KeyCode.RightShift, -- Key to toggle UI visibility
    TweenInfoDefault = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), -- Smooth transitions
    TweenInfoFast = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0),
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
    Instructions = "ប្រើផ្ទាំងខាងលើដើម្បីចូលប្រើមុខងារ។",
    EnjoyScript = "សូមរីករាយជាមួយ Script របស់យើង!",

    -- Movement Tab
    WalkSpeedSection = "ល្បឿនជើង",
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

-- UI Elements
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KONKHMER_NAK_PHLIT_GUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = CONFIG.WindowSize
MainFrame.Position = UDim2.new(0.5, -CONFIG.WindowSize.X.Offset / 2, 0.5, -CONFIG.WindowSize.Y.Offset / 2)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Darker background
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10) -- More rounded
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(50, 50, 50)
UIStroke.Thickness = 1
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35) -- Slightly taller
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
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = TRANSLATIONS.WindowTitle
TitleLabel.TextColor3 = Color3.fromRGB(200, 255, 255) -- Cyan-ish color
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

local TabPanel = Instance.new("Frame")
TabPanel.Name = "TabPanel"
TabPanel.Size = UDim2.new(1, 0, 0, 40) -- Taller tabs
TabPanel.Position = UDim2.new(0, 0, 0, 35)
TabPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabPanel.BorderSizePixel = 0
TabPanel.Parent = MainFrame

local UIListLayout_Tabs = Instance.new("UIListLayout")
UIListLayout_Tabs.Name = "TabListLayout"
UIListLayout_Tabs.FillDirection = Enum.FillDirection.Horizontal
UIListLayout_Tabs.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout_Tabs.Padding = UDim.new(0, 8) -- More padding
UIListLayout_Tabs.Parent = TabPanel

local TabContentFrame = Instance.new("Frame")
TabContentFrame.Name = "TabContentFrame"
TabContentFrame.Size = UDim2.new(1, -10, 1, -(35 + 40 + 5)) -- TitleBar + TabPanel + Padding
TabContentFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2 + 5, 0, 80)
TabContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Slightly lighter for content
TabContentFrame.BackgroundTransparency = 0
TabContentFrame.BorderSizePixel = 0
TabContentFrame.Parent = MainFrame
TabContentFrame.ClipsDescendants = true

local UICorner_Content = Instance.new("UICorner")
UICorner_Content.CornerRadius = UDim.new(0, 8)
UICorner_Content.Parent = TabContentFrame

local activeTab = nil

local function createTabButton(name, translation)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "TabButton"
    Button.Size = UDim2.new(0, 80, 1, 0) -- Wider buttons
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.BorderSizePixel = 0
    Button.Text = translation
    Button.TextColor3 = Color3.fromRGB(220, 220, 220)
    Button.TextSize = 16
    Button.Font = Enum.Font.Gotham
    Button.Parent = TabPanel

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

local function createTabContent(name)
    local Frame = Instance.new("Frame")
    Frame.Name = name .. "TabContent"
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.Position = UDim2.new(0, 0, 0, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Parent = TabContentFrame
    Frame.Visible = false

    local UIListLayout_Content = Instance.new("UIListLayout")
    UIListLayout_Content.Name = "ContentListLayout"
    UIListLayout_Content.FillDirection = Enum.FillDirection.Vertical
    UIListLayout_Content.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout_Content.VerticalAlignment = Enum.VerticalAlignment.Top
    UIListLayout_Content.Padding = UDim.new(0, 10)
    UIListLayout_Content.Parent = Frame

    local UIPadding_Content = Instance.new("UIPadding")
    UIPadding_Content.PaddingTop = UDim.new(0, 15)
    UIPadding_Content.PaddingBottom = UDim.new(0, 15)
    UIPadding_Content.PaddingLeft = UDim.new(0, 15)
    UIPadding_Content.PaddingRight = UDim.new(0, 15)
    UIPadding_Content.Parent = Frame

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

local function setActiveTab(tabName)
    if activeTab then
        Tabs[activeTab].Content.Visible = false
        Tabs[activeTab].Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Tabs[activeTab].Button.TextColor3 = Color3.fromRGB(220, 220, 220)
    end
    Tabs[tabName].Content.Visible = true
    Tabs[tabName].Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Highlight active tab
    Tabs[tabName].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    activeTab = tabName
end

-- Generic UI Creator Functions
local function createToggle(parent, text, defaultState, callback)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = HttpService:GenerateGUID(false) -- Obfuscate name
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

local function createSlider(parent, text, minVal, maxVal, defaultVal, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = HttpService:GenerateGUID(false) -- Obfuscate name
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
    Label.Position = UDim2.new(0.5, -SliderFrame.Size.X.Offset/2 + 5, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. tostring(defaultVal)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local Slider = Instance.new("TextBox") -- Simulating a slider with a text box for value input
    Slider.Name = "SliderInput"
    Slider.Size = UDim2.new(1, -10, 0, 25)
    Slider.Position = UDim2.new(0.5, -SliderFrame.Size.X.Offset/2 + 5, 0, 20)
    Slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Slider.BorderSizePixel = 0
    Slider.Text = tostring(defaultVal)
    Slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    Slider.TextSize = 14
    Slider.Font = Enum.Font.Gotham
    Slider.TextXAlignment = Enum.TextXAlignment.Left
    Slider.Parent = SliderFrame

    local UICorner_SliderInput = Instance.new("UICorner")
    UICorner_SliderInput.CornerRadius = UDim.new(0, 5)
    UICorner_SliderInput.Parent = Slider

    Slider.Changed:Connect(function(property)
        if property == "Text" then
            local value = tonumber(Slider.Text)
            if value and value >= minVal and value <= maxVal then
                Label.Text = text .. ": " .. tostring(math.floor(value * 10) / 10) -- Display one decimal place
                if callback then callback(value) end
            else
                Label.Text = text .. ": " .. "មិនត្រឹមត្រូវ"
            end
        end
    end)

    return SliderFrame, Slider
end

-- Home Tab Content
do
    local HomeContent = Tabs.Home.Content

    local WelcomeLabel = Instance.new("TextLabel")
    WelcomeLabel.Name = "WelcomeLabel"
    WelcomeLabel.Size = UDim2.new(1, 0, 0, 50)
    WelcomeLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
    InstructionsLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    InstructionsLabel.BackgroundTransparency = 1
    InstructionsLabel.Text = TRANSLATIONS.Instructions .. "\n" .. TRANSLATIONS.EnjoyScript
    InstructionsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    InstructionsLabel.TextSize = 16
    InstructionsLabel.Font = Enum.Font.Gotham
    InstructionsLabel.TextWrapped = true
    InstructionsLabel.Parent = HomeContent
end

-- Movement Tab Content
do
    local MovementContent = Tabs.Movement.Content

    -- WalkSpeed Section
    local WalkSpeedSectionLabel = Instance.new("TextLabel")
    WalkSpeedSectionLabel.Name = "WalkSpeedSectionLabel"
    WalkSpeedSectionLabel.Size = UDim2.new(1, 0, 0, 25)
    WalkSpeedSectionLabel.BackgroundTransparency = 1
    WalkSpeedSectionLabel.Text = TRANSLATIONS.WalkSpeedSection
    WalkSpeedSectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WalkSpeedSectionLabel.TextSize = 18
    WalkSpeedSectionLabel.Font = Enum.Font.GothamBold
    WalkSpeedSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    WalkSpeedSectionLabel.Parent = MovementContent

    local PlayerInputLabel = Instance.new("TextLabel")
    PlayerInputLabel.Name = "PlayerInputLabel"
    PlayerInputLabel.Size = UDim2.new(1, 0, 0, 20)
    PlayerInputLabel.BackgroundTransparency = 1
    PlayerInputLabel.Text = TRANSLATIONS.SelectPlayer
    PlayerInputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayerInputLabel.TextSize = 14
    PlayerInputLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerInputLabel.Parent = MovementContent

    local PlayerInputField = Instance.new("TextBox")
    PlayerInputField.Name = "PlayerInputField"
    PlayerInputField.Size = UDim2.new(1, 0, 0, 30)
    PlayerInputField.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    PlayerInputField.BorderSizePixel = 0
    PlayerInputField.PlaceholderText = TRANSLATIONS.SelectPlayer
    PlayerInputField.Text = ""
    PlayerInputField.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerInputField.TextSize = 14
    PlayerInputField.Font = Enum.Font.Gotham
    PlayerInputField.Parent = MovementContent

    local UICorner_PlayerInput = Instance.new("UICorner")
    UICorner_PlayerInput.CornerRadius = UDim.new(0, 5)
    UICorner_PlayerInput.Parent = PlayerInputField

    local SlowAllToggle, getSlowAllState = createToggle(MovementContent, TRANSLATIONS.SlowAllPlayers, false)

    local WalkSpeedSliderFrame, WalkSpeedInput = createSlider(MovementContent, TRANSLATIONS.WalkSpeedAmount, 0, 100, CONFIG.DefaultWalkSpeed)

    local ApplySpeedButton = Instance.new("TextButton")
    ApplySpeedButton.Name = "ApplySpeedButton"
    ApplySpeedButton.Size = UDim2.new(1, 0, 0, 30)
    ApplySpeedButton.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
    ApplySpeedButton.BorderSizePixel = 0
    ApplySpeedButton.Text = TRANSLATIONS.ApplySpeed
    ApplySpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ApplySpeedButton.TextSize = 16
    ApplySpeedButton.Font = Enum.Font.GothamBold
    ApplySpeedButton.Parent = MovementContent

    local UICorner_ApplySpeedButton = Instance.new("UICorner")
    UICorner_ApplySpeedButton.CornerRadius = UDim.new(0, 5)
    UICorner_ApplySpeedButton.Parent = ApplySpeedButton

    local ResetSpeedButton = Instance.new("TextButton")
    ResetSpeedButton.Name = "ResetSpeedButton"
    ResetSpeedButton.Size = UDim2.new(1, 0, 0, 30)
    ResetSpeedButton.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    ResetSpeedButton.BorderSizePixel = 0
    ResetSpeedButton.Text = TRANSLATIONS.ResetSpeed
    ResetSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ResetSpeedButton.TextSize = 16
    ResetSpeedButton.Font = Enum.Font.GothamBold
    ResetSpeedButton.Parent = MovementContent

    local UICorner_ResetSpeedButton = Instance.new("UICorner")
    UICorner_ResetSpeedButton.CornerRadius = UDim.new(0, 5)
    UICorner_ResetSpeedButton.Parent = ResetSpeedButton

    local function applyWalkSpeed(player, speed)
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character.Humanoid
            TweenService:Create(humanoid, CONFIG.TweenInfoDefault, {WalkSpeed = speed}):Play()
        end
    end

    ApplySpeedButton.MouseButton1Click:Connect(function()
        local targetSpeed = tonumber(WalkSpeedInput.SliderInput.Text) or CONFIG.DefaultWalkSpeed
        if targetSpeed < 0 then targetSpeed = 0 end

        if getSlowAllState() then
            for _, player in ipairs(Players:GetPlayers()) do
                applyWalkSpeed(player, targetSpeed)
            end
            Notify(string.format(TRANSLATIONS.AllPlayersWalkSpeedSet, targetSpeed))
        else
            local targetPlayerName = PlayerInputField.Text
            if targetPlayerName == "" then
                applyWalkSpeed(LocalPlayer, targetSpeed)
                Notify(string.format(TRANSLATIONS.PlayerWalkSpeedSet, LocalPlayer.Name, targetSpeed))
            else
                local targetPlayer = Players:FindFirstChild(targetPlayerName)
                if targetPlayer then
                    applyWalkSpeed(targetPlayer, targetSpeed)
                    Notify(string.format(TRANSLATIONS.PlayerWalkSpeedSet, targetPlayer.Name, targetSpeed))
                else
                    Notify(string.format(TRANSLATIONS.PlayerNotFound, targetPlayerName))
                end
            end
        end
    end)

    ResetSpeedButton.MouseButton1Click:Connect(function()
        if getSlowAllState() then
            for _, player in ipairs(Players:GetPlayers()) do
                applyWalkSpeed(player, CONFIG.DefaultWalkSpeed)
            end
            Notify(string.format(TRANSLATIONS.AllPlayersWalkSpeedSet, CONFIG.DefaultWalkSpeed))
        else
            local targetPlayerName = PlayerInputField.Text
            if targetPlayerName == "" then
                applyWalkSpeed(LocalPlayer, CONFIG.DefaultWalkSpeed)
                Notify(string.format(TRANSLATIONS.PlayerWalkSpeedSet, LocalPlayer.Name, CONFIG.DefaultWalkSpeed))
            else
                local targetPlayer = Players:FindFirstChild(targetPlayerName)
                if targetPlayer then
                    applyWalkSpeed(targetPlayer, CONFIG.DefaultWalkSpeed)
                    Notify(string.format(TRANSLATIONS.PlayerWalkSpeedSet, targetPlayer.Name, CONFIG.DefaultWalkSpeed))
                else
                    Notify(string.format(TRANSLATIONS.PlayerNotFound, targetPlayerName))
                end
            end
        end
    end)

    -- Other Movement Features
    local function setupInfiniteJump(state)
        if state then
            LocalPlayer.Character.Humanoid.JumpPower = CONFIG.InfiniteJumpPower
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.Gamepad1 then
                    if input.KeyCode == Enum.KeyCode.Space and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            LocalPlayer.Character.Humanoid.JumpPower = CONFIG.DefaultJumpPower
        end
    end

    local FlyState = false
    local NoclipState = false

    local function setupFly(state)
        FlyState = state
        local Character = LocalPlayer.Character
        if not Character then return end
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not RootPart then return end

        if state then
            Notify(TRANSLATIONS.MovementWarning)
            RootPart.Anchored = true
            -- Disable gravity to make flying smoother
            Humanoid.Parent:SetAttribute("OldGravity", Workspace.Gravity)
            Workspace.Gravity = 0

            local connection = RunService.RenderStepped:Connect(function()
                local Camera = Workspace.CurrentCamera
                local CameraCFrame = Camera.CFrame
                local forward = CameraCFrame.lookVector * CONFIG.FlySpeed * Humanoid.WalkSpeed * RunService.RenderStepped:Wait() -- Fly speed based on camera direction
                local up = CameraCFrame.UpVector * CONFIG.FlySpeed * Humanoid.WalkSpeed * RunService.RenderStepped:Wait()

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then RootPart.CFrame = RootPart.CFrame + forward end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then RootPart.CFrame = RootPart.CFrame - forward end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then RootPart.CFrame = RootPart.CFrame - CameraCFrame.rightVector * CONFIG.FlySpeed * Humanoid.WalkSpeed * RunService.RenderStepped:Wait() end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then RootPart.CFrame = RootPart.CFrame + CameraCFrame.rightVector * CONFIG.FlySpeed * Humanoid.WalkSpeed * RunService.RenderStepped:Wait() end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then RootPart.CFrame = RootPart.CFrame + up end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then RootPart.CFrame = RootPart.CFrame - up end
            end)
            RootPart:SetAttribute("FlyConnection", connection)
        else
            if RootPart:GetAttribute("FlyConnection") then
                RootPart:GetAttribute("FlyConnection"):Disconnect()
                RootPart:SetAttribute("FlyConnection", nil)
            end
            RootPart.Anchored = false
            -- Restore gravity
            if Humanoid.Parent:GetAttribute("OldGravity") then
                Workspace.Gravity = Humanoid.Parent:GetAttribute("OldGravity")
                Humanoid.Parent:SetAttribute("OldGravity", nil)
            end
        end
    end

    local function setupNoclip(state)
        NoclipState = state
        local Character = LocalPlayer.Character
        if not Character then return end

        if state then
            Notify(TRANSLATIONS.MovementWarning)
            for _, child in ipairs(Character:GetChildren()) do
                if child:IsA("BasePart") and child.CanCollide then
                    child.CanCollide = false
                    child:SetAttribute("OldCanCollide", true)
                end
            end
        else
            for _, child in ipairs(Character:GetChildren()) do
                if child:IsA("BasePart") and child:GetAttribute("OldCanCollide") then
                    child.CanCollide = true
                    child:SetAttribute("OldCanCollide", nil)
                end
            end
        end
    end

    local InfiniteJumpToggle = createToggle(MovementContent, TRANSLATIONS.InfiniteJump, false, setupInfiniteJump)
    local FlyToggle = createToggle(MovementContent, TRANSLATIONS.Fly, false, setupFly)
    local NoclipToggle = createToggle(MovementContent, TRANSLATIONS.Noclip, false, setupNoclip)
end

-- Visuals Tab Content
do
    local VisualsContent = Tabs.Visuals.Content

    local PlayerESPLabel = Instance.new("TextLabel")
    PlayerESPLabel.Name = "PlayerESPLabel"
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
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local function createESPBox(char)
                        local box = Instance.new("BillboardGui")
                        box.Size = UDim2.new(0, 100, 0, 50)
                        box.AlwaysOnTop = true
                        box.ExtentsOffset = Vector3.new(0, char.Humanoid.Head.Size.Y, 0) -- Position above head
                        box.Adornee = char.HumanoidRootPart
                        box.Parent = ScreenGui -- Parent to ScreenGui for global visibility

                        local frame = Instance.new("Frame")
                        frame.Size = UDim2.new(1, 0, 1, 0)
                        frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        frame.BackgroundTransparency = 0.8
                        frame.BorderSizePixel = 1
                        frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
                        frame.Parent = box

                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        nameLabel.Position = UDim2.new(0,0,0,0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = player.Name
                        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        nameLabel.TextSize = 14
                        nameLabel.Font = Enum.Font.GothamBold
                        nameLabel.Parent = frame

                        local healthLabel = Instance.new("TextLabel")
                        healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        healthLabel.Position = UDim2.new(0,0,0.5,0)
                        healthLabel.BackgroundTransparency = 1
                        healthLabel.Text = "HP: " .. math.floor(char.Humanoid.Health)
                        healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                        healthLabel.TextSize = 12
                        healthLabel.Font = Enum.Font.Gotham
                        healthLabel.Parent = frame
                        
                        espBoxes[player.UserId] = {Box = box, HealthLabel = healthLabel}
                        
                        local healthChangedConn = char.Humanoid.HealthChanged:Connect(function(health)
                            healthLabel.Text = "HP: " .. math.floor(health)
                        end)
                        table.insert(espConnections, healthChangedConn)

                        local charRemovingConn = char.AncestryChanged:Connect(function(inst, parent)
                            if not parent then -- Character removed
                                box:Destroy()
                                espBoxes[player.UserId] = nil
                            end
                        end)
                        table.insert(espConnections, charRemovingConn)
                    end

                    if player.Character then
                        createESPBox(player.Character)
                    end
                    local charAddedConn = player.CharacterAdded:Connect(createESPBox)
                    table.insert(espConnections, charAddedConn)
                end
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

    local PlayerESP_Toggle = createToggle(VisualsContent, TRANSLATIONS.PlayerESP, false, updatePlayerESP)

    local ItemESP_Toggle = createToggle(VisualsContent, TRANSLATIONS.ItemESPPlaceholder, false, function(state)
        Notify("Item ESP functionality requires game-specific implementation. This is a placeholder.")
    end)
end

-- Steal Tab Content
do
    local StealContent = Tabs.Steal.Content

    local StealTitle = Instance.new("TextLabel")
    StealTitle.Name = "StealTitle"
    StealTitle.Size = UDim2.new(1, 0, 0, 30)
    StealTitle.BackgroundTransparency = 1
    StealTitle.Text = TRANSLATIONS.StealPanelTitle
    StealTitle.TextColor3 = Color3.fromRGB(200, 255, 255)
    StealTitle.TextSize = 18
    StealTitle.Font = Enum.Font.GothamBold
    StealTitle.Parent = StealContent

    local PlayerSelectionLabel = Instance.new("TextLabel")
    PlayerSelectionLabel.Name = "PlayerSelectionLabel"
    PlayerSelectionLabel.Size = UDim2.new(1, 0, 0, 20)
    PlayerSelectionLabel.BackgroundTransparency = 1
    PlayerSelectionLabel.Text = TRANSLATIONS.SelectPlayerToSteal
    PlayerSelectionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayerSelectionLabel.TextSize = 14
    PlayerSelectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerSelectionLabel.Parent = StealContent

    local StealPlayerInputField = Instance.new("TextBox")
    StealPlayerInputField.Name = "StealPlayerInputField"
    StealPlayerInputField.Size = UDim2.new(1, 0, 0, 30)
    StealPlayerInputField.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    StealPlayerInputField.BorderSizePixel = 0
    StealPlayerInputField.PlaceholderText = TRANSLATIONS.StealPlayerInputPlaceholder
    StealPlayerInputField.Text = ""
    StealPlayerInputField.TextColor3 = Color3.fromRGB(255, 255, 255)
    StealPlayerInputField.TextSize = 14
    StealPlayerInputField.Font = Enum.Font.Gotham
    StealPlayerInputField.Parent = StealContent

    local UICorner_StealPlayerInput = Instance.new("UICorner")
    UICorner_StealPlayerInput.CornerRadius = UDim.new(0, 5)
    UICorner_StealPlayerInput.Parent = StealPlayerInputField

    local TeleportButton = Instance.new("TextButton")
    TeleportButton.Name = "TeleportButton"
    TeleportButton.Size = UDim2.new(1, 0, 0, 30)
    TeleportButton.BackgroundColor3 = Color3.fromRGB(80, 50, 150)
    TeleportButton.BorderSizePixel = 0
    TeleportButton.Text = TRANSLATIONS.TeleportToPlayer
    TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportButton.TextSize = 16
    TeleportButton.Font = Enum.Font.GothamBold
    TeleportButton.Parent = StealContent

    local UICorner_TeleportButton = Instance.new("UICorner")
    UICorner_TeleportButton.CornerRadius = UDim.new(0, 5)
    UICorner_TeleportButton.Parent = TeleportButton

    TeleportButton.MouseButton1Click:Connect(function()
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
    end)

    local AutoStealToggle = createToggle(StealContent, TRANSLATIONS.AutoSteal, false, function(state)
        if state then Notify(TRANSLATIONS.StealActionWarning) end
        Notify("Auto Steal functionality requires game-specific implementation. This is a placeholder.")
    end)
    local InstantStealToggle = createToggle(StealContent, TRANSLATIONS.InstantSteal, false, function(state)
        if state then Notify(TRANSLATIONS.StealActionWarning) end
        Notify("Instant Steal functionality requires game-specific implementation. This is a placeholder.")
    end)
    local InvisibleStealToggle = createToggle(StealContent, TRANSLATIONS.InvisibleSteal, false, function(state)
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

    local AntiAFK_Toggle = createToggle(UtilityContent, TRANSLATIONS.AntiAFK, false, setupAntiAFK)
end

-- Settings Tab Content
do
    local SettingsContent = Tabs.Settings.Content

    local ToggleUILabel = Instance.new("TextButton")
    ToggleUILabel.Name = "ToggleUILabel"
    ToggleUILabel.Size = UDim2.new(1, 0, 0, 30)
    ToggleUILabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ToggleUILabel.BorderSizePixel = 0
    ToggleUILabel.Text = TRANSLATIONS.ToggleUIVisibility .. ": " .. TRANSLATIONS.Visible
    ToggleUILabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleUILabel.TextSize = 16
    ToggleUILabel.Font = Enum.Font.Gotham
    ToggleUILabel.Parent = SettingsContent

    local UICorner_ToggleUILabel = Instance.new("UICorner")
    UICorner_ToggleUILabel.CornerRadius = UDim.new(0, 5)
    UICorner_ToggleUILabel.Parent = ToggleUILabel

    ToggleUILabel.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            ToggleUILabel.Text = TRANSLATIONS.ToggleUIVisibility .. ": " .. TRANSLATIONS.Visible
            ToggleUILabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        else
            ToggleUILabel.Text = TRANSLATIONS.ToggleUIVisibility .. ": " .. TRANSLATIONS.Hidden
            ToggleUILabel.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
        Notify(string.format(TRANSLATIONS.UIVisibilityMessage, if MainFrame.Visible then TRANSLATIONS.Visible else TRANSLATIONS.Hidden))
    end)

    local BGTransparencyLabel = Instance.new("TextLabel")
    BGTransparencyLabel.Name = "BGTransparencyLabel"
    BGTransparencyLabel.Size = UDim2.new(1, 0, 0, 20)
    BGTransparencyLabel.BackgroundTransparency = 1
    BGTransparencyLabel.Text = TRANSLATIONS.UIBackgroundTransparency .. ": " .. MainFrame.BackgroundTransparency
    BGTransparencyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    BGTransparencyLabel.TextSize = 14
    BGTransparencyLabel.TextXAlignment = Enum.TextXAlignment.Left
    BGTransparencyLabel.Parent = SettingsContent

    local BGTransparencyInput = Instance.new("TextBox")
    BGTransparencyInput.Name = "BGTransparencyInput"
    BGTransparencyInput.Size = UDim2.new(1, 0, 0, 30)
    BGTransparencyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    BGTransparencyInput.BorderSizePixel = 0
    BGTransparencyInput.Text = tostring(MainFrame.BackgroundTransparency)
    BGTransparencyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    BGTransparencyInput.TextSize = 14
    BGTransparencyInput.Font = Enum.Font.Gotham
    BGTransparencyInput.TextXAlignment = Enum.TextXAlignment.Left
    BGTransparencyInput.Parent = SettingsContent

    local UICorner_BGTransparencyInput = Instance.new("UICorner")
    UICorner_BGTransparencyInput.CornerRadius = UDim.new(0, 5)
    UICorner_BGTransparencyInput.Parent = BGTransparencyInput

    BGTransparencyInput.Changed:Connect(function(property)
        if property == "Text" then
            local newTransparency = tonumber(BGTransparencyInput.Text)
            if newTransparency ~= nil and newTransparency >= 0 and newTransparency <= 1 then
                BGTransparencyLabel.Text = TRANSLATIONS.UIBackgroundTransparency .. ": " .. newTransparency
            end
        end
    end)

    local UISizeLabel = Instance.new("TextLabel")
    UISizeLabel.Name = "UISizeLabel"
    UISizeLabel.Size = UDim2.new(1, 0, 0, 20)
    UISizeLabel.BackgroundTransparency = 1
    UISizeLabel.Text = TRANSLATIONS.UISize .. ": " .. MainFrame.Size.X.Offset .. " x " .. MainFrame.Size.Y.Offset
    UISizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    UISizeLabel.TextSize = 14
    UISizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    UISizeLabel.Parent = SettingsContent

    local UISizeInput = Instance.new("TextBox")
    UISizeInput.Name = "UISizeInput"
    UISizeInput.Size = UDim2.new(1, 0, 0, 30)
    UISizeInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    UISizeInput.BorderSizePixel = 0
    UISizeInput.PlaceholderText = "ទទឹង x កម្ពស់ (ឧ. 320x500)"
    UISizeInput.Text = MainFrame.Size.X.Offset .. "x" .. MainFrame.Size.Y.Offset
    UISizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    UISizeInput.TextSize = 14
    UISizeInput.Font = Enum.Font.Gotham
    UISizeInput.TextXAlignment = Enum.TextXAlignment.Left
    UISizeInput.Parent = SettingsContent

    local UICorner_UISizeInput = Instance.new("UICorner")
    UICorner_UISizeInput.CornerRadius = UDim.new(0, 5)
    UICorner_UISizeInput.Parent = UISizeInput

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

    local ApplySettingsButton = Instance.new("TextButton")
    ApplySettingsButton.Name = "ApplySettingsButton"
    ApplySettingsButton.Size = UDim2.new(1, 0, 0, 30)
    ApplySettingsButton.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
    ApplySettingsButton.BorderSizePixel = 0
    ApplySettingsButton.Text = TRANSLATIONS.ApplyUISettings
    ApplySettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ApplySettingsButton.TextSize = 16
    ApplySettingsButton.Font = Enum.Font.GothamBold
    ApplySettingsButton.Parent = SettingsContent

    local UICorner_ApplySettingsButton = Instance.new("UICorner")
    UICorner_ApplySettingsButton.CornerRadius = UDim.new(0, 5)
    UICorner_ApplySettingsButton.Parent = ApplySettingsButton

    ApplySettingsButton.MouseButton1Click:Connect(function()
        local newTransparency = tonumber(BGTransparencyInput.Text)
        if newTransparency ~= nil and newTransparency >= 0 and newTransparency <= 1 then
            MainFrame.BackgroundTransparency = newTransparency
            TitleBar.BackgroundTransparency = newTransparency * 0.5
            TabPanel.BackgroundTransparency = newTransparency * 0.5
            TabContentFrame.BackgroundTransparency = newTransparency
        end

        local parts = string.split(UISizeInput.Text, "x")
        if #parts == 2 then
            local width = tonumber(parts[1])
            local height = tonumber(parts[2])
            if width and height and width >= 100 and height >= 100 then -- Minimum size
                MainFrame.Size = UDim2.new(0, width, 0, height)
                MainFrame.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
                TabContentFrame.Size = UDim2.new(1, -10, 1, -(35 + 40 + 5))
            end
        end
    end)
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
local isUIVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == CONFIG.MenuToggleKey and not gameProcessedEvent then
        MainFrame.Visible = not MainFrame.Visible
        isUIVisible = not isUIVisible
        if isUIVisible then
            Tabs.Settings.Content.ToggleUILabel.Text = TRANSLATIONS.ToggleUIVisibility .. ": " .. TRANSLATIONS.Visible
            Tabs.Settings.Content.ToggleUILabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        else
            Tabs.Settings.Content.ToggleUILabel.Text = TRANSLATIONS.ToggleUIVisibility .. ": " .. TRANSLATIONS.Hidden
            Tabs.Settings.Content.ToggleUILabel.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
        Notify(string.format(TRANSLATIONS.UIVisibilityMessage, if isUIVisible then TRANSLATIONS.Visible else TRANSLATIONS.Hidden))
    end
end)

-- Character Added/Removed connections for clean-up (e.g., Fly, Noclip)
LocalPlayer.CharacterAdded:Connect(function(character)
    -- Reset Fly/Noclip states on character respawn
    if FlyState then setupFly(false) setupFly(true) end
    if NoclipState then setupNoclip(false) setupNoclip(true) end
    -- Reset JumpPower
    if character:FindFirstChildOfClass("Humanoid") then
        character.Humanoid.JumpPower = CONFIG.DefaultJumpPower
    end
end)
