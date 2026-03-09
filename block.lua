-- ============================================================
-- Music Block System v1.0
-- Fortnite Style - My Stupid Heart
-- Walk Speed 16 | 84 Blocks | ~413 studs track
-- ============================================================

local Players      = game:GetService("Players")
local VIM          = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RS           = game:GetService("RunService")

local player = Players.LocalPlayer
local char   = player.Character or player.CharacterAdded:Wait()
local hrp    = char:WaitForChild("HumanoidRootPart")
local hum    = char:WaitForChild("Humanoid")

-- ============================================================
-- 定数
-- ============================================================
local WALK_SPEED   = 16     -- プレイヤー速度 (studs/s)
local BLOCK_W      = 6      -- ブロック幅 (X) - 踏みやすいサイズ
local BLOCK_H      = 1.2    -- ブロック高さ (Y)
local START_DIST   = 20     -- プレイヤー前方の開始距離 (studs)
local MIN_DEPTH    = 1.5    -- ブロック最小奥行き (studs)
local MAX_DEPTH    = 5.0    -- ブロック最大奥行き (studs)

-- ============================================================
-- キーマップ
-- ============================================================
local BLACK = {
    ["!"] = Enum.KeyCode.One,   ["@"] = Enum.KeyCode.Two,
    ["$"] = Enum.KeyCode.Four,  ["%"] = Enum.KeyCode.Five,
    ["^"] = Enum.KeyCode.Six,   ["*"] = Enum.KeyCode.Eight,
    ["("] = Enum.KeyCode.Nine,
    ["Q"] = Enum.KeyCode.Q, ["W"] = Enum.KeyCode.W, ["E"] = Enum.KeyCode.E,
    ["T"] = Enum.KeyCode.T, ["Y"] = Enum.KeyCode.Y, ["I"] = Enum.KeyCode.I,
    ["O"] = Enum.KeyCode.O, ["P"] = Enum.KeyCode.P,
    ["S"] = Enum.KeyCode.S, ["D"] = Enum.KeyCode.D, ["G"] = Enum.KeyCode.G,
    ["H"] = Enum.KeyCode.H, ["J"] = Enum.KeyCode.J,
    ["L"] = Enum.KeyCode.L, ["Z"] = Enum.KeyCode.Z,
    ["C"] = Enum.KeyCode.C, ["V"] = Enum.KeyCode.V, ["B"] = Enum.KeyCode.B,
}
local WHITE = {
    ["1"] = Enum.KeyCode.One,   ["2"] = Enum.KeyCode.Two,
    ["3"] = Enum.KeyCode.Three, ["4"] = Enum.KeyCode.Four,
    ["5"] = Enum.KeyCode.Five,  ["6"] = Enum.KeyCode.Six,
    ["7"] = Enum.KeyCode.Seven, ["8"] = Enum.KeyCode.Eight,
    ["9"] = Enum.KeyCode.Nine,  ["0"] = Enum.KeyCode.Zero,
    ["q"] = Enum.KeyCode.Q, ["w"] = Enum.KeyCode.W, ["e"] = Enum.KeyCode.E,
    ["r"] = Enum.KeyCode.R, ["t"] = Enum.KeyCode.T, ["y"] = Enum.KeyCode.Y,
    ["u"] = Enum.KeyCode.U, ["i"] = Enum.KeyCode.I, ["o"] = Enum.KeyCode.O,
    ["p"] = Enum.KeyCode.P, ["a"] = Enum.KeyCode.A, ["s"] = Enum.KeyCode.S,
    ["d"] = Enum.KeyCode.D, ["f"] = Enum.KeyCode.F, ["g"] = Enum.KeyCode.G,
    ["h"] = Enum.KeyCode.H, ["j"] = Enum.KeyCode.J, ["k"] = Enum.KeyCode.K,
    ["l"] = Enum.KeyCode.L, ["z"] = Enum.KeyCode.Z, ["x"] = Enum.KeyCode.X,
    ["c"] = Enum.KeyCode.C, ["v"] = Enum.KeyCode.V, ["b"] = Enum.KeyCode.B,
    ["n"] = Enum.KeyCode.N, ["m"] = Enum.KeyCode.M,
}
local PITCH = {
    ["1"]=36, ["!"]=37, ["2"]=38, ["@"]=39, ["3"]=40, ["4"]=41, ["$"]=42,
    ["5"]=43, ["%"]=44, ["6"]=45, ["^"]=46, ["7"]=47,
    ["8"]=48, ["*"]=49, ["9"]=50, ["("]=51, ["0"]=52, ["q"]=53, ["Q"]=54,
    ["w"]=55, ["W"]=56, ["e"]=57, ["E"]=58, ["r"]=59,
    ["t"]=60, ["T"]=61, ["y"]=62, ["Y"]=63, ["u"]=64, ["i"]=65, ["I"]=66,
    ["o"]=67, ["O"]=68, ["p"]=69, ["P"]=70, ["a"]=71,
    ["s"]=72, ["S"]=73, ["d"]=74, ["D"]=75, ["f"]=76, ["g"]=77, ["G"]=78,
    ["h"]=79, ["H"]=80, ["j"]=81, ["J"]=82, ["k"]=83,
    ["l"]=84, ["L"]=85, ["z"]=86, ["Z"]=87, ["x"]=88, ["c"]=89, ["C"]=90,
    ["v"]=91, ["V"]=92, ["b"]=93, ["B"]=94, ["n"]=95, ["m"]=96,
}

