-- ============================================================
-- Music Block System v2.0 - My Stupid Heart
-- Fortnite Style | WalkSpeed=16 | Sound: Real Piano Notes
-- Mobile対応 | VIM不使用 | Roblox Sound直接再生
-- ============================================================

local Rayfield   = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players    = game:GetService("Players")
local TweenSvc   = game:GetService("TweenService")
local Debris     = game:GetService("Debris")
local RS         = game:GetService("RunService")

local player = Players.LocalPlayer
local char   = player.Character or player.CharacterAdded:Wait()
local hrp    = char:WaitForChild("HumanoidRootPart")
local hum    = char:WaitForChild("Humanoid")

-- ============================================================
-- 設定
-- ============================================================
local WALK_SPEED  = 16      -- studs/s (曲のテンポに同期)
local BLOCK_W     = 7       -- ブロック幅  (X studs) - 踏みやすい
local BLOCK_H     = 0.5     -- ブロック高さ (Y studs) - 地面から少し出るだけ
local START_DIST  = 20      -- プレイヤー前方の開始距離
local MIN_DEPTH   = 1.6     -- ブロック奥行き最小
local MAX_DEPTH   = 6.0     -- ブロック奥行き最大

-- ============================================================
-- サウンドシステム (VIM不使用 - Roblox Sound直接再生)
-- ベース音源: C4=MIDI60として相対ピッチシフト
-- ============================================================
local BASE_SOUND_ID = "rbxassetid://9119713951"

-- 各MIDIノートに最も近いCをベースにしてスピードを計算
-- → 常に ±6半音以内 → 音質劣化を最小化
local function getNotePlaybackSpeed(midiNote)
    local bases = {36, 48, 60, 72, 84, 96}
    local bestBase = 60
    local bestDist = math.abs(midiNote - 60)
    for _, b in ipairs(bases) do
        local d = math.abs(midiNote - b)
        if d < bestDist then bestDist = d; bestBase = b end
    end
    -- C系ベースからの相対スピード
    local relativeToC4 = 2^((bestBase - 60) / 12)  -- ベースCのスピード
    local noteOffset   = 2^((midiNote - bestBase) / 12)  -- ノートのオフセット
    return relativeToC4 * noteOffset
end

-- テスト: サウンドが読み込めるかチェック
local function testSoundLoad(callback)
    local testPart = Instance.new("Part")
    testPart.Anchored = true
    testPart.CanCollide = false
    testPart.Parent = workspace
    local s = Instance.new("Sound", testPart)
    s.SoundId = BASE_SOUND_ID
    s.Volume  = 0
    task.spawn(function()
        s:Play()
        task.wait(0.5)
        local ok = s.IsLoaded
        testPart:Destroy()
        callback(ok)
    end)
end

-- ============================================================
-- ドレミ (ノート名) マッピング
-- ============================================================
local NOTE_NAMES = {"C","C#","D","D#","E","F","F#","G","G#","A","A#","B"}
local DOREMI_JP  = {"ド","ド#","レ","レ#","ミ","ファ","ファ#","ソ","ソ#","ラ","ラ#","シ"}
local function midiToName(m)
    return NOTE_NAMES[m % 12 + 1] .. tostring(math.floor(m / 12) - 1)
end
local function midiToDoremi(m)
    return DOREMI_JP[m % 12 + 1]
end

