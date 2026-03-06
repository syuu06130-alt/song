-- ============================================================
--   🎹 Libra Heart  (imaizumi)
--   楽譜完全書き起こし版  /  Db major (♭5) / 4/4 / BPM 84
--   総ノーツ: 310  /  演奏時間: 約57.1秒 (1.0分)
--
--   構成
--     第1・2pass  M1-M4  (0.0 〜 22.9 s)  ← 繰り返しあり
--     M5〜M8      (22.9 〜 34.3 s)
--     M9〜M12     (34.3 〜 45.7 s)  密度の高い16分音符
--     M13〜M16    (45.7 〜 57.1 s)  シンプルなエンディング
--
--   キーマッピング (ピアノ画像準拠)
--   白鍵: 1=C4  2=D4  3=E4  4=F4  5=G4  6=A4  7=B4
--         8=C5  9=D5  0=E5  q=F5  w=G5  e=A5  r=B5
--         t=C6  y=D6  u=E6  i=F6  o=G6  p=A6  a=B6
--   黒鍵: !=C#4 @=D#4 $=F#4 %=G#4 ^=A#4
--         *=C#5 (=D#5 Q=F#5 W=G#5 E=A#5
--         T=C#6 Y=D#6 I=F#6 O=G#6 P=A#6
-- ============================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local VIM      = game:GetService("VirtualInputManager")
local Players  = game:GetService("Players")

-- ─────────────────────────────────────────────────────────────
--  キーコード定義
-- ─────────────────────────────────────────────────────────────
local BLACK = {
    ["!"]  = Enum.KeyCode.One,   ["@"]  = Enum.KeyCode.Two,
    ["$"]  = Enum.KeyCode.Four,  ["%"]  = Enum.KeyCode.Five,
    ["^"]  = Enum.KeyCode.Six,   ["*"]  = Enum.KeyCode.Eight,
    ["("]  = Enum.KeyCode.Nine,
    ["Q"]  = Enum.KeyCode.Q, ["W"]  = Enum.KeyCode.W, ["E"]  = Enum.KeyCode.E,
    ["T"]  = Enum.KeyCode.T, ["Y"]  = Enum.KeyCode.Y, ["I"]  = Enum.KeyCode.I,
    ["O"]  = Enum.KeyCode.O, ["P"]  = Enum.KeyCode.P, ["S"]  = Enum.KeyCode.S,
    ["D"]  = Enum.KeyCode.D, ["G"]  = Enum.KeyCode.G, ["H"]  = Enum.KeyCode.H,
    ["J"]  = Enum.KeyCode.J, ["L"]  = Enum.KeyCode.L, ["Z"]  = Enum.KeyCode.Z,
    ["C"]  = Enum.KeyCode.C, ["V"]  = Enum.KeyCode.V, ["B"]  = Enum.KeyCode.B,
}

local WHITE = {
    ["1"]=Enum.KeyCode.One,   ["2"]=Enum.KeyCode.Two,
    ["3"]=Enum.KeyCode.Three, ["4"]=Enum.KeyCode.Four,
    ["5"]=Enum.KeyCode.Five,  ["6"]=Enum.KeyCode.Six,
    ["7"]=Enum.KeyCode.Seven, ["8"]=Enum.KeyCode.Eight,
    ["9"]=Enum.KeyCode.Nine,  ["0"]=Enum.KeyCode.Zero,
    ["q"]=Enum.KeyCode.Q, ["w"]=Enum.KeyCode.W, ["e"]=Enum.KeyCode.E,
    ["r"]=Enum.KeyCode.R, ["t"]=Enum.KeyCode.T, ["y"]=Enum.KeyCode.Y,
    ["u"]=Enum.KeyCode.U, ["i"]=Enum.KeyCode.I, ["o"]=Enum.KeyCode.O,
    ["p"]=Enum.KeyCode.P, ["a"]=Enum.KeyCode.A, ["s"]=Enum.KeyCode.S,
    ["d"]=Enum.KeyCode.D, ["f"]=Enum.KeyCode.F, ["g"]=Enum.KeyCode.G,
    ["h"]=Enum.KeyCode.H, ["j"]=Enum.KeyCode.J, ["k"]=Enum.KeyCode.K,
    ["l"]=Enum.KeyCode.L, ["z"]=Enum.KeyCode.Z, ["x"]=Enum.KeyCode.X,
    ["c"]=Enum.KeyCode.C, ["v"]=Enum.KeyCode.V, ["b"]=Enum.KeyCode.B,
    ["n"]=Enum.KeyCode.N, ["m"]=Enum.KeyCode.M,
}

