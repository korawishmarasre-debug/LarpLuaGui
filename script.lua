-- LarpLuaGui Executor made by @KjgidRPO / @Kaizen0555

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Remove any previous copy so windows don't stack
local old = playerGui:FindFirstChild("LarpLuaGui")
if old then old:Destroy() end

local connections = {}

-- ===== ScreenGui =====
local LarpLuaGui = Instance.new("ScreenGui")
LarpLuaGui.Name = "LarpLuaGui"
LarpLuaGui.DisplayOrder = 50
LarpLuaGui.ResetOnSpawn = false
LarpLuaGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LarpLuaGui.Parent = playerGui

-- ===== Main window =====
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Position = UDim2.new(0.15, 0, 0.2, -75)
MainFrame.Size = UDim2.new(0.6, 101, 0.6, 140)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 3
MainFrame.Parent = LarpLuaGui

local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0.1, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 130, 225)
TitleBar.BorderSizePixel = 3
TitleBar.Text = "LarpLuaGui Executor"
TitleBar.TextColor3 = Color3.fromRGB(235, 235, 240)
TitleBar.TextSize = 24
TitleBar.Font = Enum.Font.Code
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Parent = MainFrame

local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 5)
pad.Parent = TitleBar

local ExitBtn = Instance.new("TextButton")
ExitBtn.Position = UDim2.new(1, -50, 0, 5)
ExitBtn.Size = UDim2.new(0, 45, 0, 30)
ExitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 100)
ExitBtn.BorderSizePixel = 2
ExitBtn.ZIndex = 2
ExitBtn.Text = "exit"
ExitBtn.TextColor3 = Color3.new(1, 1, 1)
ExitBtn.TextSize = 24
ExitBtn.Font = Enum.Font.Cartoon
ExitBtn.Parent = MainFrame

-- ===== Code editor (left) =====
local EditorFrame = Instance.new("Frame")
EditorFrame.Position = UDim2.new(0, 8, 0, 50)
EditorFrame.Size = UDim2.new(1, -218, 0.62, 0)
EditorFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
EditorFrame.BorderSizePixel = 0
EditorFrame.Parent = MainFrame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = EditorFrame

local CodeBox = Instance.new("TextBox")
CodeBox.Size = UDim2.new(1, -6, 1, 0)
CodeBox.AutomaticSize = Enum.AutomaticSize.Y
CodeBox.BackgroundTransparency = 1
CodeBox.ClearTextOnFocus = false
CodeBox.MultiLine = true
CodeBox.TextWrapped = true
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.Font = Enum.Font.Code
CodeBox.TextSize = 16
CodeBox.TextColor3 = Color3.fromRGB(235, 235, 240)
CodeBox.PlaceholderText = "-- Paste your script here..."
CodeBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 150)
CodeBox.Text = ""
CodeBox.Parent = Scroll

-- ===== Output console (bottom left) =====
local OutFrame = Instance.new("Frame")
OutFrame.Position = UDim2.new(0, 8, 0.62, 56)
OutFrame.Size = UDim2.new(1, -218, 0.38, -64)
OutFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
OutFrame.BorderSizePixel = 0
OutFrame.Parent = MainFrame

local Output = Instance.new("TextLabel")
Output.Size = UDim2.new(1, -8, 1, -4)
Output.Position = UDim2.new(0, 4, 0, 2)
Output.BackgroundTransparency = 1
Output.TextWrapped = true
Output.TextXAlignment = Enum.TextXAlignment.Left
Output.TextYAlignment = Enum.TextYAlignment.Top
Output.Font = Enum.Font.Code
Output.TextSize = 14
Output.TextColor3 = Color3.fromRGB(150, 255, 150)
Output.Text = "> Ready"
Output.Parent = OutFrame

-- ===== Button panel (right) =====
local ButtonPanel = Instance.new("Frame")
ButtonPanel.Name = "Frame2"
ButtonPanel.Position = UDim2.new(1, -200, 0, 50)
ButtonPanel.Size = UDim2.new(0, 190, 1, -58)
ButtonPanel.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
ButtonPanel.BorderSizePixel = 0
ButtonPanel.Parent = MainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = ButtonPanel