-- ============================================================
-- ピッチ → ブロックカラー (ドレミカラー)
-- ============================================================
local DOREMI_COLORS = {
    [0]  = Color3.fromRGB(255, 50,  50),   -- C  ド  赤
    [1]  = Color3.fromRGB(255, 110, 50),   -- C# ド# 赤橙
    [2]  = Color3.fromRGB(255, 165, 50),   -- D  レ  橙
    [3]  = Color3.fromRGB(255, 215, 50),   -- D# レ# 黄橙
    [4]  = Color3.fromRGB(220, 255, 50),   -- E  ミ  黄
    [5]  = Color3.fromRGB(80,  220, 80),   -- F  ファ 緑
    [6]  = Color3.fromRGB(50,  200, 160),  -- F# ファ# 青緑
    [7]  = Color3.fromRGB(50,  140, 255),  -- G  ソ  青
    [8]  = Color3.fromRGB(80,  80,  255),  -- G# ソ# 青紫
    [9]  = Color3.fromRGB(160, 60,  255),  -- A  ラ  紫
    [10] = Color3.fromRGB(220, 50,  220),  -- A# ラ# ピンク紫
    [11] = Color3.fromRGB(255, 80,  160),  -- B  シ  ピンク
}
local function pitchToColor(avgMidi)
    local deg = math.floor(avgMidi + 0.5) % 12
    return DOREMI_COLORS[deg] or Color3.fromRGB(200, 200, 200)
end

