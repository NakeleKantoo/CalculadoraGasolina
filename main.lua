suit = require('suit')
require("json")
love.graphics.setBackgroundColor(love.math.colorFromBytes(30,30,30))
textfont = love.graphics.newFont("SpaceMono-Regular.ttf",20)
boxfont = love.graphics.newFont("SpaceMono-Regular.ttf",18)
mostrar = nil
local gas_to_km = 0
local eta_to_km = 0
local preco_gas = {text="5.5"}
local preco_eta = {text="4.8"}
local rende_gas = {text="8.2"}
local rende_eta = {text="5.5"}
salvar_menu = false
carregar_menu = false

save = {preco_gas=preco_gas,preco_eta=preco_eta,rende_gas=rende_gas,rende_eta=rende_eta}

function love.load()
    suit.theme.color.normal.fg = {255,255,255}
    suit.theme.color.hovered = {bg = {200,230,255}, fg = {0,0,0}}
    mobileStraight()
    suit.layout:reset(0,0)
    y = screenh/2-screenh/4
    if love.filesystem.getInfo("save.json") then
        save = json.decode(love.filesystem.read("save.json"))
        preco_gas = save.preco_gas
        preco_eta = save.preco_eta
        rende_gas = save.rende_gas
        rende_eta = save.rende_eta
    else
        love.filesystem.write("save.json",json.encode(save))
    end
end

function love.update(dt)
    -- Put a button on the screen. If hit, show a message.
    suit.Label("Calculadora de preço", {font=textfont},10,10,screenw-20,30)
    y = screenh/2-screenh/4-screenh/8
    suit.Label("Preço da Gasolina:", {font=textfont},10,y,screenw-20,30)
    y=y+35
    if suit.Button("+",{id=100,font=boxfont},screenw-10-30,y,30,30).hit then preco_gas.text=tostring(tonumber(preco_gas.text)+0.1) end
    if suit.Button("-",{id=2,font=boxfont},screenw-10-60,y,30,30).hit then preco_gas.text=tostring(tonumber(preco_gas.text)-0.1) end
    suit.Input(preco_gas,{font=boxfont},10,y,screenw-20,30)
    y=y+35
    suit.Label("Rendimento Gasolina (km/L):", {font=textfont},10,y,screenw-20,30)
    y=y+35
    if suit.Button("+",{id=300,font=boxfont},screenw-10-30,y,30,30).hit then rende_gas.text=tostring(tonumber(rende_gas.text)+0.1) end
    if suit.Button("-",{id=4,font=boxfont},screenw-10-60,y,30,30).hit then rende_gas.text=tostring(tonumber(rende_gas.text)-0.1) end
    suit.Input(rende_gas,{font=boxfont},10,y,screenw-20,30)
    y=y+35
    suit.Label("Preço do Etanol:", {font=textfont},10,y,screenw-20,30)
    y=y+35
    if suit.Button("+",{id=500,font=boxfont},screenw-10-30,y,30,30).hit then preco_eta.text=tostring(tonumber(preco_eta.text)+0.1) end
    if suit.Button("-",{id=6,font=boxfont},screenw-10-60,y,30,30).hit then preco_eta.text=tostring(tonumber(preco_eta.text)-0.1) end
    suit.Input(preco_eta,{font=boxfont},10,y,screenw-20,30)
    y=y+35
    suit.Label("Rendimento Etanol (km/L):", {font=textfont},10,y,screenw-20,30)
    y=y+35
    if suit.Button("+",{id=700,font=boxfont},screenw-10-30,y,30,30).hit then rende_eta.text=tostring(tonumber(rende_eta.text)+0.1) end
    if suit.Button("-",{id=8,font=boxfont},screenw-10-60,y,30,30).hit then rende_eta.text=tostring(tonumber(rende_eta.text)-0.1) end
    suit.Input(rende_eta,{font=boxfont},10,y,screenw-20,30)
    --print(preco_gas)
    y=y+55

    if suit.Button("Calcular",{font=textfont},10,y,screenw-20,45).hit then
        --regra de tres
        --rende gas => preco gas
        --rende eta => preco eta(x)
        npreco_gas=tonumber(preco_gas.text)
        npreco_eta=tonumber(preco_eta.text)
        nrende_gas=tonumber(rende_gas.text)
        nrende_eta=tonumber(rende_eta.text)
        local target = (npreco_gas*nrende_eta)/nrende_gas
        gas_to_km = ((nrende_gas/npreco_gas)/(2.5))*(screenw-20)
        eta_to_km = ((nrende_eta/npreco_eta)/(2.5))*(screenw-20)
        print(gas_to_km, eta_to_km)
        if target>=npreco_eta then
            mostrar="Compensa comprar etanol"
        else
            mostrar="Compensa comprar gasolina"
        end
    end
    y=y+35+15
    if mostrar then
        suit.Label(mostrar,{font=textfont},10,y,screenw-20,30)
    end
    if suit.Button("Salvar",{font=textfont},10,screenh-55,screenw/3.5,45).hit then
        save.preco_gas = preco_gas
        save.preco_eta = preco_eta
        save.rende_gas = rende_gas
        save.rende_eta = rende_eta
        love.filesystem.write("save.json",json.encode(save))
    end
    if suit.Button("Carregar",{font=textfont},screenw-screenw/3.5-15,screenh-55,screenw/3.5,45).hit then
        save = json.decode(love.filesystem.read("save.json"))
        preco_gas = save.preco_gas
        preco_eta = save.preco_eta
        rende_gas = save.rende_gas
        rende_eta = save.rende_eta
    end
end

function love.draw()
    suit.draw()
    if mostrar then
        y=y+35
        love.graphics.setColor(0.4,0.15,0.15)
        love.graphics.rectangle('fill',10,y,screenw-20,30)
        love.graphics.setColor(0.85,0.25,0.25)
        love.graphics.rectangle('fill',10,y,gas_to_km,30)
        love.graphics.setColor(1,1,1)
        love.graphics.printf("Gasolina: "..truncate(gas_to_km/(screenw-20),2).."km/R$",boxfont,10,y,screenw-20,"center")
        y=y+35
        love.graphics.setColor(0.15,0.4,0.15)
        love.graphics.rectangle('fill',10,y,screenw-20,30)
        love.graphics.setColor(0.25,0.85,0.25)
        love.graphics.rectangle('fill',10,y,eta_to_km,30)
        love.graphics.setColor(1,1,1)
        love.graphics.printf("Etanol: "..truncate(eta_to_km/(screenw-20),2).."km/R$",boxfont,10,y,screenw-20,"center")
    end
end

function love.textinput(t)
    suit.textinput(t)
end

function love.keypressed(key)
    suit.keypressed(key)
end

function mobileStraight()  
    local wait=true
    while wait do
        love.window.maximize()
        love.window.setMode(600,650)
        local tx, ty = love.graphics.getDimensions()
        if ty>tx then wait=false end
    end
    local standard = 392 -- my phone's width
    screenw, screenh = love.graphics.getDimensions()
end

function truncate(number, decimals)
    local factor = 10 ^ decimals
    return math.floor(number * factor) / factor
end