-- A basic encounter script skeleton you can copy and modify for your own creations.

-- music = "shine_on_you_crazy_diamond" --Either OGG or WAV. Extension is added automatically. Uncomment for custom music.
encountertext = "Poseur strikes a pose!" --Modify as necessary. It will only be read out in the action select screen.
nextwaves = {"bullettest_chaserorb"}
wavetimer = 4.0
arenasize = {155, 130}

enemies = {
"poseur"
}

enemypositions = {
{0, 0}
}
corritor_time = 0
-- A custom list with attacks to choose from. Actual selection happens in EnemyDialogueEnding(). Put here in case you want to use it.
possible_attacks = {"bullettest_bouncy", "bullettest_chaserorb", "bullettest_touhou"}
function EncounterStarting()
    require "main_menu"
    menu_start()
    lastCorr = menu_create_sprite(0,nil,"lastCorr")
    overlay = menu_create_sprite(nil,nil,"overlay")
    main_buttons_panel = menu_create_sprite(0,0, "invis_panel")
    main_buttons_panel.alpha = 0
    options_panel = menu_create_sprite(0,nil, "panel")
    credits_panel = menu_create_sprite(0,nil, "panel")
    credits = menu_create_sprite(0,nil, "credits")
    credits.SetParent(credits_panel)
    options_panel.Move(640-options_panel.width/2,0)
    credits_panel.Move(640-credits_panel.width/2,0)
    lastCorr.yscale = 2
    lastCorr.xscale = 2
    -- If you want to change the game state immediately, this is the place.
    bg_anim = function() 
        lastCorr.x = ((lastCorr.width*lastCorr.xscale)/1.7)-(corritor_time*2) if corritor_time >= lastCorr.width then corritor_time = 0 else corritor_time = corritor_time +1 end 
        preset_move(credits_panel)   
        preset_move(options_panel) 
        preset_move(main_buttons_panel)    
    end
    create_button_selection("main_buttons")
    create_button_selection("credits")
    create_button_selection("options")
    set_button_selection_as_main("main_buttons")

    --------------------------------------------------------------------------------

    menu_instantiate_button(500,400,"button_play",
        function() preset_move_forward(400,button_table_current[button_selected].y+10) end,

        function(i) preset_exit_move_foward(i) end,

        function(i) preset_hover_y(i) preset_move(button_table[i]) end,
        
        function() preset_play_transition_fade_white(1) end,
    
        "main_buttons",
        main_buttons_panel)

    --------------------------------------------------------------------------------

    menu_instantiate_button(500,275,"button_options",
        function() preset_move_forward(400,button_table_current[button_selected].y+20) end,

        function(i) preset_exit_move_foward(i) end,

        function(i) preset_hover_y(i) preset_move(button_table[i]) end,
        
        function()  set_button_selection_as_main("options")
                    options_panel["targetX"] = 640-options_panel.width/2
                    main_buttons_panel["targetX"] = 640
        end,
    
        "main_buttons",
        main_buttons_panel)


    --------------------------------------------------------------------------------

    menu_instantiate_button(500,150,"button_credits",
        function() preset_move_forward(400,button_table_current[button_selected].y+20) end,

        function(i) preset_exit_move_foward(i) end,

        function(i) preset_hover_y(i) preset_move(button_table[i]) end,
        
        function()  set_button_selection_as_main("credits")
                    credits_panel["targetX"] = 640-credits_panel.width/2
                    main_buttons_panel["targetX"] = 640
        end,
    
        "main_buttons",
        main_buttons_panel)

    --------------------------------------------------------------------------------

    menu_instantiate_button(20,-100,"button",
        function() preset_move_forward(-50,button_table_current[button_selected].y-50) end,

        function(i) preset_exit_move_foward(i) end,

        function(i) preset_hover_y(i) preset_move(button_table[i]) end,
        
        function() end,
    
        "options",
        options_panel)

    --------------------------------------------------------------------------------
    
    menu_create_variable("Master_Volume",1)
    menu_create_variable("Music_Volume",0.25)
    menu_create_variable("SFX_Volume",0.25)
    menu_create_slider(30.5,175,"Master_Volume",1.00,0,0.01,nil,nil,options_panel,"options","Master volume : ",function() sound_settings_callback() end)
    menu_create_slider(30.5,120,"Music_Volume",1.00,0,0.01,nil,nil,options_panel,"options","Music volume : ",function() sound_settings_callback() end)
    menu_create_slider(30.5,65,"SFX_Volume",1.00,0,0.01,nil,nil,options_panel,"options","Sound effect volume : ",function() sound_settings_callback() end)

    --------------------------------------------------------------------------------

    menu_instantiate_button(80,-180,"button_back",
        function() preset_enter_scale(1.5,1.5,button_table_current[button_selected]) end,

        function(i) preset_exit_scale(button_table[i]) end,

        function(i) preset_scale(button_table[i]) end,
        
        function()  set_button_selection_as_main("main_buttons")  
                    options_panel["targetX"] = 640+options_panel.width/2
                    main_buttons_panel["targetX"] = 0
        end,
    
        "options",
        options_panel)

    --------------------------------------------------------------------------------

    menu_instantiate_button(80,-180,"button_back",
    function() preset_enter_scale(1.5,1.5,button_table_current[button_selected]) end,

    function(i) preset_exit_scale(button_table[i]) end,

    function(i) preset_scale(button_table[i]) end,
    
    function()  set_button_selection_as_main("main_buttons")  
                credits_panel["targetX"] = 640+credits_panel.width/2
                main_buttons_panel["targetX"] = 0
    end,

    "credits",
    credits_panel)

    --------------------------------------------------------------------------------
    
    
    options_panel.Move(options_panel.width,0)
    credits_panel.Move(credits_panel.width,0)
    --menu_instantiate_button(500,350,"button",function(t,button) button_table[button_selected].xscale = math.sin(t/10) end,function() end)
    sound_settings_callback = function() 
    NewAudio.SetVolume("src",  MENU_SETTINGS["Master_Volume"] * MENU_SETTINGS["Music_Volume"])
    NewAudio.SetVolume("mus_mainmenu_bg", MENU_SETTINGS["Master_Volume"] * MENU_SETTINGS["Music_Volume"])
    NewAudio.SetVolume("mus_mainmenu_mus_fade", MENU_SETTINGS["Master_Volume"] * MENU_SETTINGS["SFX_Volume"])
    NewAudio.SetVolume("mus_mainmenu_sfx", MENU_SETTINGS["Master_Volume"] * MENU_SETTINGS["SFX_Volume"])
    end
end

function EnemyDialogueStarting()
    -- Good location for setting monster dialogue depending on how the battle is going.
end

function EnemyDialogueEnding()
    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
    nextwaves = { possible_attacks[math.random(#possible_attacks)] }
end

function DefenseEnding() --This built-in function fires after the defense round ends.
    encountertext = RandomEncounterText() --This built-in function gets a random encounter text from a random enemy.
end

function HandleSpare()
    State("ENEMYDIALOGUE")
end

function HandleItem(ItemID)
    BattleDialog({"Selected item " .. ItemID .. "."})
end

function Update()
    menu_update()

end

--[[

button_table[button_selected].xscale = 1+math.sin(button_table[button_selected]["t_hover"]/73)/10
            button_table[button_selected].xscale = 1+math.sin(button_table[button_selected]["t_hover"]/73)/10
            button_table[button_selected].yscale = 1+math.sin(button_table[button_selected]["t_hover"]/73)/10
            button_table[button_selected].rotation = math.sin(button_table[button_selected]["t_hover"]/91)*3
]]