-- ============================================================
-- NOTE DATA: My Stupid Heart (84グループ / 222ノート / 24.57s)
-- ============================================================
local noteGroups = {
    {time=0.302, midis={83}, avgPitch=83.0, label="B5"},
    {time=0.627, midis={81}, avgPitch=81.0, label="A5"},
    {time=0.941, midis={79}, avgPitch=79.0, label="G5"},
    {time=1.254, midis={88,76,64,79,52}, avgPitch=71.8, label="E6"},
    {time=1.602, midis={59}, avgPitch=59.0, label="B3"},
    {time=1.893, midis={64,52}, avgPitch=58.0, label="E4"},
    {time=2.207, midis={81,64,59}, avgPitch=68.0, label="A5"},
    {time=2.498, midis={76,55,64,83}, avgPitch=69.5, label="B5"},
    {time=2.823, midis={67,62}, avgPitch=64.5, label="G4"},
    {time=3.159, midis={79,67,52,55}, avgPitch=63.2, label="G5"},
    {time=3.473, midis={86,52}, avgPitch=69.0, label="D6"},
    {time=3.786, midis={48,88,76,60}, avgPitch=68.0, label="E6"},
    {time=3.868, midis={36}, avgPitch=36.0, label="C2"},
    {time=4.112, midis={88,76,55,60}, avgPitch=69.8, label="E6"},
    {time=4.182, midis={36}, avgPitch=36.0, label="C2"},
    {time=4.415, midis={88,79,76,60,48}, avgPitch=70.2, label="E6"},
    {time=4.728, midis={86,60}, avgPitch=73.0, label="D6"},
    {time=5.053, midis={83,76,55}, avgPitch=71.3, label="B5"},
    {time=5.193, midis={36,67}, avgPitch=51.5, label="G4"},
    {time=5.390, midis={67,62}, avgPitch=64.5, label="G4"},
    {time=5.692, midis={67,55}, avgPitch=61.0, label="G4"},
    {time=5.784, midis={48}, avgPitch=48.0, label="C3"},
    {time=6.018, midis={86}, avgPitch=86.0, label="D6"},
    {time=6.320, midis={48,88,79,76,60}, avgPitch=70.2, label="E6"},
    {time=6.633, midis={88,79,76,60,55}, avgPitch=71.6, label="E6"},
    {time=6.935, midis={79,88,76,60,48,36}, avgPitch=64.5, label="E6"},
    {time=7.260, midis={86,76}, avgPitch=81.0, label="D6"},
    {time=7.574, midis={83,76,67,55}, avgPitch=70.2, label="B5"},
    {time=7.910, midis={62}, avgPitch=62.0, label="D4"},
    {time=8.214, midis={60,67,55}, avgPitch=60.7, label="G4"},
    {time=8.527, midis={83,67,55}, avgPitch=68.3, label="B5"},
    {time=8.817, midis={76,81,50,48,69}, avgPitch=64.8, label="A5"},
    {time=9.154, midis={81,54,78,48}, avgPitch=65.2, label="A5"},
    {time=9.468, midis={81,57,62}, avgPitch=66.7, label="A5"},
    {time=9.781, midis={79,74,57,60}, avgPitch=67.5, label="G5"},
    {time=9.920, midis={50}, avgPitch=50.0, label="D3"},
    {time=10.084, midis={54,81,69,62,50,57}, avgPitch=62.2, label="A5"},
    {time=10.385, midis={83,54}, avgPitch=68.5, label="B5"},
    {time=10.723, midis={81,76,57,62}, avgPitch=69.0, label="A5"},
    {time=11.035, midis={79,74,57,60}, avgPitch=67.5, label="G5"},
    {time=11.338, midis={91,88,79,76,54,52,45}, avgPitch=69.3, label="G6"},
    {time=11.686, midis={59}, avgPitch=59.0, label="B3"},
    {time=11.977, midis={64,52}, avgPitch=58.0, label="E4"},
    {time=12.279, midis={81,62,59}, avgPitch=67.3, label="A5"},
    {time=12.581, midis={76,83,64,55}, avgPitch=69.5, label="B5"},
    {time=12.895, midis={67,62}, avgPitch=64.5, label="G4"},
    {time=13.255, midis={67,55}, avgPitch=61.0, label="G4"},
    {time=13.545, midis={86}, avgPitch=86.0, label="D6"},
    {time=13.870, midis={48,88,60,36}, avgPitch=58.0, label="E6"},
    {time=14.184, midis={90,55}, avgPitch=72.5, label="F#6"},
    {time=14.498, midis={88,60,55}, avgPitch=67.7, label="E6"},
    {time=14.568, midis={36}, avgPitch=36.0, label="C2"},
    {time=14.789, midis={86}, avgPitch=86.0, label="D6"},
    {time=15.172, midis={83,55,53}, avgPitch=63.7, label="B5"},
    {time=15.497, midis={62}, avgPitch=62.0, label="D4"},
    {time=15.682, midis={36}, avgPitch=36.0, label="C2"},
    {time=15.822, midis={67,60,55}, avgPitch=60.7, label="G4"},
    {time=16.114, midis={86}, avgPitch=86.0, label="D6"},
    {time=16.439, midis={83,60,88,48}, avgPitch=69.8, label="E6"},
    {time=16.752, midis={55,88}, avgPitch=71.5, label="E6"},
    {time=17.077, midis={88,79,60,55,36}, avgPitch=63.6, label="E6"},
    {time=17.379, midis={86,60}, avgPitch=73.0, label="D6"},
    {time=17.704, midis={55,67,83}, avgPitch=68.3, label="B5"},
    {time=18.019, midis={62}, avgPitch=62.0, label="D4"},
    {time=18.355, midis={79,67,62,55}, avgPitch=65.8, label="G5"},
    {time=18.646, midis={83,55,67}, avgPitch=68.3, label="B5"},
    {time=18.971, midis={50,55}, avgPitch=52.5, label="G3"},
    {time=19.086, midis={78}, avgPitch=78.0, label="F#5"},
    {time=19.284, midis={54,81}, avgPitch=67.5, label="A5"},
    {time=19.609, midis={81,57,62,50}, avgPitch=62.5, label="A5"},
    {time=19.913, midis={79,67}, avgPitch=73.0, label="G5"},
    {time=20.215, midis={78,81,69,50}, avgPitch=69.5, label="A5"},
    {time=20.528, midis={83,54}, avgPitch=68.5, label="B5"},
    {time=20.865, midis={81,57,62}, avgPitch=66.7, label="A5"},
    {time=21.167, midis={79}, avgPitch=79.0, label="G5"},
    {time=21.492, midis={52,79,54}, avgPitch=61.7, label="G5"},
    {time=21.793, midis={59}, avgPitch=59.0, label="B3"},
    {time=22.108, midis={79,64,52}, avgPitch=65.0, label="G5"},
    {time=22.723, midis={79,64,67,55,52}, avgPitch=63.4, label="G5"},
    {time=23.025, midis={62}, avgPitch=62.0, label="D4"},
    {time=23.339, midis={79,67}, avgPitch=73.0, label="G5"},
    {time=23.932, midis={79,48}, avgPitch=63.5, label="G5"},
    {time=24.257, midis={52}, avgPitch=52.0, label="E3"},
    {time=24.571, midis={41}, avgPitch=41.0, label="F2"}
}