-- ============================================================
-- pressKey (Shift競合解消付き)
-- ============================================================
local _shiftLock  = false
local _shiftQueue = {}

local function _flushShiftQueue()
    if _shiftLock or #_shiftQueue == 0 then return end
    _shiftLock = true
    task.spawn(function()
        while #_shiftQueue > 0 do
            local kc = table.remove(_shiftQueue, 1)
            VIM:SendKeyEvent(true,  Enum.KeyCode.LeftShift, false, game)
            task.wait(0.004)
            VIM:SendKeyEvent(true,  kc, false, game)
            task.wait(0.040)
            VIM:SendKeyEvent(false, kc, false, game)
            task.wait(0.006)
            VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
            task.wait(0.005)
        end
        _shiftLock = false
    end)
end

local function pressKey(k)
    if BLACK[k] then
        table.insert(_shiftQueue, BLACK[k])
        _flushShiftQueue()
    elseif WHITE[k] then
        local kc = WHITE[k]
        task.spawn(function()
            local w = 0
            while _shiftLock and w < 0.06 do
                RS.Heartbeat:Wait(); w += 0.016
            end
            VIM:SendKeyEvent(true,  kc, false, game)
            task.delay(0.040, function()
                VIM:SendKeyEvent(false, kc, false, game)
            end)
        end)
    end
end

-- ============================================================
-- ピッチに基づくブロックカラー
-- ============================================================
local function pitchToColor(p)
    if     p < 48 then return Color3.fromRGB(60,  80,  255) -- 深青: 低音
    elseif p < 56 then return Color3.fromRGB(80,  200, 255) -- 水色
    elseif p < 64 then return Color3.fromRGB(80,  255, 120) -- 緑
    elseif p < 72 then return Color3.fromRGB(255, 240, 60)  -- 黄
    elseif p < 80 then return Color3.fromRGB(255, 140, 40)  -- オレンジ
    elseif p < 88 then return Color3.fromRGB(255, 60,  60)  -- 赤
    else               return Color3.fromRGB(220, 60,  255) end -- 紫: 高音
end

