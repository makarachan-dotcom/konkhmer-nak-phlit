-- Script: KONKHMER NAK PHLIT
-- Language: Khmer
-- Version: 3 (Enhanced Evasion)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local CONFIG = {
    WindowSize = UDim2.new(0, 300, 0, 450),
    DefaultWalkSpeed = 16,
    SlowWalkSpeed = 5, -- Default slow speed
    MenuToggleKey = Enum.KeyCode.RightShift, -- Key to toggle UI visibility
    WalkSpeedTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), -- Smooth speed change
}

-- Khmer Translations
local TRANSLATIONS = {
    WindowTitle = "កូនខ្មែរ អ្នកផលិត",
    HomeTab = "ទំព័រដើម",
    SpeedTab = "ល្បឿន",
    StealTab = "លួច",
    SettingsTab = "កំណត់",

    -- Home Tab
    WelcomeMessage = "សូមស្វាគមន៍មកកាន់ កូនខ្មែរ អ្នកផលិត",
    Instructions = "ប្រើផ្ទាំងខាងលើដើម្បីចូលប្រើមុខងារ",

    -- Speed Tab
    SelectPlayer = "ជ្រើសរើសអ្នកលេង",
    SlowAllPlayers = "បន្ថយល្បឿនជើងទាំងអស់",
    WalkSpeedAmount = "បរិមាណល្បឿនជើង",
    ApplySpeed = "អនុវត្តល្បឿន",
    ResetSpeed = "កំណត់ល្បឿនដើម",
    PlayerWalkSpeedSet = "បានកំណត់ល្បឿនជើងរបស់ %s ទៅ %d",
    AllPlayersWalkSpeedSet = "បានកំណត់ល្បឿនជើងអ្នកលេងទាំងអស់ទៅ %d",
    PlayerNotFound = "រកមិនឃើញអ្នកលេង '%s' ទេ",

    -- Steal Tab
    StealPanelTitle = "ផ្ទាំងលួច",
    TeleportToPlayer = "បញ្ជូនទៅអ្នកលេង",
    StealItemPlaceholder = "មុខងារលួចរបស់ (អត់ទាន់មាន)",
    SelectPlayerToSteal = "ជ្រើសរើសអ្នកលេងដើម្បីលួច",
    TeleportedTo = "បានបញ្ជូនទៅ %s",
    TeleportWarning = "ការបញ្ជូននេះមានហានិភ័យខ្ពស់ក្នុងការត្រូវបានចាប់ដោយ Anti-cheat!",

    -- Settings Tab
    ToggleUIVisibility = "បង្ហាញ/លាក់ UI",
    UICustomization = "ការកំណត់ UI",
    UIBackgroundTransparency = "តម្លាភាពផ្ទៃខាងក្រោយ UI",
    UISize = "ទំហំ UI (ទទឹង x កម្ពស់)",
    ApplyUISettings = "អនុវត្តការកំណត់ UI",
    UIVisibilityMessage = "UI ឥឡូវ %s",
    Visible = "បង្ហាញ",
    Hidden = "លាក់",
}

-- UI Elements
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KONKHMER_NAK_PHLIT_GUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = CONFIG.WindowSize
MainFrame.Position = UDim2.new(0.5, -CONFIG.WindowSize.X.Offset / 2, 0.5, -CONFIG.WindowSize.Y.Offset / 2)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true -- Important for rounded corners and clean UI

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = TRANSLATIONS.WindowTitle
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextWrapped = true
TitleLabel.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local TabPanel = Instance.new("Frame")
TabPanel.Name = "TabPanel"
TabPanel.Size = UDim2.new(1, 0, 0, 30)
TabPanel.Position = UDim2.new(0, 0, 0, 30)
TabPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TabPanel.BorderSizePixel = 0
TabPanel.Parent = MainFrame

local UIListLayout_Tabs = Instance.new("UIListLayout")
UIListLayout_Tabs.Name = "TabListLayout"
UIListLayout_Tabs.FillDirection = Enum.FillDirection.Horizontal
UIListLayout_Tabs.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout_Tabs.Padding = UDim.new(0, 5)
UIListLayout_Tabs.Parent = TabPanel

local TabContentFrame = Instance.new("Frame")
TabContentFrame.Name = "TabContentFrame"
TabContentFrame.Size = UDim2.new(1, -10, 1, -70)
TabContentFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2 + 5, 0, 65)
TabContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabContentFrame.BackgroundTransparency = 0
TabContentFrame.BorderSizePixel = 0
TabContentFrame.Parent = MainFrame
TabContentFrame.ClipsDescendants = true