local bpad = Instance.new("UIPadding")
bpad.PaddingTop = UDim.new(0, 8)
bpad.PaddingLeft = UDim.new(0, 8)
bpad.PaddingRight = UDim.new(0, 8)
bpad.Parent = ButtonPanel

local function makeButton(text, color)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 40)
	b.BackgroundColor3 = color
	b.BorderSizePixel = 0
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.TextSize = 20
	b.Font = Enum.Font.Code
	b.Parent = ButtonPanel
	return b
end

local ExecBtn  = makeButton("Execute", Color3.fromRGB(40, 160, 80))
local ClearBtn = makeButton("Clear",   Color3.fromRGB(200, 120, 30))
local CopyBtn  = makeButton("Copy",    Color3.fromRGB(0, 130, 225))
local PasteBtn = makeButton("Paste",   Color3.fromRGB(120, 90, 200))

-- ===== Logging (replaced by the scrollable console further down) =====
local function log(msg, isError)
	Output.TextColor3 = isError and Color3.fromRGB(255, 110, 110) or Color3.fromRGB(150, 255, 150)
	Output.Text = "> " .. tostring(msg)
end

-- ===== Button actions =====
ExecBtn.MouseButton1Click:Connect(function()
	local src = CodeBox.Text
	if src == "" then
		log("No code to execute", true)
		return
	end
	local fn, compileErr = loadstring(src)
	if not fn then
		log("Syntax error: " .. tostring(compileErr), true)
		return
	end
	local ok, runErr = pcall(fn)
	if ok then
		log("Executed successfully")
	else
		log("Runtime error: " .. tostring(runErr), true)
	end
end)

ClearBtn.MouseButton1Click:Connect(function()
	CodeBox.Text = ""
	log("Editor cleared")
end)

CopyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(CodeBox.Text)
		log("Copied to clipboard")
	else
		log("setclipboard is not supported by this executor", true)
	end
end)

PasteBtn.MouseButton1Click:Connect(function()
	if getclipboard then
		CodeBox.Text = getclipboard()
		log("Pasted from clipboard")
	else
		log("getclipboard is not supported. Long-press the editor to paste manually", true)
	end
end)

ExitBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

-- ===== Window dragging (mouse + touch) =====
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		local d = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + d.X,
			startPos.Y.Scale, startPos.Y.Offset + d.Y
		)
	end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end))

-- ===== Floating toggle button =====
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 225)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "L"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.TextSize = 28
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.ZIndex = 10
ToggleBtn.Parent = LarpLuaGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = ToggleBtn

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(235, 235, 240)
stroke.Thickness = 2
stroke.Parent = ToggleBtn

-- Toggle drag: distinguishes a tap from a drag
local tDragging, tStart, tPos, moved = false, nil, nil, false

ToggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		tDragging = true
		moved = false
		tStart = input.Position
		tPos = ToggleBtn.Position
	end
end)

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
	if tDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		local d = input.Position - tStart
		if d.Magnitude > 6 then moved = true end
		if moved then
			ToggleBtn.Position = UDim2.new(
				tPos.X.Scale, tPos.X.Offset + d.X,
				tPos.Y.Scale, tPos.Y.Offset + d.Y
			)
		end
	end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
	if tDragging and (input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch) then
		tDragging = false
		if not moved then
			MainFrame.Visible = not MainFrame.Visible
		end
	end
end))

-- ===== Autocomplete (Lua API suggestions) =====
local MAX_SHOWN = 6
local ROW_H = 28

local Keywords = {"and","break","continue","do","else","elseif","end","false","for","function","if","in","local","nil","not","or","repeat","return","then","true","until","while"}

local Globals = {"print","warn","error","assert","pcall","xpcall","pairs","ipairs","next","select","type","typeof","tostring","tonumber","require","setmetatable","getmetatable","rawget","rawset","unpack","tick","time","wait","spawn","delay","task","game","workspace","script","os","string","table","math","coroutine","utf8","debug","bit32","Instance","Vector3","Vector2","CFrame","Color3","UDim","UDim2","Enum","Random","TweenInfo","Ray","RaycastParams","Rect","NumberRange","NumberSequence","ColorSequence","BrickColor","Region3"}

