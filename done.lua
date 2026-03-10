-- ============================================================
-- 🌐 Virtual Space ID Finder v1.0
-- Roblox Place / Universe / Server 情報取得ツール
-- Rayfield UI | コピー機能付き
-- ============================================================

local Rayfield     = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players      = game:GetService("Players")
local TeleportSvc  = game:GetService("TeleportService")
local MarketSvc    = game:GetService("MarketplaceService")
local HttpSvc      = game:GetService("HttpService")
local RunSvc       = game:GetService("RunService")
local StarterGui   = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- ============================================================
-- クリップボードコピー helper
-- ============================================================
local function copyToClipboard(text)
    local ok = pcall(function()
        setclipboard(tostring(text))
    end)
    if ok then
        Rayfield:Notify({
            Title   = "📋 コピー完了",
            Content = tostring(text),
            Duration = 2,
            Image   = "rbxassetid://4483345998"
        })
    else
        Rayfield:Notify({
            Title   = "⚠️ コピー失敗",
            Content = "setclipboard 未対応のExecutorです",
            Duration = 3,
            Image   = "rbxassetid://4483345998"
        })
    end
end

-- ============================================================
-- ゲーム情報取得
-- ============================================================
local function getGameInfo()
    local info = {}

    -- 基本ID
    info.placeId      = tostring(game.PlaceId)
    info.universeId   = tostring(game.GameId)
    info.jobId        = tostring(game.JobId)
    info.placeVersion = tostring(game.PlaceVersion)

    -- サーバー情報
    info.serverType = RunSvc:IsStudio() and "Studio" or "Live Server"
    info.playerCount = tostring(#Players:GetPlayers())

    -- MarketplaceService でゲーム名取得
    local ok, result = pcall(function()
        return MarketSvc:GetProductInfo(game.PlaceId, Enum.InfoType.Asset)
    end)
    if ok and result then
        info.gameName   = result.Name or "Unknown"
        info.creator    = result.Creator and result.Creator.Name or "Unknown"
        info.creatorType = result.Creator and (result.Creator.CreatorType == Enum.CreatorType.Group and "Group" or "User") or "Unknown"
    else
        info.gameName   = "取得失敗"
        info.creator    = "取得失敗"
        info.creatorType = "?"
    end

    -- プレイヤー情報
    info.userId       = tostring(player.UserId)
    info.userName     = player.Name
    info.displayName  = player.DisplayName

    -- URL 生成
    info.gameUrl      = "https://www.roblox.com/games/" .. info.placeId
    info.profileUrl   = "https://www.roblox.com/users/" .. info.userId .. "/profile"

    return info
end

-- ============================================================
-- 他プレイヤー情報
-- ============================================================
local function getPlayerInfo(targetPlayer)
    local info = {}
    info.name        = targetPlayer.Name
    info.displayName = targetPlayer.DisplayName
    info.userId      = tostring(targetPlayer.UserId)
    info.accountAge  = tostring(targetPlayer.AccountAge) .. " days"
    info.profileUrl  = "https://www.roblox.com/users/" .. info.userId .. "/profile"

    -- キャラクター情報
    local char = targetPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos = hrp.Position
            info.position = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        else
            info.position = "N/A"
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        info.health = hum and string.format("%.0f / %.0f", hum.Health, hum.MaxHealth) or "N/A"
    else
        info.position = "N/A"
        info.health   = "N/A"
    end

    return info
end

-- ============================================================
-- Rayfield Window
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name             = "🌐 Virtual Space ID Finder",
    LoadingTitle     = "Space ID Finder",
    LoadingSubtitle  = "Roblox ID 取得ツール v1.0",
    ConfigurationSaving = {Enabled = false},
    Discord          = {Enabled = false},
    KeySystem        = false,
})

-- ============================================================
-- 🏠 Current Game タブ
-- ============================================================
local TabGame = Window:CreateTab("🏠 Current Game", 4483345998)
TabGame:CreateSection("現在のゲーム情報")

local gameInfo = getGameInfo()

TabGame:CreateLabel("🎮 Game: " .. gameInfo.gameName)
TabGame:CreateLabel("👤 Creator: " .. gameInfo.creator .. " (" .. gameInfo.creatorType .. ")")

TabGame:CreateSection("IDs")

-- Place ID
TabGame:CreateButton({
    Name     = "📋 Place ID: " .. gameInfo.placeId,
    Callback = function() copyToClipboard(gameInfo.placeId) end,
})

-- Universe ID
TabGame:CreateButton({
    Name     = "📋 Universe ID: " .. gameInfo.universeId,
    Callback = function() copyToClipboard(gameInfo.universeId) end,
})

-- Job ID (Server ID)
TabGame:CreateButton({
    Name     = "📋 Job ID (Server): " .. gameInfo.jobId:sub(1, 20) .. "...",
    Callback = function() copyToClipboard(gameInfo.jobId) end,
})

-- Place Version
TabGame:CreateButton({
    Name     = "📋 Place Version: " .. gameInfo.placeVersion,
    Callback = function() copyToClipboard(gameInfo.placeVersion) end,
})

