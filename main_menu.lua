CreateLayer("MainMenu", "VeryHighest", false) 
bg = CreateSprite("MainMenu/bg","Top",-1)
button_selected = 1
last_selected = button_selected
button_table = {}
button_table_last = {}
button_table_current = {}
button_table_table = {}
func_update_table = {} --ment for functions that are called every frame at some point
sprite_table = {}
t = 0
MENU_SETTINGS = {}
MENU_ACTIVE = true
START_OVERWORLD = false
USE_WATERMARK = true --id appreciate if you kept this, if not. credit my social somewhere else @speedg on YT
LAYER_CHANGED = false
watermark_spr = nil
table.insert(sprite_table, bg)
function bg_anim()

end


function inOutSin(t)
    return math.sin(t*math.pi-math.pi/2)/2 +0.5
end

function easeinOutSin(start_val,end_val,t)
    return start_val+inOutSin(t) * (start_val-end_val)
end

function menu_create_variable(key,default_value)
    MENU_SETTINGS[key] = default_value
end


function menu_create_sprite(x,y,spr,anchor_sprite,layer,mov_before_parent)
    if layer == nil then layer = "Top" end
    if mov_before_parent == nil then mov_before_parent = false end
    if x == nil then x = 320 end
    if y == nil then y = 240 end
    local sprite = CreateSprite("MainMenu/" .. spr,layer,-1)
    if mov_before_parent == true then
        sprite.MoveTo(x,y)
    end

    if anchor_sprite ~= nil then
        sprite.SetParent(anchor_sprite)
    end
    
    if mov_before_parent == false then
        sprite.MoveTo(x,y)
    end

    sprite["originalX"] = x
    sprite["originalY"] = y
    sprite["original_scale_X"] = 1
    sprite["original_scale_Y"] = 1

    table.insert(sprite_table, sprite)
    return sprite
end

function menu_start()
    CreateLayer("Watermark", "MainMenu", false) 
    State("PAUSE")
    Audio.Pause()
    NewAudio.CreateChannel("mus_mainmenu_bg")
    NewAudio.CreateChannel("mus_mainmenu_mus_fade")
    NewAudio.CreateChannel("mus_mainmenu_sfx")
    NewAudio.PlayMusic("mus_mainmenu_bg",  "mainmenu_bg",true,0.25)
    if USE_WATERMARK == true then
        watermark_spr = menu_create_sprite(nil,nil,"watermark",nil,"Watermark")
    end
end

function create_button_selection(key)
    if button_table_table[key] ~= nil then
        DEBUG("Custom Main Menu : BUTTON TABLE NAMED ' " .. key .. " ' ALREADY EXISTS")
        return
    end
    button_table_table[key] = {}
end

function set_button_selection_as_main(key)
    if button_table_table[key] == nil then
        DEBUG("Custom Main Menu : BUTTON TABLE ' " .. key .. " ' DOES NOT EXIST")
        return
    end
    button_table_current = button_table_table[key]
    button_selected = 1
    LAYER_CHANGED = true
end

function menu_instantiate_button(x,y,sprite,on_hover_func,exit_hover_func,idle_func,on_interact_func,table_to_insert,anchor_sprite,mov_before_parent)
    local button = menu_create_sprite(x,y,sprite,anchor_sprite,"MainMenu",mov_before_parent)
    button["hovFirst"] = false
    button["hovFunc"] = on_hover_func
    button["exitHovFunc"] = exit_hover_func
    button["exitHovCondition"] = false
    button["idleFunc"] = idle_func
    button["interactFunc"] = function() button_table_current[button_selected]["exitHovCondition"] = true on_interact_func() end
    button["t"] = math.random(0,99999)
    button["t_x"] = math.random(0,99999)
    button["t_y"] = math.random(0,99999)
    button["t_hover"] = 0
    button["t_out"] = 0
    table.insert(sprite_table, button)
    table.insert(button_table, button)
    button["orig_table_pos"] = #button_table
    table.insert(button_table_table[table_to_insert], button)
end