local ExecutorAPI = {"loadstring","getgenv","getrenv","getrawmetatable","setrawmetatable","hookfunction","hookmetamethod","newcclosure","checkcaller","getnamecallmethod","setclipboard","getclipboard","request","http_request","firesignal","fireclickdetector","fireproximityprompt","firetouchinterest","getconnections","getinstances","getnilinstances","gethui","identifyexecutor","isexecutorclosure","writefile","readfile","isfile","isfolder","makefolder","listfiles","delfile","appendfile","queue_on_teleport","setfpscap","getcustomasset","cloneref","getscripts","getloadedmodules"}

local Members = {
	string = {"byte","char","find","format","gmatch","gsub","len","lower","match","rep","reverse","split","sub","upper","pack","unpack"},
	table = {"clear","clone","concat","create","find","freeze","insert","isfrozen","move","pack","remove","sort","unpack"},
	math = {"abs","acos","asin","atan","atan2","ceil","clamp","cos","deg","exp","floor","fmod","huge","log","max","min","modf","noise","pi","pow","rad","random","randomseed","round","sign","sin","sqrt","tan"},
	task = {"cancel","defer","delay","desynchronize","spawn","synchronize","wait"},
	os = {"clock","date","difftime","time"},
	coroutine = {"close","create","isyieldable","resume","running","status","wrap","yield"},
	Instance = {"new"},
	Vector3 = {"new","zero","one","xAxis","yAxis","zAxis"},
	Vector2 = {"new","zero","one"},
	CFrame = {"new","Angles","lookAt","fromEulerAnglesXYZ","identity"},
	Color3 = {"new","fromRGB","fromHSV","fromHex"},
	UDim2 = {"new","fromScale","fromOffset"},
	game = {"GetService","FindFirstChild","FindFirstChildOfClass","WaitForChild","GetChildren","GetDescendants","HttpGet","PlaceId","GameId","JobId","IsLoaded","Loaded"},
	workspace = {"CurrentCamera","Gravity","FindFirstChild","WaitForChild","GetChildren","Raycast","Terrain"},
}

local Services = {"Players","Workspace","Lighting","ReplicatedStorage","ReplicatedFirst","ServerStorage","StarterGui","StarterPack","StarterPlayer","RunService","UserInputService","TweenService","HttpService","TeleportService","MarketplaceService","CoreGui","SoundService","Debris","CollectionService","ContextActionService","GuiService","TextService","VirtualUser","PathfindingService","Chat","TextChatService"}

local Classes = {"Part","MeshPart","WedgePart","Model","Folder","Script","LocalScript","ModuleScript","RemoteEvent","RemoteFunction","BindableEvent","BindableFunction","BoolValue","IntValue","NumberValue","StringValue","ObjectValue","Frame","TextLabel","TextButton","TextBox","ImageLabel","ImageButton","ScrollingFrame","ScreenGui","UICorner","UIStroke","UIListLayout","UIPadding","Sound","Highlight","BodyVelocity","BodyPosition","Attachment","Weld","WeldConstraint","Tool","Humanoid","Animation"}

-- Popup UI
local Popup = Instance.new("ScrollingFrame")
Popup.Name = "Suggestions"
Popup.AnchorPoint = Vector2.new(0, 1)
Popup.Position = UDim2.new(0, 8, 0.62, 50)
Popup.Size = UDim2.new(1, -218, 0, 0)
Popup.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
Popup.BorderSizePixel = 0
Popup.ScrollBarThickness = 4
Popup.AutomaticCanvasSize = Enum.AutomaticSize.Y
Popup.CanvasSize = UDim2.new()
Popup.Visible = false
Popup.ZIndex = 20
Popup.Parent = MainFrame

local PopupLayout = Instance.new("UIListLayout")
PopupLayout.Parent = Popup

local suppress = false
local rows = {}

local function hidePopup()
	Popup.Visible = false
end