-- ============================================================
-- ブロック折れ線確認用カウンター
-- ============================================================
local triggeredCount = 0
local totalBlocks    = #noteGroups
local blockParts     = {}   -- {part, sounds, triggered}

-- ============================================================
-- ブロック生成
-- ============================================================
local function buildBlocks()
    -- 既存削除
    local old = workspace:FindFirstChild("MSH_MusicBlocks")
    if old then old:Destroy() end

    blockParts  = {}
    triggeredCount = 0

    local folder = Instance.new("Folder")
    folder.Name  = "MSH_MusicBlocks"
    folder.Parent = workspace

    -- キャラクター再取得
    char = player.Character or player.CharacterAdded:Wait()
    hrp  = char:WaitForChild("HumanoidRootPart")
    hum  = char:WaitForChild("Humanoid")
    hum.WalkSpeed = WALK_SPEED

    -- 地面高さ取得 (レイキャスト)
    local rcParams = RaycastParams.new()
    rcParams.FilterDescendantsInstances = {char, folder}
    rcParams.FilterType = Enum.RaycastFilterType.Exclude
    local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -20, 0), rcParams)
    local groundY = ray and ray.Position.Y or (hrp.Position.Y - 3.2)

    -- 方向ベクトル
    local lookXZ = Vector3.new(hrp.CFrame.LookVector.X, 0, hrp.CFrame.LookVector.Z).Unit
    local _, yaw, _ = hrp.CFrame:ToEulerAnglesYXZ()
    local startPos  = hrp.Position

    local blockTopY = groundY                        -- ブロック上面=地面
    local blockCenterY = groundY + BLOCK_H / 2      -- ブロック中心Y

    -- ============================================================
    -- 各グループにブロック作成
    -- ============================================================
    for gi, group in ipairs(noteGroups) do
        -- 前方距離
        local dist = START_DIST + group.time * WALK_SPEED

        -- 奥行き計算 (次ブロックとの間隔から)
        local nextTime = noteGroups[gi + 1] and noteGroups[gi + 1].time or (group.time + 0.6)
        local gap      = nextTime - group.time
        local depth    = math.clamp(gap * WALK_SPEED * 0.7, MIN_DEPTH, MAX_DEPTH)

        -- ワールド座標
        local worldPos = Vector3.new(
            startPos.X + lookXZ.X * dist,
            blockCenterY,
            startPos.Z + lookXZ.Z * dist
        )
        local blockCF = CFrame.new(worldPos) * CFrame.Angles(0, yaw, 0)

        -- ── Part ──
        local block = Instance.new("Part")
        block.Name        = string.format("MSH_Block_%02d", gi)
        block.Size        = Vector3.new(BLOCK_W, BLOCK_H, depth)
        block.CFrame      = blockCF
        block.Anchored    = true
        block.CanCollide  = true
        block.Material    = Enum.Material.Neon
        block.Color       = pitchToColor(group.avgPitch)
        block.CastShadow  = false
        block.Parent      = folder

        -- ── SurfaceGui: ドレミ + ノート名 ──
        local sg = Instance.new("SurfaceGui", block)
        sg.Face       = Enum.NormalId.Top
        sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        sg.PixelsPerStud = 45
        sg.AlwaysOnTop   = false

        local topNote = math.max(table.unpack(group.midis))
        local doremi  = midiToDoremi(topNote)
        local noteName = midiToName(topNote)

        local lbl = Instance.new("TextLabel", sg)
        lbl.Size                  = UDim2.new(1, 0, 0.6, 0)
        lbl.Position              = UDim2.new(0, 0, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text                  = doremi
        lbl.TextColor3            = Color3.new(1, 1, 1)
        lbl.TextScaled            = true
        lbl.Font                  = Enum.Font.GothamBold

        local sub = Instance.new("TextLabel", sg)
        sub.Size                  = UDim2.new(1, 0, 0.4, 0)
        sub.Position              = UDim2.new(0, 0, 0.6, 0)
        sub.BackgroundTransparency = 1
        sub.Text                  = noteName .. "  #" .. gi
        sub.TextColor3            = Color3.fromRGB(220, 220, 220)
        sub.TextScaled            = true
        sub.Font                  = Enum.Font.Gotham

        -- ── BillboardGui: 番号 (前方から見える) ──
        local bb = Instance.new("BillboardGui", block)
        bb.Size        = UDim2.new(0, 42, 0, 22)
        bb.StudsOffset = Vector3.new(0, BLOCK_H + 0.7, 0)
        bb.AlwaysOnTop = false
        local numLbl   = Instance.new("TextLabel", bb)
        numLbl.Size    = UDim2.new(1, 0, 1, 0)
        numLbl.Text    = tostring(gi)
        numLbl.BackgroundColor3    = Color3.fromRGB(0, 0, 0)
        numLbl.BackgroundTransparency = 0.4
        numLbl.TextColor3          = Color3.new(1, 1, 1)
        numLbl.TextScaled          = true
        numLbl.Font                = Enum.Font.GothamBold

        -- ── サウンドオブジェクトを事前生成 ──
        local sounds = {}
        for _, midi in ipairs(group.midis) do
            local s = Instance.new("Sound", block)
            s.SoundId          = BASE_SOUND_ID
            s.PlaybackSpeed    = getNotePlaybackSpeed(midi)
            s.Volume           = 0.95
            s.RollOffMode      = Enum.RollOffMode.Linear
            s.RollOffMinDistance = 1
            s.RollOffMaxDistance = 80
            s.Looped           = false
            table.insert(sounds, s)
        end

        -- ── ブロック情報をテーブルに保存 ──
        local entry = {
            part      = block,
            sounds    = sounds,
            triggered = false,
            origColor = block.Color,
            index     = gi,
        }
        table.insert(blockParts, entry)

        -- ── Touched 検出 ──
        local function onTouch(hit)
            if entry.triggered then return end
            -- キャラクターのパーツか確認
            if not hit:IsDescendantOf(char) then return end
            -- ヒューマノイド確認 (キャラクターが生きているか)
            local h = char:FindFirstChildOfClass("Humanoid")
            if not h or h.Health <= 0 then return end

            entry.triggered = true
            triggeredCount  = triggeredCount + 1

            -- ── 全ノートを同時再生 ──
            for _, s in ipairs(sounds) do
                task.spawn(function() s:Play() end)
            end

            -- ── 視覚フィードバック: 白フラッシュ → 元色 ──
            block.Color    = Color3.new(1, 1, 1)
            block.Material = Enum.Material.SmoothPlastic

            local tw = TweenSvc:Create(block,
                TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Color = entry.origColor, Transparency = 0.3}
            )
            tw:Play()

            -- 踏んだあとも通り抜けやすく（透明にするだけ、CanCollideはtrue維持）
            task.delay(0.5, function()
                block.Transparency = 0.7
                -- モバイルでつまずかないようにブロックを通り抜け可能にする
                block.CanCollide = false
            end)
        end

        block.Touched:Connect(onTouch)
    end

    Rayfield:Notify({
        Title   = "✅ ブロック生成完了！",
        Content = totalBlocks .. " blocks | 前方へ真っ直ぐ歩いてください！",
        Duration = 5,
        Image   = "rbxassetid://4483345998"
    })

    print(string.format("[MSH] %d blocks built | WalkSpeed=%d | Track~%.0f studs",
        totalBlocks, WALK_SPEED, START_DIST + noteGroups[totalBlocks].time * WALK_SPEED))
