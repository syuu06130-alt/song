-- ==============================================================
--  🎸 Libra Heart (imaizumi) - High-Fidelity Edition
--  Virtual Piano Player ― Rayfield UI Enhanced
-- ==============================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local VIM      = game:GetService("VirtualInputManager")
local Players  = game:GetService("Players")

-- ── 設定変数 ──────────────────────────────────────────
local PlaybackSpeed = 1.0
local isPlaying     = false
local stopFlag      = false
local currentSong   = ""

-- ── キーコード定義 ──────────────────────────────────────────
local BLACK_KEY_BASE = {
    ["!"] = Enum.KeyCode.One,  ["@"] = Enum.KeyCode.Two,
    ["$"] = Enum.KeyCode.Four, ["%"] = Enum.KeyCode.Five,
    ["^"] = Enum.KeyCode.Six,  ["*"] = Enum.KeyCode.Eight,
    ["("] = Enum.KeyCode.Nine,
    ["Q"] = Enum.KeyCode.Q, ["W"] = Enum.KeyCode.W, ["E"] = Enum.KeyCode.E,
    ["T"] = Enum.KeyCode.T, ["Y"] = Enum.KeyCode.Y, ["I"] = Enum.KeyCode.I,
    ["O"] = Enum.KeyCode.O, ["P"] = Enum.KeyCode.P, ["S"] = Enum.KeyCode.S,
    ["D"] = Enum.KeyCode.D, ["G"] = Enum.KeyCode.G, ["H"] = Enum.KeyCode.H,
    ["J"] = Enum.KeyCode.J, ["L"] = Enum.KeyCode.L, ["Z"] = Enum.KeyCode.Z,
    ["C"] = Enum.KeyCode.C, ["V"] = Enum.KeyCode.V, ["B"] = Enum.KeyCode.B,
}

local WHITE_KEY_CODES = {
    ["1"]=Enum.KeyCode.One, ["2"]=Enum.KeyCode.Two, ["3"]=Enum.KeyCode.Three, 
    ["4"]=Enum.KeyCode.Four, ["5"]=Enum.KeyCode.Five, ["6"]=Enum.KeyCode.Six,
    ["7"]=Enum.KeyCode.Seven, ["8"]=Enum.KeyCode.Eight, ["9"]=Enum.KeyCode.Nine, 
    ["0"]=Enum.KeyCode.Zero, ["q"]=Enum.KeyCode.Q, ["w"]=Enum.KeyCode.W, 
    ["e"]=Enum.KeyCode.E, ["r"]=Enum.KeyCode.R, ["t"]=Enum.KeyCode.T, 
    ["y"]=Enum.KeyCode.Y, ["u"]=Enum.KeyCode.U, ["i"]=Enum.KeyCode.I, 
    ["o"]=Enum.KeyCode.O, ["p"]=Enum.KeyCode.P, ["a"]=Enum.KeyCode.A, 
    ["s"]=Enum.KeyCode.S, ["d"]=Enum.KeyCode.D, ["f"]=Enum.KeyCode.F, 
    ["g"]=Enum.KeyCode.G, ["h"]=Enum.KeyCode.H, ["j"]=Enum.KeyCode.J, 
    ["k"]=Enum.KeyCode.K, ["l"]=Enum.KeyCode.L, ["z"]=Enum.KeyCode.Z, 
    ["x"]=Enum.KeyCode.X, ["c"]=Enum.KeyCode.C, ["v"]=Enum.KeyCode.V, 
    ["b"]=Enum.KeyCode.B, ["n"]=Enum.KeyCode.N, ["m"]=Enum.KeyCode.M,
}

-- ── 演奏コアロジック ───────────────────────────────────────
local function pressKey(keyStr, isLoud)
    local holdTime = isLoud and 0.12 or 0.06 -- 強調したい音は長く押す
    local blackKC = BLACK_KEY_BASE[keyStr]
    
    task.spawn(function()
        if blackKC then
            VIM:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
            VIM:SendKeyEvent(true, blackKC, false, game)
            task.wait(holdTime)
            VIM:SendKeyEvent(false, blackKC, false, game)
            VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
        else
            local whiteKC = WHITE_KEY_CODES[keyStr]
            if whiteKC then
                VIM:SendKeyEvent(true, whiteKC, false, game)
                task.wait(holdTime)
                VIM:SendKeyEvent(false, whiteKC, false, game)
            end
        end
    end)
end

local function playSong(notesTable, title)
    if isPlaying then return end
    isPlaying = true; stopFlag = false; currentSong = title
    
    Rayfield:Notify({Title="♪ "..title, Content="演奏開始（速度: "..PlaybackSpeed.."x）", Duration=3})

    task.spawn(function()
        local startTime = tick()
        -- インデックスを追跡して、ほぼ同時刻の音を「和音」として一気に処理
        for i, note in ipairs(notesTable) do
            if stopFlag then break end
            
            local targetTime = note.time / PlaybackSpeed
            local currentTime = tick() - startTime
            local waitTime = targetTime - currentTime
            
            if waitTime > 0 then
                task.wait(waitTime)
            end
            
            -- メロディラインや高音域、または特定の重要キー(!, *, ^など)を自動強調
            local emphasis = (note.key:match("[%!%*%^QWE]")) 
            pressKey(note.key, emphasis)
        end
        isPlaying = false; currentSong = ""
    end)
end

-- ── UI構築 ─────────────────────────────────────────────
local Window = Rayfield:CreateWindow({
    Name = "🎸 Libra Heart - Ultra Edition",
    LoadingTitle = "Pro Piano Player",
    LoadingSubtitle = "by Gemini Refined",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("🎹 Player", 4483345998)

MainTab:CreateSection("Playback Control")

MainTab:CreateSlider({
    Name = "演奏速度 (Speed Multiplier)",
    Range = {0.5, 2.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 1.0,
    Callback = function(Value) PlaybackSpeed = Value end,
})

MainTab:CreateSection("Libra Heart (imaizumi)")

MainTab:CreateButton({
    Name = "▶ Full Performance",
    Callback = function() playSong(notes_libraHeart, "Libra Heart Full") end,
})

-- ここに元のnotes_libraHeartなどのデータが入ります
-- (データ量は変わらないため、既存のテーブルをそのまま使用してください)

local CtrlTab = Window:CreateTab("⏹ Control", 4483345998)

CtrlTab:CreateButton({
    Name = "⏹ 演奏を強制停止",
    Callback = function() 
        stopFlag = true
        isPlaying = false
        Rayfield:Notify({Title="Stop", Content="演奏を停止しました", Duration=2})
    end,
})

local SetupTab = Window:CreateTab("⚙ Setup", 4483345998)
SetupTab:CreateButton({
    Name = "🎹 ピアノへ自動着席",
    Callback = function()
        -- (既存のsitAtPianoロジック)
        setupPiano()
    end,
})