-- ============================================================
-- ノートグループデータ (My Stupid Heart - MIDI)
-- 84グループ / 222ノート / 24.57秒
-- ============================================================
local noteGroups = {
    {time=0.302, keys={"k"}, pitch=83},
    {time=0.627, keys={"j"}, pitch=81},
    {time=0.941, keys={"h"}, pitch=79},
    {time=1.254, keys={"x","f","u","h","0"}, pitch=72},
    {time=1.602, keys={"r"}, pitch=59},
    {time=1.893, keys={"u","0"}, pitch=58},
    {time=2.207, keys={"j","u","r"}, pitch=68},
    {time=2.498, keys={"f","w","u","k"}, pitch=70},
    {time=2.823, keys={"o","y"}, pitch=64},
    {time=3.159, keys={"h","o","0","w"}, pitch=63},
    {time=3.473, keys={"z","0"}, pitch=69},
    {time=3.786, keys={"8","x","f","t"}, pitch=68},
    {time=3.868, keys={"1"}, pitch=36},
    {time=4.112, keys={"x","f","w","t"}, pitch=70},
    {time=4.182, keys={"1"}, pitch=36},
    {time=4.415, keys={"x","h","f","t","8"}, pitch=70},
    {time=4.728, keys={"z","t"}, pitch=73},
    {time=5.053, keys={"k","f","w"}, pitch=71},
    {time=5.193, keys={"1","o"}, pitch=52},
    {time=5.390, keys={"o","y"}, pitch=64},
    {time=5.692, keys={"o","w"}, pitch=61},
    {time=5.784, keys={"8"}, pitch=48},
    {time=6.018, keys={"z"}, pitch=86},
    {time=6.320, keys={"8","x","h","f","t"}, pitch=70},
    {time=6.633, keys={"x","h","f","t","w"}, pitch=72},
    {time=6.935, keys={"h","x","f","t","8","1"}, pitch=64},
    {time=7.260, keys={"z","f"}, pitch=81},
    {time=7.574, keys={"k","f","o","w"}, pitch=70},
    {time=7.910, keys={"y"}, pitch=62},
    {time=8.214, keys={"t","o","w"}, pitch=61},
    {time=8.527, keys={"k","o","w"}, pitch=68},
    {time=8.817, keys={"f","j","9","8","p"}, pitch=65},
    {time=9.154, keys={"j","Q","G","8"}, pitch=65},
    {time=9.468, keys={"j","e","y"}, pitch=67},
    {time=9.781, keys={"h","d","e","t"}, pitch=68},
    {time=9.920, keys={"9"}, pitch=50},
    {time=10.084, keys={"Q","j","p","y","9","e"}, pitch=62},
    {time=10.385, keys={"k","Q"}, pitch=68},
    {time=10.723, keys={"j","f","e","y"}, pitch=69},
    {time=11.035, keys={"h","d","e","t"}, pitch=68},
    {time=11.338, keys={"v","x","h","f","Q","0","6"}, pitch=69},
    {time=11.686, keys={"r"}, pitch=59},
    {time=11.977, keys={"u","0"}, pitch=58},
    {time=12.279, keys={"j","y","r"}, pitch=67},
    {time=12.581, keys={"f","k","u","w"}, pitch=70},
    {time=12.895, keys={"o","y"}, pitch=64},
    {time=13.255, keys={"o","w"}, pitch=61},
    {time=13.545, keys={"z"}, pitch=86},
    {time=13.870, keys={"8","x","t","1"}, pitch=58},
    {time=14.184, keys={"C","w"}, pitch=72},
    {time=14.498, keys={"x","t","w"}, pitch=68},
    {time=14.568, keys={"1"}, pitch=36},
    {time=14.789, keys={"z"}, pitch=86},
    {time=15.172, keys={"k","w","q"}, pitch=64},
    {time=15.497, keys={"y"}, pitch=62},
    {time=15.682, keys={"1"}, pitch=36},
    {time=15.822, keys={"o","t","w"}, pitch=61},
    {time=16.114, keys={"z"}, pitch=86},
    {time=16.439, keys={"k","t","x","8"}, pitch=70},
    {time=16.752, keys={"w","x"}, pitch=72},
    {time=17.077, keys={"x","h","t","w","1"}, pitch=64},
    {time=17.379, keys={"z","t"}, pitch=73},
    {time=17.704, keys={"w","o","k"}, pitch=68},
    {time=18.019, keys={"y"}, pitch=62},
    {time=18.355, keys={"h","o","y","w"}, pitch=66},
    {time=18.646, keys={"k","w","o"}, pitch=68},
    {time=18.971, keys={"9","w"}, pitch=52},
    {time=19.086, keys={"G"}, pitch=78},
    {time=19.284, keys={"Q","j"}, pitch=68},
    {time=19.609, keys={"j","e","y","9"}, pitch=62},
    {time=19.913, keys={"h","o"}, pitch=73},
    {time=20.215, keys={"G","j","p","9"}, pitch=70},
    {time=20.528, keys={"k","Q"}, pitch=68},
    {time=20.865, keys={"j","e","y"}, pitch=67},
    {time=21.167, keys={"h"}, pitch=79},
    {time=21.492, keys={"0","h","Q"}, pitch=62},
    {time=21.793, keys={"r"}, pitch=59},
    {time=22.108, keys={"h","u","0"}, pitch=65},
    {time=22.723, keys={"h","u","o","w","0"}, pitch=63},
    {time=23.025, keys={"y"}, pitch=62},
    {time=23.339, keys={"h","o"}, pitch=73},
    {time=23.932, keys={"h","8"}, pitch=64},
    {time=24.257, keys={"0"}, pitch=52},
    {time=24.571, keys={"4"}, pitch=41}
}