local function pressKey(k)
    local bk = BLACK[k]
    if bk then
        VIM:SendKeyEvent(true,  Enum.KeyCode.LeftShift, false, game)
        VIM:SendKeyEvent(true,  bk, false, game)
        task.delay(0.05, function()
            VIM:SendKeyEvent(false, bk, false, game)
            VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
        end)
    else
        local wk = WHITE[k]
        if wk then
            VIM:SendKeyEvent(true, wk, false, game)
            task.delay(0.05, function()
                VIM:SendKeyEvent(false, wk, false, game)
            end)
        end
    end
end

-- ─────────────────────────────────────────────────────────────
--  Piano 自動出現・着席
-- ─────────────────────────────────────────────────────────────
local function findPiano()
    for _, o in ipairs(workspace:GetDescendants()) do
        if (o:IsA("BasePart") or o:IsA("Model")) then
            local n = o.Name:lower()
            if n:find("piano") or n:find("keyboard") then return o end
        end
    end
end

local function trySpawn()
    for _, o in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if o:IsA("RemoteEvent") then
            local n = o.Name:lower()
            if n:find("spawn") or n:find("piano") or n:find("place") then
                pcall(function() o:FireServer() end); task.wait(1.5)
                return findPiano()
            end
        end
    end
    local pg = Players.LocalPlayer and Players.LocalPlayer.PlayerGui
    if pg then
        for _, o in ipairs(pg:GetDescendants()) do
            if o:IsA("TextButton") or o:IsA("ImageButton") then
                local n = (o.Text or o.Name):lower()
                if n:find("spawn") or n:find("piano") then
                    pcall(function() o.MouseButton1Click:Fire() end); task.wait(1.5)
                    return findPiano()
                end
            end
        end
    end
end

local function sitAt(obj)
    local p = Players.LocalPlayer
    if not p or not p.Character then return end
    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local pos
    if obj:IsA("Model") and obj.PrimaryPart then pos = obj.PrimaryPart.Position
    elseif obj:IsA("BasePart") then pos = obj.Position
    else
        for _, c in ipairs(obj:GetDescendants()) do
            if c:IsA("BasePart") then pos = c.Position; break end
        end
    end
    if not pos then return end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,4)); task.wait(0.5)
    for _, o in ipairs(workspace:GetDescendants()) do
        if (o:IsA("Seat") or o:IsA("VehicleSeat")) and (o.Position-pos).Magnitude < 10 then
            o:Sit(p.Character:FindFirstChild("Humanoid")); return
        end
    end
end

local function setupPiano()
    Rayfield:Notify({Title="🎹 Setup",Content="ピアノを検索中...",Duration=2,Image="rbxassetid://4483345998"})
    local f = findPiano() or trySpawn()
    if f then
        task.spawn(function() task.wait(0.3); sitAt(f) end)
        Rayfield:Notify({Title="🎹 Setup",Content="ピアノ発見！演奏ボタンを押してください。",Duration=3,Image="rbxassetid://4483345998"})
    else
        Rayfield:Notify({Title="🎹 Setup",Content="ピアノが見つかりません。手動で近づいてください。",Duration=4,Image="rbxassetid://4483345998"})
    end
end

-- ─────────────────────────────────────────────────────────────
--  再生管理
-- ─────────────────────────────────────────────────────────────
local playing = false
local stopReq = false
local curTitle = ""