-- Game URL
TabGame:CreateButton({
    Name     = "📋 Game URL をコピー",
    Callback = function() copyToClipboard(gameInfo.gameUrl) end,
})

TabGame:CreateSection("Server Info")
TabGame:CreateLabel("🖥 Server Type: " .. gameInfo.serverType)
TabGame:CreateLabel("👥 Players: " .. gameInfo.playerCount .. " / " .. tostring(Players.MaxPlayers))

TabGame:CreateButton({
    Name = "🔄 情報を再取得",
    Callback = function()
        gameInfo = getGameInfo()
        Rayfield:Notify({
            Title   = "✅ 再取得完了",
            Content = "Game: " .. gameInfo.gameName,
            Duration = 3,
            Image   = "rbxassetid://4483345998"
        })
    end,
})

-- ============================================================
-- 👤 My Profile タブ
-- ============================================================
local TabMe = Window:CreateTab("👤 My Profile", 4483345998)
TabMe:CreateSection("自分のプロフィール情報")

TabMe:CreateLabel("🏷 Name: " .. gameInfo.userName)
TabMe:CreateLabel("💬 Display: " .. gameInfo.displayName)

TabMe:CreateSection("My IDs")

TabMe:CreateButton({
    Name     = "📋 User ID: " .. gameInfo.userId,
    Callback = function() copyToClipboard(gameInfo.userId) end,
})

TabMe:CreateButton({
    Name     = "📋 Profile URL をコピー",
    Callback = function() copyToClipboard(gameInfo.profileUrl) end,
})

-- ============================================================
-- 👥 Players タブ
-- ============================================================
local TabPlayers = Window:CreateTab("👥 Players", 4483345998)
TabPlayers:CreateSection("サーバー内プレイヤー")

local function refreshPlayerList(tab)
    -- ※ Rayfieldは動的更新できないため通知で表示
    local lines = {}
    for _, p in ipairs(Players:GetPlayers()) do
        local pi = getPlayerInfo(p)
        table.insert(lines, string.format(
            "[%s] ID:%s | HP:%s | Pos:%s",
            pi.name, pi.userId, pi.health, pi.position
        ))
    end
    local full = table.concat(lines, "\n")
    Rayfield:Notify({
        Title   = "👥 " .. #Players:GetPlayers() .. " Players",
        Content = lines[1] or "No players",
        Duration = 6,
        Image   = "rbxassetid://4483345998"
    })
    print("=== PLAYERS ===")
    for _, l in ipairs(lines) do print(l) end
    print("===============")
end

TabPlayers:CreateButton({
    Name = "🔄 プレイヤー一覧を取得 (コンソール出力)",
    Callback = function() refreshPlayerList(TabPlayers) end,
})

TabPlayers:CreateSection("個別プレイヤーID取得")

-- 現在のプレイヤーリストからボタン生成
for _, p in ipairs(Players:GetPlayers()) do
    local targetPlayer = p
    local pid = tostring(p.UserId)
    TabPlayers:CreateButton({
        Name     = "📋 " .. p.Name .. " (ID: " .. pid .. ")",
        Callback = function()
            local pi = getPlayerInfo(targetPlayer)
            copyToClipboard(pi.userId)
            Rayfield:Notify({
                Title   = "📋 " .. pi.name,
                Content = "UserID: " .. pi.userId .. " | Age: " .. pi.accountAge,
                Duration = 4,
                Image   = "rbxassetid://4483345998"
            })
        end,
    })
end

TabPlayers:CreateSection("Note")
TabPlayers:CreateLabel("ボタンはスクリプト実行時点のメンバー")
TabPlayers:CreateLabel("再実行で最新リストになります")

-- ============================================================
-- 🔍 ID Lookup タブ
-- ============================================================
local TabLookup = Window:CreateTab("🔍 ID Lookup", 4483345998)
TabLookup:CreateSection("Place ID → 情報取得")
TabLookup:CreateLabel("Place IDを入力してゲーム名を検索")

local lookupId = ""

TabLookup:CreateInput({
    Name            = "Place ID",
    PlaceholderText = "例: 606849621",
    RemoveTextAfterFocusLost = false,
    Flag            = "lookupPlaceId",
    Callback        = function(v) lookupId = v:gsub("%s+", "") end,
})

TabLookup:CreateButton({
    Name = "🔍 ゲーム情報を取得",
    Callback = function()
        if lookupId == "" or not lookupId:match("^%d+$") then
            Rayfield:Notify({Title="⚠️ 無効なID", Content="数字のPlace IDを入力してください", Duration=3, Image="rbxassetid://4483345998"})
            return
        end
        local ok, result = pcall(function()
            return MarketSvc:GetProductInfo(tonumber(lookupId), Enum.InfoType.Asset)
        end)
        if ok and result then
            local name    = result.Name or "Unknown"
            local creator = result.Creator and result.Creator.Name or "Unknown"
            local url     = "https://www.roblox.com/games/" .. lookupId
            Rayfield:Notify({
                Title   = "🎮 " .. name,
                Content = "Creator: " .. creator .. " | ID: " .. lookupId,
                Duration = 7,
                Image   = "rbxassetid://4483345998"
            })
            print("=== LOOKUP RESULT ===")
            print("Name   : " .. name)
            print("Creator: " .. creator)
            print("PlaceID: " .. lookupId)
            print("URL    : " .. url)
            print("=====================")
        else
            Rayfield:Notify({Title="❌ 取得失敗", Content="ID: " .. lookupId .. " が見つかりません", Duration=4, Image="rbxassetid://4483345998"})
        end
    end,
})