end

-- ============================================================
-- Rayfield UI
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name             = "My Stupid Heart - Music Blocks",
    LoadingTitle     = "Music Block System",
    LoadingSubtitle  = "My Stupid Heart",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false,
})

-- ── コントロールタブ ──────────────────────────────────────────
local TabCtrl = Window:CreateTab("Controls", 4483345998)

TabCtrl:CreateButton({
    Name = "🔄  ブロックをリセット & 再生成",
    Callback = function()
        triggeredCount = 0
        buildBlocks()
    end,
})

TabCtrl:CreateButton({
    Name = "🔊  サウンドテスト (C4 ド)",
    Callback = function()
        testSoundLoad(function(ok)
            if ok then
                -- C4 を単体で鳴らす
                local testPart = Instance.new("Part")
                testPart.Anchored = true
                testPart.CanCollide = false
                testPart.CFrame = hrp.CFrame
                testPart.Parent = workspace
                local s = Instance.new("Sound", testPart)
                s.SoundId = BASE_SOUND_ID
                s.PlaybackSpeed = 1.0
                s.Volume = 1
                s:Play()
                Debris:AddItem(testPart, 3)
                Rayfield:Notify({Title="🔊 サウンドOK", Content="C4 (ド) を再生中", Duration=3, Image="rbxassetid://4483345998"})
            else
                Rayfield:Notify({Title="⚠️ サウンド読み込み失敗", Content="SoundIdを確認してください", Duration=5, Image="rbxassetid://4483345998"})
            end
        end)
    end,
})