local function play(notes, title)
    if playing then
        Rayfield:Notify({Title="⚠ 再生中",Content=curTitle.." 演奏中です。先に⏹停止を。",Duration=2,Image="rbxassetid://4483345998"}); return
    end
    playing = true; stopReq = false; curTitle = title
    Rayfield:Notify({Title="♪ "..title,Content="演奏開始 ("..#notes.." ノーツ)",Duration=3,Image="rbxassetid://4483345998"})
    task.spawn(function()
        local t0 = tick()
        for _, n in ipairs(notes) do
            if stopReq then break end
            local w = n.time - (tick()-t0)
            if w > 0 then task.wait(w) end
            if not stopReq then pressKey(n.key) end
        end
        playing = false; stopReq = false; curTitle = ""
        Rayfield:Notify({Title="🎸 演奏終了",Content=title.." が終わりました！",Duration=3,Image="rbxassetid://4483345998"})
    end)
end

local function stopPlay()
    if playing then
        stopReq = true; playing = false
        Rayfield:Notify({Title="⏹ 停止",Content=curTitle.." を停止しました。",Duration=2,Image="rbxassetid://4483345998"}); curTitle = ""
    else
        Rayfield:Notify({Title="ℹ 待機中",Content="再生中の曲はありません。",Duration=2,Image="rbxassetid://4483345998"})
    end
end

-- ─────────────────────────────────────────────────────────────
--  ノーツデータ  (310 ノーツ / 約57.1秒)
--  楽譜 Image 1-4 から完全書き起こし
-- ─────────────────────────────────────────────────────────────
-- 調: Db major (♭5)  拍子: 4/4  BPM: 84
-- Gb  = Q(Gb5) $(Gb4)   Db = *(Db5) !(Db4)   Bb = E(Bb5) ^(Bb4)
-- Ab  = W(Ab5) %(Ab4)   Eb = ((Eb5) @(Eb4)   F  = q(F5)  4(F4)
-- Cb  = r(Cb6=B5) 7(Cb5=B4)
--
-- 構成:
--   [0.000-11.429]  第1pass  M1-M4   (Dotted-♩ 和音+16分音符走句)
--   [11.429-22.857] 繰り返し M1'-M4'
--   [22.857-31.429] M5-M8   (歌謡的メロディ)
--   [31.429-45.714] M9-M12  (高密度16分音符)
--   [45.714-57.143] M13-M16 (シンプルなコーダ)
local notes_libraHeart = {
    {time=0.000,key="$"},{time=0.000,key="*"},{time=0.000,key="@"},{time=0.000,key="Q"},
    {time=0.000,key="^"},{time=0.357,key="^"},{time=0.714,key="@"},{time=1.071,key="!"},
    {time=1.071,key="*"},{time=1.250,key="7"},{time=1.429,key="$"},{time=1.429,key="^"},
    {time=1.607,key="*"},{time=1.786,key="!"},{time=1.786,key="^"},{time=1.964,key="4"},
    {time=2.143,key="$"},{time=2.143,key="4"},{time=2.321,key="*"},{time=2.500,key="!"},
    {time=2.500,key="^"},{time=2.679,key="4"},{time=2.857,key="$"},{time=2.857,key="*"},
    {time=2.857,key="@"},{time=2.857,key="Q"},{time=2.857,key="^"},{time=3.214,key="^"},
    {time=3.571,key="@"},{time=3.929,key="!"},{time=3.929,key="*"},{time=4.107,key="7"},
    {time=4.286,key="$"},{time=4.286,key="^"},{time=4.464,key="*"},{time=4.643,key="!"},
    {time=4.643,key="^"},{time=4.821,key="4"},{time=5.000,key="$"},{time=5.000,key="4"},
    {time=5.179,key="*"},{time=5.357,key="!"},{time=5.357,key="^"},{time=5.536,key="4"},
    {time=5.714,key="!"},{time=5.714,key="$"},{time=5.714,key="*"},{time=5.714,key="Q"},
    {time=5.714,key="^"},{time=6.071,key="$"},{time=6.429,key="!"},{time=6.786,key="!"},
    {time=7.143,key="%"},{time=7.143,key="*"},{time=7.143,key="^"},{time=7.500,key="!"},
    {time=7.857,key="*"},{time=7.857,key="4"},{time=7.857,key="Q"},{time=8.214,key="!"},
    {time=8.571,key="!"},{time=8.571,key="*"},{time=8.571,key="^"},{time=8.929,key="%"},
    {time=9.286,key="!"},{time=9.286,key="$"},{time=9.286,key="^"},{time=9.643,key="$"},
    {time=10.000,key="!"},{time=10.000,key="$"},{time=10.000,key="*"},{time=10.357,key="4"},
    {time=10.714,key="!"},{time=10.714,key="*"},{time=10.714,key="Q"},{time=11.071,key="!"},
    {time=11.429,key="$"},{time=11.429,key="*"},{time=11.429,key="@"},{time=11.429,key="Q"},
    {time=11.429,key="^"},{time=11.786,key="^"},{time=12.143,key="@"},{time=12.500,key="!"},
    {time=12.500,key="*"},{time=12.679,key="7"},{time=12.857,key="$"},{time=12.857,key="^"},
    {time=13.036,key="*"},{time=13.214,key="!"},{time=13.214,key="^"},{time=13.393,key="4"},
    {time=13.571,key="$"},{time=13.571,key="4"},{time=13.750,key="*"},{time=13.929,key="!"},
    {time=13.929,key="^"},{time=14.107,key="4"},{time=14.286,key="$"},{time=14.286,key="*"},
    {time=14.286,key="@"},{time=14.286,key="Q"},{time=14.286,key="^"},{time=14.643,key="^"},
    {time=15.000,key="@"},{time=15.357,key="!"},{time=15.357,key="*"},{time=15.536,key="7"},
    {time=15.714,key="$"},{time=15.714,key="^"},{time=15.893,key="*"},{time=16.071,key="!"},
    {time=16.071,key="^"},{time=16.250,key="4"},{time=16.429,key="$"},{time=16.429,key="4"},
    {time=16.607,key="*"},{time=16.786,key="!"},{time=16.786,key="^"},{time=16.964,key="4"},
    {time=17.143,key="!"},{time=17.143,key="$"},{time=17.143,key="*"},{time=17.143,key="Q"},
    {time=17.143,key="^"},{time=17.500,key="$"},{time=17.857,key="!"},{time=18.214,key="!"},
    {time=18.571,key="%"},{time=18.571,key="*"},{time=18.571,key="^"},{time=18.929,key="!"},
    {time=19.286,key="*"},{time=19.286,key="4"},{time=19.286,key="Q"},{time=19.643,key="!"},
    {time=20.000,key="!"},{time=20.000,key="*"},{time=20.000,key="^"},{time=20.357,key="%"},
    {time=20.714,key="!"},{time=20.714,key="$"},{time=20.714,key="^"},{time=21.071,key="$"},
    {time=21.429,key="!"},{time=21.429,key="$"},{time=21.429,key="*"},{time=21.786,key="4"},
    {time=22.143,key="!"},{time=22.143,key="*"},{time=22.143,key="Q"},{time=22.500,key="!"},
    {time=22.857,key="!"},{time=22.857,key="Q"},{time=23.214,key="%"},{time=23.214,key="*"},
    {time=23.571,key="!"},{time=23.571,key="Q"},{time=23.929,key="$"},{time=23.929,key="Q"},
    {time=24.286,key="!"},{time=24.286,key="Q"},{time=24.643,key="%"},{time=24.643,key="Q"},
    {time=25.000,key="!"},{time=25.000,key="W"},{time=25.357,key="$"},{time=25.357,key="Q"},
    {time=25.714,key="$"},{time=25.714,key="("},{time=26.071,key="!"},{time=26.071,key="*"},
    {time=26.429,key="4"},{time=26.429,key="^"},{time=26.786,key="$"},{time=26.786,key="@"},
    {time=27.143,key="%"},{time=27.143,key="^"},{time=27.500,key="@"},{time=27.857,key="$"},
    {time=27.857,key="*"},{time=28.214,key="!"},{time=28.214,key="7"},{time=28.571,key="$"},
    {time=28.571,key="E"},{time=28.929,key="!"},{time=29.286,key="%"},{time=29.286,key="E"},
    {time=29.286,key="Q"},{time=29.643,key="!"},{time=30.000,key="$"},{time=30.000,key="E"},
    {time=30.000,key="Q"},{time=30.357,key="!"},{time=30.714,key="%"},{time=30.714,key="E"},
    {time=31.071,key="!"},{time=31.429,key="@"},{time=31.429,key="^"},{time=31.786,key="^"},
    {time=31.786,key="^"},{time=32.143,key="7"},{time=32.143,key="@"},{time=32.500,key="!"},
    {time=32.857,key="$"},{time=32.857,key="^"},{time=33.214,key="!"},{time=33.214,key="^"},
    {time=33.571,key="4"},{time=33.571,key="7"},{time=33.929,key="!"},{time=34.286,key="!"},
    {time=34.286,key="Q"},{time=34.464,key="E"},{time=34.643,key="W"},{time=34.821,key="E"},
    {time=35.000,key="Q"},{time=35.179,key="E"},{time=35.357,key="W"},{time=35.536,key="E"},
    {time=35.714,key="$"},{time=35.714,key="Q"},{time=35.893,key="E"},{time=36.071,key="W"},
    {time=36.250,key="E"},{time=36.429,key="Q"},{time=36.607,key="E"},{time=36.786,key="W"},
    {time=36.964,key="E"},{time=37.143,key="!"},{time=37.143,key="*"},{time=37.321,key="E"},
    {time=37.500,key="Q"},{time=37.679,key="E"},{time=37.857,key="*"},{time=38.036,key="E"},
    {time=38.214,key="Q"},{time=38.393,key="E"},{time=38.571,key="%"},{time=38.571,key="*"},
    {time=38.750,key="E"},{time=38.929,key="Q"},{time=39.107,key="E"},{time=39.286,key="*"},
    {time=39.464,key="E"},{time=39.643,key="Q"},{time=39.821,key="E"},{time=40.000,key="!"},
    {time=40.000,key="Q"},{time=40.179,key="E"},{time=40.357,key="W"},{time=40.536,key="E"},
    {time=40.714,key="Q"},{time=40.893,key="E"},{time=41.071,key="W"},{time=41.250,key="E"},
    {time=41.429,key="$"},{time=41.429,key="Q"},{time=41.607,key="E"},{time=41.786,key="W"},
    {time=41.964,key="E"},{time=42.143,key="Q"},{time=42.321,key="E"},{time=42.500,key="W"},
    {time=42.679,key="E"},{time=42.857,key="!"},{time=42.857,key="*"},{time=43.036,key="E"},
    {time=43.214,key="Q"},{time=43.393,key="E"},{time=43.571,key="*"},{time=43.750,key="E"},
    {time=43.929,key="Q"},{time=44.107,key="E"},{time=44.286,key="$"},{time=44.286,key="*"},
    {time=44.464,key="E"},{time=44.643,key="Q"},{time=44.821,key="E"},{time=45.000,key="*"},
    {time=45.000,key="Q"},{time=45.714,key="!"},{time=45.714,key="E"},{time=46.429,key="%"},
    {time=46.429,key="E"},{time=46.429,key="Q"},{time=47.143,key="!"},{time=47.143,key="Q"},
    {time=47.500,key="W"},{time=47.857,key="$"},{time=47.857,key="E"},{time=48.571,key="$"},
    {time=48.571,key="E"},{time=48.571,key="Q"},{time=49.286,key="!"},{time=50.000,key="4"},
    {time=50.000,key="Q"},{time=50.714,key="!"},{time=51.429,key="!"},{time=51.429,key="Q"},
    {time=52.143,key="%"},{time=52.857,key="!"},{time=52.857,key="W"},{time=53.571,key="$"},
    {time=53.571,key="E"},{time=54.286,key="$"},{time=54.286,key="Q"},{time=55.000,key="!"},
    {time=55.714,key="4"},{time=56.429,key="!"},
}

-- ─────────────────────────────────────────────────────────────
--  Rayfield UI
-- ─────────────────────────────────────────────────────────────
local Win = Rayfield:CreateWindow({
    Name            = "🎹 Libra Heart — Score Edition",
    LoadingTitle    = "Libra Heart",
    LoadingSubtitle = "imaizumi / Db major / BPM 84 / 310 notes",
    ConfigurationSaving = { Enabled = false },
    Discord         = { Enabled = false },
    KeySystem       = false,
})

-- ── Play タブ ──────────────────────────────────────────────────
local PT = Win:CreateTab("🎸 Play", 4483345998)

PT:CreateSection("🎶 Libra Heart (imaizumi) — 楽譜書き起こし版")

PT:CreateButton({
    Name     = "▶  Full Play（全曲 約57秒）",
    Callback = function() play(notes_libraHeart, "Libra Heart") end,
})

PT:CreateButton({
    Name     = "▶  M1-M4 イントロ (0〜11s)",
    Callback = function()
        local t = {}
        for _, n in ipairs(notes_libraHeart) do
            if n.time < 11.43 then t[#t+1]=n end
        end
        play(t, "Libra Heart [Intro]")
    end,
})

PT:CreateButton({
    Name     = "▶  M1-M4 リピート (11〜23s)",
    Callback = function()
        local off, t = 11.429, {}
        for _, n in ipairs(notes_libraHeart) do
            if n.time >= 11.42 and n.time < 22.86 then
                t[#t+1] = {time=n.time-off, key=n.key}
            end
        end
        play(t, "Libra Heart [Repeat]")
    end,
})

PT:CreateButton({
    Name     = "▶  M5-M8 メロディ (23〜34s)",
    Callback = function()
        local off, t = 22.857, {}
        for _, n in ipairs(notes_libraHeart) do
            if n.time >= 22.85 and n.time < 34.29 then
                t[#t+1] = {time=n.time-off, key=n.key}
            end
        end
        play(t, "Libra Heart [M5-M8]")
    end,
})

PT:CreateButton({
    Name     = "▶  M9-M12 密度地帯 (34〜46s)",
    Callback = function()
        local off, t = 34.286, {}
        for _, n in ipairs(notes_libraHeart) do
            if n.time >= 34.28 and n.time < 45.72 then
                t[#t+1] = {time=n.time-off, key=n.key}
            end
        end
        play(t, "Libra Heart [Dense]")
    end,
})

PT:CreateButton({
    Name     = "▶  M13-M16 コーダ (46〜57s)",
    Callback = function()
        local off, t = 45.714, {}
        for _, n in ipairs(notes_libraHeart) do
            if n.time >= 45.71 then
                t[#t+1] = {time=n.time-off, key=n.key}
            end
        end
        play(t, "Libra Heart [Coda]")
    end,
})

PT:CreateSection("楽曲情報")

PT:CreateParagraph({
    Title   = "🎸 Libra Heart (imaizumi)",
    Content =
        "調性  : Db major (♭5: Bb Eb Ab Db Gb)\n"..
        "拍子  : 4/4  / BPM: 84\n"..
        "総ノーツ: 310\n"..
        "演奏時間: 約57秒 (4pass)\n\n"..
        "構成\n"..
        "  [0-11s]  M1-M4  付点四分音符和音＋16分走句\n"..
        "  [11-23s] 同リピート\n"..
        "  [23-34s] M5-M8  歌謡的メロディライン\n"..
        "  [34-46s] M9-M12 16分音符高密度ストリーム\n"..
        "  [46-57s] M13-M16 シンプルなコーダ",
})

-- ── Setup タブ ─────────────────────────────────────────────────
local ST = Win:CreateTab("⚙ Setup", 4483345998)

ST:CreateSection("ピアノ準備")

ST:CreateButton({
    Name     = "🎹  ピアノ出現 & 着席",
    Callback = function() task.spawn(setupPiano) end,
})

ST:CreateParagraph({
    Title   = "キーマッピング早見表 (Db major)",
    Content =
        "Db = *(Db5) !(Db4)   Gb = Q(Gb5) $(Gb4)\n"..
        "Bb = E(Bb5) ^(Bb4)   Ab = W(Ab5) %(Ab4)\n"..
        "Eb = ((Eb5) @(Eb4)   F  = q(F5)  4(F4)\n"..
        "Cb = r(=B5) 7(=B4)\n\n"..
        "白鍵全体: 1=C4 2=D4 3=E4 4=F4 5=G4 6=A4 7=B4\n"..
        "          8=C5 9=D5 0=E5 q=F5 w=G5 e=A5 r=B5\n"..
        "          t=C6 y=D6 u=E6 i=F6 o=G6 p=A6 a=B6\n"..
        "黒鍵全体: !=C#4 @=D#4 $=F#4 %=G#4 ^=A#4\n"..
        "          *=C#5 (=D#5 Q=F#5 W=G#5 E=A#5\n"..
        "          T=C#6 Y=D#6 I=F#6 O=G#6 P=A#6",
})

-- ── Control タブ ───────────────────────────────────────────────
local CT = Win:CreateTab("⏹ Control", 4483345998)

CT:CreateSection("再生コントロール")

CT:CreateButton({
    Name     = "⏹  演奏を停止する",
    Callback = function() stopPlay() end,
})

CT:CreateButton({
    Name     = "📊  現在の状態を確認",
    Callback = function()
        if playing then
            Rayfield:Notify({Title="📊 再生中",Content="♪ "..curTitle,Duration=2,Image="rbxassetid://4483345998"})
        else
            Rayfield:Notify({Title="📊 待機中",Content="再生中の曲はありません。",Duration=2,Image="rbxassetid://4483345998"})
        end
    end,
})

CT:CreateParagraph({
    Title   = "注意事項",
    Content =
        "・演奏中はRobloxの画面にフォーカスを当ててください\n"..
        "・黒鍵は自動でShiftキーを処理します\n"..
        "・同じ時刻に複数キー→和音として同時押し\n"..
        "・ラグがひどい場合はタイミングがズレることがあります",
})