-- Resolve children of a path like "game.Players" or "workspace"
local function resolvePath(path)
	local parts = string.split(path, ".")
	local obj
	if parts[1] == "game" then obj = game
	elseif parts[1] == "workspace" then obj = workspace
	else return nil end
	for i = 2, #parts do
		local ok, nextObj = pcall(function() return obj:FindFirstChild(parts[i]) end)
		if not ok or not nextObj then return nil end
		obj = nextObj
	end
	return obj
end

local function addAll(dst, src)
	for _, v in ipairs(src) do table.insert(dst, v) end
end

-- Returns candidates, prefix, startIndex
local function getCandidates()
	local pos = CodeBox.CursorPosition
	if pos < 1 then return nil end
	local text = CodeBox.Text
	local before = text:sub(1, pos - 1)

	-- String-argument contexts
	local p = before:match('GetService%(%s*["\']([%w_]*)$')
	if p then return Services, p, pos - #p end
	p = before:match('Instance%.new%(%s*["\']([%w_]*)$')
	if p then return Classes, p, pos - #p end

	local word = before:match("[%w_%.:]*$") or ""
	local base, _, prefix = word:match("^(.-)([%.:])([%w_]*)$")
	local list = {}

	if base then
		local root = base:match("^[%w_]+")
		if Members[base] then addAll(list, Members[base]) end
		if Members[root] and base == root then addAll(list, Members[root]) end
		local obj = resolvePath(base)
		if obj then
			for _, c in ipairs(obj:GetChildren()) do table.insert(list, c.Name) end
			addAll(list, {"Name","Parent","ClassName","Destroy","Clone","FindFirstChild","WaitForChild","GetChildren","GetDescendants","IsA","GetFullName","ChildAdded"})
		end
		return list, prefix, pos - #prefix
	end

	prefix = word
	if #prefix == 0 then return nil end
	addAll(list, Keywords)
	addAll(list, Globals)
	addAll(list, ExecutorAPI)
	-- identifiers already used in the editor
	for w in text:gmatch("[%a_][%w_]*") do
		if #w > 3 then table.insert(list, w) end
	end
	return list, prefix, pos - #prefix
end

local function applySuggestion(choice, startIdx, prefixLen)
	local text = CodeBox.Text
	local newText = text:sub(1, startIdx - 1) .. choice .. text:sub(startIdx + prefixLen)
	suppress = true
	CodeBox.Text = newText
	CodeBox.CursorPosition = startIdx + #choice
	suppress = false
	hidePopup()
	CodeBox:CaptureFocus()
end