function menu_update()
    if MENU_ACTIVE == true then


    last_selected = button_selected
    button_table_current[button_selected]["hovFunc"]()
    bg_anim()
    for i=1, #button_table do 
        button_table[i]["idleFunc"](i) 
        if button_table[i]["exitHovCondition"] == true then
            button_table[i]["exitHovFunc"](i)
        end
    end
    for i=1,#button_table_current do
        if Input.MousePosX <= button_table_current[i].absx+(button_table_current[i].width*button_table_current[i].xscale)/2 and Input.MousePosX >= button_table_current[i].absx-(button_table_current[i].width*button_table_current[i].xscale)/2 then

            if Input.MousePosY <= button_table_current[i].absy+(button_table_current[i].height*button_table_current[i].yscale)/2 and Input.MousePosY >= button_table_current[i].absy-(button_table_current[i].height*button_table_current[i].yscale)/2 then
                button_selected = i
                if last_selected ~= button_selected then
                    NewAudio.PlaySound("mus_mainmenu_sfx",  "mus_sfx_a_target",false,0.25)
                end
                if Input.GetKey("Mouse0") == 1 then
                    button_table_current[button_selected]["interactFunc"]()
                end
            end
        end
    end
    if Input.Up == 1 then
        NewAudio.PlaySound("mus_mainmenu_sfx",  "mus_sfx_a_target",false,0.25)
        button_selected = button_selected - 1
        if button_selected == 0 then
            button_selected = #button_table_current
        end
    end
    if Input.Down == 1 then
        NewAudio.PlaySound("mus_mainmenu_sfx",  "mus_sfx_a_target",false,0.25)
        button_selected = button_selected + 1
        if button_selected > #button_table_current then
            button_selected = 1
        end
    end
    if Input.Confirm == 1 then
        button_table_current[button_selected]["interactFunc"]()
    end
    if last_selected ~= button_selected and LAYER_CHANGED == false then
        button_table_current[last_selected]["exitHovCondition"] = true
        button_table_current[last_selected]["t_out"] = 0
    end
    for i=1, #func_update_table do 
        func_update_table[i]()
    end
    t=t+1
    LAYER_CHANGED = false
    end
end


------------ PRESETS ------------


function preset_move_forward(target_x,target_y) 
    if button_table_current[button_selected]["hovFirst"] == false then
        button_table_current[button_selected]["targetX"] = target_x
        button_table_current[button_selected]["targetY"] = target_y
        button_table_current[button_selected]["hovFirst"] = true
    end
end

function preset_exit_move_foward(i) 
    button_table[i]["hovFirst"] = false
    button_table[i]["targetX"] = button_table[i]["originalX"]
    button_table[i]["targetY"] = button_table[i]["originalY"]
    button_table[i]["exitHovCondition"] = false
end

function preset_move_to(object,axis)
    if axis == "x" then
        target = object["targetX"]
        resultSnap1 = target
        resultSnap2 = object.y
        moving_axis = object.x
        move_axis_1 = -(moving_axis-target)/12
        move_axis_2 = 0
    end
    if axis == "y" then
        target = object["targetY"]
        resultSnap2 = target
        resultSnap1 = object.x
        moving_axis = object.y
        move_axis_2 = -(moving_axis-target)/12
        move_axis_1 = 0
    end
    object.Move(move_axis_1,move_axis_2)
    if target-0.2 <= moving_axis  and  moving_axis <=0.2+target then
        object.MoveTo(resultSnap1,resultSnap2)
        target = nil
    end
end

function preset_hover_y(i)

    if button_table[i]["oldidlex"] == nil then
        button_table[i]["oldidlex"] = 0
    end

    button_table[i]["idlex"] = 0
    button_table[i].MoveTo(button_table[i].x-button_table[i]["oldidlex"] + button_table[i]["idlex"],button_table[i].y)
    button_table[i]["oldidlex"] = button_table[i]["idlex"]
    button_table[i]["oldidley"] = button_table[i]["idley"]
    button_table[i]["t_x"] = button_table[i]["t_x"] +0.05


    if button_table[i]["oldidley"] == nil then
        button_table[i]["oldidley"] = math.sin(button_table[i]["t_y"])*5
    end
    button_table[i]["idley"] = math.sin(button_table[i]["t_y"])*5
    button_table[i].MoveTo(button_table[i].x,button_table[i].y-button_table[i]["oldidley"] + button_table[i]["idley"])
    button_table[i]["oldidley"] = button_table[i]["idley"]
    button_table[i]["t_y"] = button_table[i]["t_y"] +0.05
end

function preset_move(obj)
    if obj["targetX"] ~= nil then
        preset_move_to(obj,"x")
    end
    if obj["targetY"] ~= nil then
        preset_move_to(obj,"y")
    end
end

function preset_scale_to(object,axis)
    if axis == "x" then
        object.xscale = object.xscale - (object.xscale-object["target_scale_X"])/12
        if object["target_scale_X"]-0.02 <= object.xscale  and  object.xscale <=0.02+object["target_scale_X"] then
            object.xscale = object["target_scale_X"]
            object["target_scale_X"] = nil
        end
    end
    if axis == "y" then
        object.yscale = object.yscale - (object.yscale-object["target_scale_Y"])/12
        if object["target_scale_Y"]-0.02 <= object.yscale  and  object.yscale <=0.02+object["target_scale_Y"] then
            object.yscale = object["target_scale_Y"]
            object["target_scale_Y"] = nil
        end
    end
