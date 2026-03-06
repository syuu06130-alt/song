-- Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Libra Heart Player",
   LoadingTitle = "Libra Heart",
   LoadingSubtitle = "imaizumi",
   ConfigurationSaving = {
      Enabled = false
   }
})

local Tab = Window:CreateTab("Player", 4483362458)

-- Virtual Keyboard
local vim = game:GetService("VirtualInputManager")

local function press(key)
    vim:SendKeyEvent(true, key, false, game)
    task.wait(0.05)
    vim:SendKeyEvent(false, key, false, game)
end

-- Libra Heart Notes
-- ここに曲を入れる
local song = {
    "7","0","q","0",
    "6","9","0","9",

    "7","0","q","w",
    "0","9","7",

    "6","7","9","0",
    "q","0","9"
}

local playing = false

local function playSong()
    playing = true

    for i,v in ipairs(song) do
        if not playing then break end
        press(v)
        task.wait(0.12)
    end

    playing = false
end

Tab:CreateButton({
   Name = "Play Libra Heart",
   Callback = function()
      playSong()
   end,
})

Tab:CreateButton({
   Name = "Stop",
   Callback = function()
      playing = false
   end,
})