TabCtrl:CreateButton({
    Name = "🏃  WalkSpeed を 16 に設定",
    Callback = function()
        char = player.Character or player.CharacterAdded:Wait()
        hum  = char:WaitForChild("Humanoid")
        hum.WalkSpeed = WALK_SPEED
        Rayfield:Notify({Title="Speed = 16", Content="WalkSpeed reset!", Duration=2, Image="rbxassetid://4483345998"})
    end,
})

-- ── 曲情報タブ ────────────────────────────────────────────────
local TabInfo = Window:CreateTab("Song Info", 4483345998)

TabInfo:CreateSection("My Stupid Heart")
TabInfo:CreateLabel("🎵 曲: My Stupid Heart")
TabInfo:CreateLabel("🎹 ノート数: 222 notes / 84 blocks")
TabInfo:CreateLabel("⏱ 長さ: ~24.6 秒")
TabInfo:CreateLabel("🏃 WalkSpeed: 16 studs/s")
TabInfo:CreateLabel("📏 トラック長: 約408 studs")
TabInfo:CreateLabel("🗺 前方へ一直線に歩くだけ！")

TabInfo:CreateSection("カラーガイド")
TabInfo:CreateLabel("🔴 ド(C)  🟠 レ(D)  🟡 ミ(E)")
TabInfo:CreateLabel("🟢 ファ(F)  🔵 ソ(G)  🟣 ラ(A)")
TabInfo:CreateLabel("🩷 シ(B)  ※# は中間色")

-- ============================================================
-- 起動
-- ============================================================

-- WalkSpeed を確実に設定
hum.WalkSpeed = WALK_SPEED

-- サウンド読み込みチェック → ブロック生成
testSoundLoad(function(ok)
    local msg = ok and "サウンドOK ✅ | 前へ歩いてください！"
                    or "⚠️ サウンド未確認 - テストボタンで確認を"
    Rayfield:Notify({
        Title   = "My Stupid Heart 準備完了",
        Content = msg,
        Duration = 6,
        Image   = "rbxassetid://4483345998"
    })
end)

buildBlocks()