end

function preset_enter_scale(scale_x,scale_y,obj)
    if obj["hovFirst"] == false then
        obj["target_scale_X"] = scale_x
        obj["target_scale_Y"] = scale_y
        obj["hovFirst"] = true
    end
end

function preset_exit_scale(obj)
    obj["hovFirst"] = false
    obj["target_scale_X"] = obj["original_scale_X"]
    obj["target_scale_Y"] = obj["original_scale_Y"]
    obj["exitHovCondition"] = false
end

function preset_scale(obj)
    if obj["target_scale_X"] ~= nil then
        preset_scale_to(obj,"x")
    end
    if obj["target_scale_Y"] ~= nil then
        preset_scale_to(obj,"y")
    end
end

function sound_settings_callback()

end

function on_fight_menu_play()
    for i=1, #sprite_table do 
        sprite_table[i].Move(999999,999999)
    end
    MENU_ACTIVE = false
    if START_OVERWORLD == false then
        State("ACTIONSELECT")
        Audio.Unpause()
    else

    end
end

function preset_play_transition_update(vol_num,alpha_screen,screen)
    local bg_vol = vol_num
    local alpha = alpha_screen
    if bg_vol ~= 0 then
        bg_vol = bg_vol - 0.001
    end
    if alpha < 1 then
        alpha = alpha + 0.003334
    end
    if alpha > 1 then alpha = 1 end
    screen.alpha = alpha
    NewAudio.SetVolume("mus_mainmenu_bg",bg_vol)
    func_update_table[1] = function() preset_play_transition_update(bg_vol,alpha,screen) end
    if  NewAudio.GetPlayTime("mus_mainmenu_mus_fade") >= 5.1890 then
        on_fight_menu_play()
    end
end

function preset_play_transition_fade_white()
    NewAudio.PlaySound("mus_mainmenu_sfx",  "snd_select",false,0.25)
    NewAudio.PlayMusic("mus_mainmenu_mus_fade",  "mus_cymbal",false,0.50)
    preset_play_transition_update(NewAudio.GetVolume("mus_mainmenu_bg"),0,menu_create_sprite(nil,nil,"fadeScreen",nil,"Watermark"))
end


function menu_create_slider(x,y,key,max_val,min_val,increment,override_slider_img,override_knob,parent_obj,parent_button_selec,display_str,callback_func)
    local img = "slider"
    if override_slider_img ~= nil then
        img = override_slider_img
    end
    local knob = "knob"
    if override_slider_img ~= nil then
        knob = override_knob
    end
    local img_measurement = menu_create_sprite(0,0,img,nil,"Bottom",false)
    local obj_knob = nil
    local text = CreateText("[instant]Master volume : 0", {0,0},999,"Top",-1)
    text.progressmode = "none"
    text.color = {1,1,1}
    text.HideBubble()
    text.SetParent(parent_obj)
    text.MoveTo(x-(img_measurement.width)/2,y+20)
    menu_instantiate_button(x,y,img,
    function() preset_enter_scale(1.5,1.5,obj_knob) end,
    
    function(i) preset_exit_scale(obj_knob) end,
    
    function(i) 
        preset_scale(obj_knob) 
        key_input = 2
        if Input.GetKey("LeftShift") == 2 then
            key_input = 1
        end
        if Input.Right == key_input then
            if MENU_SETTINGS[key] + increment <= max_val then
                MENU_SETTINGS[key] = MENU_SETTINGS[key] + increment
                callback_func()
            end
        end
        if Input.Left == key_input then
            if MENU_SETTINGS[key] - increment >= min_val then
                MENU_SETTINGS[key] = MENU_SETTINGS[key] - increment
                callback_func()
            end
        end
        obj_knob.x = (MENU_SETTINGS[key]/max_val-max_val/2)*(button_table[i].width)
        if button_table_current[button_selected] == button_table[i] then
            if Input.GetKey("Mouse0") == 2 then
                MENU_SETTINGS[key] = (((Input.MousePosX-button_table_current[button_selected].absx)/button_table_current[button_selected].width)+0.5)*max_val
                callback_func()
            end
        end
        if MENU_SETTINGS[key] < min_val then MENU_SETTINGS[key] = min_val end
        if MENU_SETTINGS[key] > max_val then MENU_SETTINGS[key] = max_val end
        
        text.SetText("[instant]" .. display_str .. math.floor(MENU_SETTINGS[key]*100)/100)
    end,

    function() end,
    
    parent_button_selec,
    parent_obj)
    obj_knob = menu_create_sprite(0,0,knob,button_table[#button_table],"Top",false)
end