local activeTab = nil

local function createTabButton(name, translation)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "TabButton"
    Button.Size = UDim2.new(0, 70, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.BorderSizePixel = 0
    Button.Text = translation
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 15
    Button.Font = Enum.Font.Gotham
    Button.Parent = TabPanel

    local UICorner_Btn = Instance.new("UICorner")
    UICorner_Btn.CornerRadius = UDim.new(0, 5)
    UICorner_Btn.Parent = Button

    return Button
end

local function createTabContent(name)
    local Frame = Instance.new("Frame")
    Frame.Name = name .. "TabContent"
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.Position = UDim2.new(0, 0, 0, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
    UIPadding_Content.PaddingTop = UDim.new(0, 10)
    UIPadding_Content.PaddingBottom = UDim.new(0, 10)
    UIPadding_Content.PaddingLeft = UDim.new(0, 10)
    UIPadding_Content.PaddingRight = UDim.new(0, 10)
    UIPadding_Content.Parent = Frame

    return Frame
end

local Tabs = {
    Home = {
        Button = createTabButton("Home", TRANSLATIONS.HomeTab),
        Content = createTabContent("Home")
    },
    Speed = {
        Button = createTabButton("Speed", TRANSLATIONS.SpeedTab),
        Content = createTabContent("Speed")
    },
    Steal = {
        Button = createTabButton("Steal", TRANSLATIONS.StealTab),
        Content = createTabContent("Steal")
    },
    Settings = {
        Button = createTabButton("Settings", TRANSLATIONS.SettingsTab),
        Content = createTabContent("Settings")
    },
}

local function setActiveTab(tabName)
    if activeTab then
        Tabs[activeTab].Content.Visible = false
        Tabs[activeTab].Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
    Tabs[tabName].Content.Visible = true
    Tabs[tabName].Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Highlight active tab
    activeTab = tabName
end

-- Home Tab Content
do
    local HomeContent = Tabs.Home.Content

    local WelcomeLabel = Instance.new("TextLabel")
    WelcomeLabel.Name = "WelcomeLabel"
    WelcomeLabel.Size = UDim2.new(1, 0, 0, 40)
    WelcomeLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Text = TRANSLATIONS.WelcomeMessage
    WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WelcomeLabel.TextSize = 20
    WelcomeLabel.Font = Enum.Font.GothamBold
    WelcomeLabel.TextWrapped = true
    WelcomeLabel.Parent = HomeContent

    local InstructionsLabel = Instance.new("TextLabel")
    InstructionsLabel.Name = "InstructionsLabel"
    InstructionsLabel.Size = UDim2.new(1, 0, 0, 60)
    InstructionsLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    InstructionsLabel.BackgroundTransparency = 1
    InstructionsLabel.Text = TRANSLATIONS.Instructions
    InstructionsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    InstructionsLabel.TextSize = 16
    InstructionsLabel.Font = Enum.Font.Gotham
    InstructionsLabel.TextWrapped = true
    InstructionsLabel.Parent = HomeContent
end

-- Speed Tab Content
do
    local SpeedContent = Tabs.Speed.Content

    local PlayerInputLabel = Instance.new("TextLabel")
    PlayerInputLabel.Name = "PlayerInputLabel"
    PlayerInputLabel.Size = UDim2.new(1, 0, 0, 20)
    PlayerInputLabel.BackgroundTransparency = 1
    PlayerInputLabel.Text = TRANSLATIONS.SelectPlayer
    PlayerInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerInputLabel.TextSize = 14
    PlayerInputLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerInputLabel.Parent = SpeedContent

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
    PlayerInputField.Parent = SpeedContent

    local UICorner_PlayerInput = Instance.new("UICorner")
    UICorner_PlayerInput.CornerRadius = UDim.new(0, 5)
    UICorner_PlayerInput.Parent = PlayerInputField

    local SlowAllToggle = Instance.new("TextButton")
    SlowAllToggle.Name = "SlowAllToggle"
    SlowAllToggle.Size = UDim2.new(1, 0, 0, 30)
    SlowAllToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SlowAllToggle.BorderSizePixel = 0
    SlowAllToggle.Text = TRANSLATIONS.SlowAllPlayers .. ": បិទ"
    SlowAllToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SlowAllToggle.TextSize = 16
    SlowAllToggle.Font = Enum.Font.Gotham
    SlowAllToggle.Parent = SpeedContent

    local UICorner_SlowAllToggle = Instance.new("UICorner")
    UICorner_SlowAllToggle.CornerRadius = UDim.new(0, 5)
    UICorner_SlowAllToggle.Parent = SlowAllToggle

    local isSlowAllEnabled = false
    SlowAllToggle.MouseButton1Click:Connect(function()
        isSlowAllEnabled = not isSlowAllEnabled
        if isSlowAllEnabled then
            SlowAllToggle.Text = TRANSLATIONS.SlowAllPlayers .. ": បើក"
            SlowAllToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        else
            SlowAllToggle.Text = TRANSLATIONS.SlowAllPlayers .. ": បិទ"
            SlowAllToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end)

    local WalkSpeedLabel = Instance.new("TextLabel")
    WalkSpeedLabel.Name = "WalkSpeedLabel"
    WalkSpeedLabel.Size = UDim2.new(1, 0, 0, 20)
    WalkSpeedLabel.BackgroundTransparency = 1
    WalkSpeedLabel.Text = TRANSLATIONS.WalkSpeedAmount .. ": " .. CONFIG.SlowWalkSpeed
    WalkSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WalkSpeedLabel.TextSize = 14
    WalkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    WalkSpeedLabel.Parent = SpeedContent

    local WalkSpeedInput = Instance.new("TextBox")
    WalkSpeedInput.Name = "WalkSpeedInput"
    WalkSpeedInput.Size = UDim2.new(1, 0, 0, 30)
    WalkSpeedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    WalkSpeedInput.BorderSizePixel = 0
    WalkSpeedInput.Text = tostring(CONFIG.SlowWalkSpeed)
    WalkSpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    WalkSpeedInput.TextSize = 14
    WalkSpeedInput.Font = Enum.Font.Gotham
    WalkSpeedInput.Parent = SpeedContent
    WalkSpeedInput.TextScaled = false
    WalkSpeedInput.TextXAlignment = Enum.TextXAlignment.Left

    WalkSpeedInput.Changed:Connect(function(property)
        if property == "Text" then
            local newSpeed = tonumber(WalkSpeedInput.Text)
            if newSpeed and newSpeed >= 0 then
                WalkSpeedLabel.Text = TRANSLATIONS.WalkSpeedAmount .. ": " .. newSpeed
            end
        end
    end)

    local UICorner_WalkSpeedInput = Instance.new("UICorner")
    UICorner_WalkSpeedInput.CornerRadius = UDim.new(0, 5)
    UICorner_WalkSpeedInput.Parent = WalkSpeedInput

    local ApplySpeedButton = Instance.new("TextButton")
    ApplySpeedButton.Name = "ApplySpeedButton"
    ApplySpeedButton.Size = UDim2.new(1, 0, 0, 30)
    ApplySpeedButton.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
    ApplySpeedButton.BorderSizePixel = 0
    ApplySpeedButton.Text = TRANSLATIONS.ApplySpeed
    ApplySpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ApplySpeedButton.TextSize = 16
    ApplySpeedButton.Font = Enum.Font.GothamBold
    ApplySpeedButton.Parent = SpeedContent

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
    ResetSpeedButton.Parent = SpeedContent

    local UICorner_ResetSpeedButton = Instance.new("UICorner")
    UICorner_ResetSpeedButton.CornerRadius = UDim.new(0, 5)
    UICorner_ResetSpeedButton.Parent = ResetSpeedButton

    local function applyWalkSpeed(player, speed)
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character.Humanoid
            TweenService:Create(humanoid, CONFIG.WalkSpeedTweenInfo, {WalkSpeed = speed}):Play()
        end
    end

    ApplySpeedButton.MouseButton1Click:Connect(function()
        local targetSpeed = tonumber(WalkSpeedInput.Text) or CONFIG.SlowWalkSpeed
        if targetSpeed < 0 then targetSpeed = 0 end

        if isSlowAllEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                applyWalkSpeed(player, targetSpeed)
            end
            print(string.format(TRANSLATIONS.AllPlayersWalkSpeedSet, targetSpeed))
        else
            local targetPlayerName = PlayerInputField.Text
            if targetPlayerName == "" then
                applyWalkSpeed(LocalPlayer, targetSpeed)
                print(string.format(TRANSLATIONS.PlayerWalkSpeedSet, LocalPlayer.Name, targetSpeed))
            else
                local targetPlayer = Players:FindFirstChild(targetPlayerName)
                if targetPlayer then
                    applyWalkSpeed(targetPlayer, targetSpeed)
                    print(string.format(TRANSLATIONS.PlayerWalkSpeedSet, targetPlayer.Name, targetSpeed))
                else
                    print(string.format(TRANSLATIONS.PlayerNotFound, targetPlayerName))
                end
            end
        end
    end)

    ResetSpeedButton.MouseButton1Click:Connect(function()
        if isSlowAllEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                applyWalkSpeed(player, CONFIG.DefaultWalkSpeed)
            end
            print(string.format(TRANSLATIONS.AllPlayersWalkSpeedSet, CONFIG.DefaultWalkSpeed))
        else
            local targetPlayerName = PlayerInputField.Text
            if targetPlayerName == "" then
                applyWalkSpeed(LocalPlayer, CONFIG.DefaultWalkSpeed)
                print(string.format(TRANSLATIONS.PlayerWalkSpeedSet, LocalPlayer.Name, CONFIG.DefaultWalkSpeed))
            else
                local targetPlayer = Players:FindFirstChild(targetPlayerName)
                if targetPlayer then
                    applyWalkSpeed(targetPlayer, CONFIG.DefaultWalkSpeed)
                    print(string.format(TRANSLATIONS.PlayerWalkSpeedSet, targetPlayer.Name, CONFIG.DefaultWalkSpeed))
                else
                    print(string.format(TRANSLATIONS.PlayerNotFound, targetPlayerName))
                end
            end
        end
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
    StealTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    StealTitle.TextSize = 18
    StealTitle.Font = Enum.Font.GothamBold
    StealTitle.Parent = StealContent

    local PlayerSelectionLabel = Instance.new("TextLabel")
    PlayerSelectionLabel.Name = "PlayerSelectionLabel"
    PlayerSelectionLabel.Size = UDim2.new(1, 0, 0, 20)
    PlayerSelectionLabel.BackgroundTransparency = 1
    PlayerSelectionLabel.Text = TRANSLATIONS.SelectPlayerToSteal
    PlayerSelectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerSelectionLabel.TextSize = 14
    PlayerSelectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerSelectionLabel.Parent = StealContent

    local StealPlayerInputField = Instance.new("TextBox")
    StealPlayerInputField.Name = "StealPlayerInputField"
    StealPlayerInputField.Size = UDim2.new(1, 0, 0, 30)
    StealPlayerInputField.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    StealPlayerInputField.BorderSizePixel = 0
    StealPlayerInputField.PlaceholderText = TRANSLATIONS.SelectPlayer
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
                print(string.format(TRANSLATIONS.TeleportedTo, targetPlayer.Name))
                print(TRANSLATIONS.TeleportWarning)
            end
        else
            print(string.format(TRANSLATIONS.PlayerNotFound, targetPlayerName))
        end
    end)

    local StealItemButton = Instance.new("TextButton")
    StealItemButton.Name = "StealItemButton"
    StealItemButton.Size = UDim2.new(1, 0, 0, 30)
    StealItemButton.BackgroundColor3 = Color3.fromRGB(150, 50, 80)
    StealItemButton.BorderSizePixel = 0
    StealItemButton.Text = TRANSLATIONS.StealItemPlaceholder
    StealItemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    StealItemButton.TextSize = 16
    StealItemButton.Font = Enum.Font.GothamBold
    StealItemButton.Parent = StealContent
    StealItemButton.Active = false -- Placeholder, not functional

    local UICorner_StealItemButton = Instance.new("UICorner")
    UICorner_StealItemButton.CornerRadius = UDim.new(0, 5)
    UICorner_StealItemButton.Parent = StealItemButton
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
        print(string.format(TRANSLATIONS.UIVisibilityMessage, if MainFrame.Visible then TRANSLATIONS.Visible else TRANSLATIONS.Hidden))
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
    UISizeInput.PlaceholderText = "Width x Height (e.g., 300x450)"
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
                TabContentFrame.Size = UDim2.new(1, -10, 1, -(30 + 30 + 5)) -- TitleBar + TabPanel + Padding
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
        print(string.format(TRANSLATIONS.UIVisibilityMessage, if isUIVisible then TRANSLATIONS.Visible else TRANSLATIONS.Hidden))
    end
end)

-- Notification System (Simple Print to Output)
local function Notify(message)
    print("通知: " .. message)
end
