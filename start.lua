local AutoFiles_Write = function() 
local Create_Info = function(Token,Sudo)  
local Write_Info_Sudo = io.open("sudo.lua", 'w')
Write_Info_Sudo:write([[

s = "XXKXX"

q = "FileBots"

token = "]]..Token..[["

Sudo = ]]..Sudo..[[  

]])
Write_Info_Sudo:close()
end  

if not database:get(Server_Done.."Token_Write") then
print("\27[1;34m»» Send Your Token Bot :\27[m")
local token = io.read()
if token ~= '' then
local url , res = https.request('https://api.telegram.org/bot'..token..'/getMe')
if res ~= 200 then
io.write('\n\27[1;31mSorry The Token is not Correct \n\27[0;39;49m')
else
io.write('\n\27[1;31mThe Token Is Saved\n\27[0;39;49m')
database:set(Server_Done.."Token_Write",token)
end 
else
io.write('\n\27[1;31mThe Tokem was not Saved\n\27[0;39;49m')
end 
os.execute('lua start.lua')
end

if not database:get(Server_Done.."UserSudo_Write") then
print("\27[1;34mSend Your Id Sudo :\27[m")
local Id = io.read():gsub(' ','') 
if tostring(Id):match('%d+') then
    -- الحصول على التوكن من قاعدة البيانات
    local bot_token = database:get(Server_Done.."Token_Write")
    
    if bot_token then
        -- التحقق من صحة المعرف عن طريق طلب معلومات المستخدم من Telegram API مباشرة
        local api_url = "https://api.telegram.org/bot" .. bot_token .. "/getChat?chat_id=" .. Id
        local data, res = https.request(api_url)
        
        if res == 200 then
            local decoded_data = json:decode(data)
            -- إذا كان الحقل ok يساوي true فهذا يعني أن المعرف صحيح
            if decoded_data and decoded_data.ok == true then
                io.write('\n\27[1;31mThe Id Is Saved (Verified via Telegram API)\n\27[0;39;49m')
                database:set(Server_Done.."UserSudo_Write",Id)
            else
                io.write('\n\27[1;31mSorry, The Id is not valid or the bot cannot message this user.\n\27[0;39;49m')
            end
        else
            io.write('\n\27[1;31mFailed to verify Id. Please check your Token or Id.\n\27[0;39;49m')
        end
    else
        io.write('\n\27[1;31mBot Token not found. Please re-enter your Token first.\n\27[0;39;49m')
    end
else
    io.write('\n\27[1;31mThe Id was not Saved (Invalid format)\n\27[0;39;49m')
end
os.execute('lua start.lua')
end

local function Files_Info_Get()
Create_Info(database:get(Server_Done.."Token_Write"),database:get(Server_Done.."UserSudo_Write"))   
-- تم إزالة الطلب الخارجي لـ black-source.tk تمامًا
print("::Elvon::")
local RunBot = io.open("Elvon", 'w')
RunBot:write([[
#!/usr/bin/env bash
cd $HOME/Elvon
token="]]..database:get(Server_Done.."Token_Write")..[["
rm -fr Elvon.lua
wget "https://raw.githubusercontent.com/SourceElvon/Elvon/master/Elvon.lua"
while(true) do
rm -fr ../.telegram-cli
./tg -s ./Elvon.lua -p PROFILE --bot=$token
done
]])
RunBot:close()
local RunTs = io.open("ts", 'w')
RunTs:write([[
#!/usr/bin/env bash
cd $HOME/Elvon
while(true) do
rm -fr ../.telegram-cli
screen -S Elvon -X kill
screen -S Elvon ./Elvon
done
]])
RunTs:close()
end
Files_Info_Get()
database:del(Server_Done.."Token_Write");database:del(Server_Done.."UserSudo_Write")
sudos = dofile('sudo.lua')
os.execute('./install.sh ins')
end 