-- ============================================================
-- ブロック生成
-- ============================================================
local function buildBlocks()
    -- 既存ブロック削除
    local old = workspace:FindFirstChild("MusicBlocks")
    if old then old:Destroy() end

    local blockFolder = Instance.new("Folder")
    blockFolder.Name  = "MusicBlocks"
    blockFolder.Parent = workspace

    -- キャラクター再取得
    char = player.Character or player.CharacterAdded:Wait()
    hrp  = char:WaitForChild("HumanoidRootPart")
    hum  = char:WaitForChild("Humanoid")
    hum.WalkSpeed = WALK_SPEED

    -- 地面高さをレイキャストで取得
    local rcParams = RaycastParams.new()
    rcParams.FilterDescendantsInstances = {char}
    rcParams.FilterType = Enum.RaycastFilterType.Exclude
    local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -15, 0), rcParams)
    local groundY = ray and ray.Position.Y or (hrp.Position.Y - 3.1)

    -- プレイヤーの向きを固定 (Y軸回転のみ)
    local startCF   = hrp.CFrame
    local lookVec   = Vector3.new(startCF.LookVector.X, 0, startCF.LookVector.Z).Unit
    local rightVec  = Vector3.new(startCF.RightVector.X, 0, startCF.RightVector.Z).Unit
    local startPos  = hrp.Position

    local blockY = groundY + BLOCK_H / 2  -- ブロック中心Y

    -- 各グループにブロック作成
    for gi, group in ipairs(noteGroups) do
        local dist = START_DIST + group.time * WALK_SPEED

        -- 次グループとの間隔からブロック奥行きを算出
        local nextTime  = noteGroups[gi + 1] and noteGroups[gi + 1].time or (group.time + 0.5)
        local gap       = nextTime - group.time
        local blockDepth = math.clamp(gap * WALK_SPEED * 0.75, MIN_DEPTH, MAX_DEPTH)

        -- ワールド座標 (前方にdist、Y=地面)
        local worldPos = Vector3.new(
            startPos.X + lookVec.X * dist,
            blockY,
            startPos.Z + lookVec.Z * dist
        )

        -- ブロックCFrame (プレイヤーのY回転と揃える)
        local _, yAngle, _ = startCF:ToEulerAnglesYXZ()
        local blockCF = CFrame.new(worldPos) * CFrame.Angles(0, yAngle, 0)

        -- ブロック生成
        local block = Instance.new("Part")
        block.Name     = string.format("MusicBlock_%02d", gi)
        block.Size     = Vector3.new(BLOCK_W, BLOCK_H, blockDepth)
        block.CFrame   = blockCF
        block.Anchored = true
        block.Material = Enum.Material.Neon
        block.Color    = pitchToColor(group.pitch)
        block.CastShadow = false
        block.Parent   = blockFolder

        -- 上面にキー表示 (SurfaceGui)
        local sg  = Instance.new("SurfaceGui", block)
        sg.Face   = Enum.NormalId.Top
        sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        sg.PixelsPerStud = 40
        sg.AlwaysOnTop = false

        local lbl = Instance.new("TextLabel", sg)
        lbl.Size  = UDim2.new(1, 0, 1, 0)
        lbl.Text  = table.concat(group.keys, " ")
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.new(1, 1, 1)
        lbl.TextScaled = true
        lbl.Font  = Enum.Font.GothamBold

        -- 番号ラベル (BillboardGui - 前方から見えるポップ)
        local bb = Instance.new("BillboardGui", block)
        bb.Size  = UDim2.new(0, 50, 0, 24)
        bb.StudsOffset = Vector3.new(0, BLOCK_H + 0.8, 0)
        bb.AlwaysOnTop = false
        local numLbl = Instance.new("TextLabel", bb)
        numLbl.Size = UDim2.new(1, 0, 1, 0)
        numLbl.Text = tostring(gi)
        numLbl.BackgroundTransparency = 0.3
        numLbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        numLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        numLbl.TextScaled = true
        numLbl.Font = Enum.Font.Gotham

        -- ============================================================
        -- タッチ検出 (Touched)
        -- ============================================================
        local triggered = false

        block.Touched:Connect(function(hit)
            -- キャラクターのパーツかチェック
            if triggered then return end
            if not hit:IsDescendantOf(char) then return end

            -- 足・脚・HRP のみ反応 (R15 & R6 両対応)
            local n = hit.Name
            local validParts = {
                HumanoidRootPart = true,
                LeftFoot = true, RightFoot = true,
                LeftLowerLeg = true, RightLowerLeg = true,
                LeftUpperLeg = true, RightUpperLeg = true,
                ["Left Leg"] = true, ["Right Leg"] = true,
            }
            if not validParts[n] then return end

            triggered = true

            -- 全ノートを発音
            task.spawn(function()
                for _, k in ipairs(group.keys) do
                    pressKey(k)
                    task.wait(0.006)
                end
            end)

            -- 視覚フィードバック: 白く光って透明になる
            local origColor = block.Color
            block.Color    = Color3.new(1, 1, 1)
            block.Material = Enum.Material.SmoothPlastic

            local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(block, tweenInfo, {
                Transparency = 0.85,
                Color        = origColor,
            }):Play()

            -- 0.5秒後に完全透明 & CanCollide = false (邪魔にならないように)
            task.delay(0.4, function()
                block.Transparency = 0.9
                block.CanCollide   = false
            end)
        end)
    end

    print(string.format("[MusicBlocks] %d ブロック生成完了 | WalkSpeed=%d | Track=%.0f studs",
        #noteGroups, WALK_SPEED,
        START_DIST + noteGroups[#noteGroups].time * WALK_SPEED))
end

-- ============================================================
-- GUI
-- ============================================================
local function buildGui()
    local old = player.PlayerGui:FindFirstChild("MusicBlocksGui")
    if old then old:Destroy() end

    local sg = Instance.new("ScreenGui", player.PlayerGui)
    sg.Name = "MusicBlocksGui"
    sg.ResetOnSpawn = false

    -- メインフレーム
    local frame = Instance.new("Frame", sg)
    frame.Name = "Panel"
    frame.Size = UDim2.new(0, 280, 0, 175)
    frame.Position = UDim2.new(0.5, -140, 0, 12)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    -- タイトル
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 36)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(255, 80, 120)
    title.BackgroundTransparency = 0
    title.BorderSizePixel = 0
    title.Text = "♪  My Stupid Heart"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

    -- 情報ライン生成ヘルパー
    local function addInfo(parent, yOff, txt, color)
        local lbl = Instance.new("TextLabel", parent)
        lbl.Size = UDim2.new(1, -16, 0, 22)
        lbl.Position = UDim2.new(0, 8, 0, yOff)
        lbl.BackgroundTransparency = 1
        lbl.Text = txt
        lbl.TextColor3 = color or Color3.fromRGB(220, 220, 220)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextScaled = true
        lbl.Font = Enum.Font.Gotham
        return lbl
    end

    addInfo(frame, 42,  "🎮  Walk Speed : 16 studs/s",        Color3.fromRGB(100, 220, 255))
    addInfo(frame, 66,  "🎵  Song       : My Stupid Heart",   Color3.fromRGB(255, 200, 100))
    addInfo(frame, 90,  "🧱  Blocks     : 84  ( 222 notes )", Color3.fromRGB(180, 255, 180))
    addInfo(frame, 114, "📏  Track      : ~413 studs",         Color3.fromRGB(200, 200, 200))
    addInfo(frame, 138, "👟  前方へ真っ直ぐ歩いてください！",     Color3.fromRGB(255, 255, 100))

    -- Resetボタン
    local btn = Instance.new("TextButton", sg)
    btn.Size = UDim2.new(0, 160, 0, 38)
    btn.Position = UDim2.new(0.5, -80, 0, 198)
    btn.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
    btn.BorderSizePixel = 0
    btn.Text = "🔄  ブロックをリセット"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        btn.Text = "⏳ 生成中..."
        btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        task.wait(0.1)
        buildBlocks()
        btn.Text = "🔄  ブロックをリセット"
        btn.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
    end)

    -- カラー凡例
    local legend = Instance.new("Frame", sg)
    legend.Size = UDim2.new(0, 245, 0, 22)
    legend.Position = UDim2.new(0.5, -122, 0, 246)
    legend.BackgroundTransparency = 1

    local colors = {
        {Color3.fromRGB(60,80,255),   "低"},
        {Color3.fromRGB(80,200,255),  "↓"},
        {Color3.fromRGB(80,255,120),  "中"},
        {Color3.fromRGB(255,240,60),  "↑"},
        {Color3.fromRGB(255,140,40),  "↑"},
        {Color3.fromRGB(255,60,60),   "↑"},
        {Color3.fromRGB(220,60,255),  "高"},
    }
    for ci, cv in ipairs(colors) do
        local dot = Instance.new("Frame", legend)
        dot.Size = UDim2.new(0, 30, 0, 20)
        dot.Position = UDim2.new(0, (ci-1)*35, 0, 0)
        dot.BackgroundColor3 = cv[1]
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 4)
        local t = Instance.new("TextLabel", dot)
        t.Size = UDim2.new(1,0,1,0)
        t.Text = cv[2]
        t.BackgroundTransparency = 1
        t.TextColor3 = Color3.new(1,1,1)
        t.TextScaled = true
        t.Font = Enum.Font.GothamBold
    end
end

-- ============================================================
-- エントリポイント
-- ============================================================

-- WalkSpeed を確実に設定
hum.WalkSpeed = WALK_SPEED

-- ブロックとGUIを生成
buildBlocks()
buildGui()

print("[MusicBlocks] My Stupid Heart ブロック展開完了！前方へ歩いてください。")