local function showSuggestions()
	if suppress or not CodeBox:IsFocused() then return end
	local list, prefix, startIdx = getCandidates()
	if not list then hidePopup() return end

	local lowered, seen, matches = prefix:lower(), {}, {}
	for _, name in ipairs(list) do
		if not seen[name] and name ~= prefix and name:sub(1, #lowered):lower() == lowered then
			seen[name] = true
			table.insert(matches, name)
		end
	end
	if #matches == 0 then hidePopup() return end
	table.sort(matches, function(a, b)
		if #a ~= #b then return #a < #b end
		return a < b
	end)

	for _, r in ipairs(rows) do r:Destroy() end
	rows = {}

	for i = 1, math.min(#matches, 20) do
		local name = matches[i]
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -6, 0, ROW_H)
		b.BackgroundColor3 = Color3.fromRGB(45, 45, 56)
		b.BorderSizePixel = 0
		b.Text = "  " .. name
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.TextColor3 = Color3.fromRGB(235, 235, 240)
		b.Font = Enum.Font.Code
		b.TextSize = 15
		b.ZIndex = 21
		b.LayoutOrder = i
		b.Parent = Popup
		b.Activated:Connect(function()
			applySuggestion(name, startIdx, #prefix)
		end)
		table.insert(rows, b)
	end

	Popup.Size = UDim2.new(1, -218, 0, math.min(#matches, MAX_SHOWN) * ROW_H)
	Popup.CanvasPosition = Vector2.new(0, 0)
	Popup.Visible = true
end

CodeBox:GetPropertyChangedSignal("Text"):Connect(showSuggestions)
CodeBox:GetPropertyChangedSignal("CursorPosition"):Connect(showSuggestions)
CodeBox.FocusLost:Connect(function()
	task.delay(0.3, function()
		if not CodeBox:IsFocused() then hidePopup() end
	end)
end)

-- ===== Version + Settings =====
local VERSION = "v1.0.0"
local SETTINGS_FILE = "LarpLuaGui_settings.json"

local Accents = {
	Blue   = Color3.fromRGB(0, 130, 225),
	Red    = Color3.fromRGB(220, 60, 60),
	Green  = Color3.fromRGB(40, 170, 90),
	Purple = Color3.fromRGB(130, 90, 220),
	Orange = Color3.fromRGB(230, 130, 30),
	Pink   = Color3.fromRGB(230, 80, 150),
}
local AccentOrder = {"Blue", "Red", "Green", "Purple", "Orange", "Pink"}

local Backgrounds = {
	Dark     = Color3.fromRGB(40, 40, 40),
	Darker   = Color3.fromRGB(20, 20, 24),
	Midnight = Color3.fromRGB(20, 24, 40),
	Slate    = Color3.fromRGB(45, 50, 65),
}
local BackgroundOrder = {"Dark", "Darker", "Midnight", "Slate"}

local FontOrder = {"Code", "RobotoMono", "SourceSans", "Gotham", "Ubuntu", "Arial", "Arcade"}

local Default = {
	Accent = "Blue",
	Background = "Dark",
	Font = "Code",
	TextSize = 16,
	Transparency = 0,
	ToggleSize = 50,
	Autocomplete = true,
	Hotkey = true,
}

local Settings = {}
for k, v in pairs(Default) do Settings[k] = v end

-- Load saved settings (if the executor supports file functions)
if isfile and readfile then
	pcall(function()
		if isfile(SETTINGS_FILE) then
			local data = HttpService:JSONDecode(readfile(SETTINGS_FILE))
			for k, v in pairs(Default) do
				if data[k] ~= nil and type(data[k]) == type(v) then
					Settings[k] = data[k]
				end
			end
		end
	end)
end

local function saveSettings()
	if writefile then
		pcall(function()
			writefile(SETTINGS_FILE, HttpService:JSONEncode(Settings))
		end)
	end
end

local refreshers = {}

local function applySettings()
	local accent = Accents[Settings.Accent] or Accents.Blue
	local bg = Backgrounds[Settings.Background] or Backgrounds.Dark
	local okFont, font = pcall(function() return Enum.Font[Settings.Font] end)
	if not okFont or not font then font = Enum.Font.Code end

	TitleBar.BackgroundColor3 = accent
	TitleBar.Font = font
	MainFrame.BackgroundColor3 = bg
	ToggleBtn.BackgroundColor3 = accent
	ToggleBtn.Size = UDim2.new(0, Settings.ToggleSize, 0, Settings.ToggleSize)
	ToggleBtn.TextSize = math.floor(Settings.ToggleSize * 0.56)

	CodeBox.Font = font
	CodeBox.TextSize = Settings.TextSize
	Output.Font = font
	Output.TextSize = math.max(10, Settings.TextSize - 2)

	for _, f in ipairs({MainFrame, EditorFrame, OutFrame, ButtonPanel}) do
		f.BackgroundTransparency = Settings.Transparency
	end

	if not Settings.Autocomplete and Popup then
		Popup.Visible = false
	end

	for _, fn in ipairs(refreshers) do fn() end
end

local function change()
	applySettings()
	saveSettings()
end

-- Version in the title bar
TitleBar.Text = "LarpLuaGui Executor | " .. VERSION

-- Settings button
local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Name = "SettingsBtn"
SettingsBtn.Position = UDim2.new(1, -135, 0, 5)
SettingsBtn.Size = UDim2.new(0, 80, 0, 30)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
SettingsBtn.BorderSizePixel = 2
SettingsBtn.ZIndex = 2
SettingsBtn.Text = "Settings"
SettingsBtn.TextColor3 = Color3.new(1