TabLookup:CreateButton({
    Name = "📋 入力したIDをコピー",
    Callback = function()
        if lookupId ~= "" then copyToClipboard(lookupId)
        else Rayfield:Notify({Title="⚠️", Content="IDを入力してください", Duration=2, Image="rbxassetid://4483345998"}) end
    end,
})

TabLookup:CreateSection("Game URL 生成")
TabLookup:CreateLabel("Place IDから直接URLを生成してコピー")

TabLookup:CreateButton({
    Name = "🔗 Game URL を生成 & コピー",
    Callback = function()
        if lookupId == "" or not lookupId:match("^%d+$") then
            Rayfield:Notify({Title="⚠️", Content="まずPlace IDを入力してください", Duration=3, Image="rbxassetid://4483345998"})
            return
        end
        local url = "https://www.roblox.com/games/" .. lookupId
        copyToClipboard(url)
    end,
})

-- ============================================================
-- 📊 Full Summary タブ
-- ============================================================
local TabSummary = Window:CreateTab("📊 Summary", 4483345998)
TabSummary:CreateSection("全情報サマリー")

TabSummary:CreateButton({
    Name = "📋 全情報をコンソールに出力",
    Callback = function()
        local gi = getGameInfo()
        print("========== SPACE ID SUMMARY ==========")
        print("Game Name   : " .. gi.gameName)
        print("Creator     : " .. gi.creator .. " (" .. gi.creatorType .. ")")
        print("Place ID    : " .. gi.placeId)
        print("Universe ID : " .. gi.universeId)
        print("Job ID      : " .. gi.jobId)
        print("Version     : " .. gi.placeVersion)
        print("Server Type : " .. gi.serverType)
        print("Players     : " .. gi.playerCount .. "/" .. Players.MaxPlayers)
        print("Game URL    : " .. gi.gameUrl)
        print("---------- MY PROFILE ----------")
        print("Username    : " .. gi.userName)
        print("DisplayName : " .. gi.displayName)
        print("User ID     : " .. gi.userId)
        print("Profile URL : " .. gi.profileUrl)
        print("======================================")
        Rayfield:Notify({Title="📊 出力完了", Content="コンソール(F9)を確認してください", Duration=4, Image="rbxassetid://4483345998"})
    end,
})

TabSummary:CreateButton({
    Name = "📋 Place ID をコピー",
    Callback = function() copyToClipboard(gameInfo.placeId) end,
})
TabSummary:CreateButton({
    Name = "📋 Universe ID をコピー",
    Callback = function() copyToClipboard(gameInfo.universeId) end,
})
TabSummary:CreateButton({
    Name = "📋 User ID をコピー",
    Callback = function() copyToClipboard(gameInfo.userId) end,
})
TabSummary:CreateButton({
    Name = "📋 Job ID (Full) をコピー",
    Callback = function() copyToClipboard(gameInfo.jobId) end,
})
TabSummary:CreateButton({
    Name = "📋 Game URL をコピー",
    Callback = function() copyToClipboard(gameInfo.gameUrl) end,
})

TabSummary:CreateSection("Teleport")
TabSummary:CreateLabel("Place IDを使って別サーバーへ移動")

local teleportId = ""
TabSummary:CreateInput({
    Name            = "Teleport先 Place ID",
    PlaceholderText = "例: 606849621",
    RemoveTextAfterFocusLost = false,
    Flag            = "teleportId",
    Callback        = function(v) teleportId = v:gsub("%s+", "") end,
})
TabSummary:CreateButton({
    Name = "🚀 Teleport",
    Callback = function()
        if teleportId == "" or not teleportId:match("^%d+$") then
            Rayfield:Notify({Title="⚠️", Content="有効なPlace IDを入力してください", Duration=3, Image="rbxassetid://4483345998"})
            return
        end
        Rayfield:Notify({Title="🚀 Teleport中...", Content="Place ID: " .. teleportId, Duration=3, Image="rbxassetid://4483345998"})
        task.wait(1)
        TeleportSvc:Teleport(tonumber(teleportId), player)
    end,
})

-- ============================================================
-- Init
-- ============================================================
Rayfield:Notify({
    Title   = "🌐 Space ID Finder Ready!",
    Content = "Game: " .. gameInfo.gameName .. " | ID: " .. gameInfo.placeId,
    Duration = 6,
    Image   = "rbxassetid://4483345998"
})
