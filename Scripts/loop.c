int readyto = 0;
int readyto1 = 0;
int readyto2 = 0;
int readyto3 = 0;
int ready1 = 1;

void loop() {
    if(ready1 == 1){
        ready1 = 0;
        // thewayyouunderstandme();
    }
    drawDesktop();
    drawAnimation();
    handle_ps2_input();
    ManageTheKB();
    last_scancode1 = last_scancode;
    updateRTC();
    
    // Taskbar
    draw_RectTRANS(768 - 25, 0, 1024, 25, 0x52AA, 3);
    drawButton(768 - 22, 4, 18, 18, 0xFFFF, "", 2);

    drawButton(768 - 22, 26, 90, 18, 0xFFFF, "CMD Prompt", 3);
    drawButton(768 - 22, 127, 90, 18, 0xFFFF, "Welcome", 5);
    drawButton(768 - 22, 228, 90, 18, 0xFFFF, "Piano", 6);
    drawButton(768 - 22, 329, 90, 18, 0xFFFF, "Settings", 7);
    
    drawString(time, 1024 - 77, 768 - 8 - 7, 0xFFFF);

    if (inb(0x1F7) & 0x08) {
        if (address != 0) {
            uint16_t* ptr = (uint16_t*)address;
            for (int i = 0; i < 256; i++) {
                ptr[i] = inw(0x1F0);
            }
            beep();
            address = 0;
        }
    }

    if(buttonStates[7] == 1){
        if(readyto3 == 1){
            add_window(7, 50, 150, 340, 240, "GUI Preferences");
            readyto3 = 0;
        }
    }else{
        readyto3 = 1;
    }

    if(buttonStates[3] == 1){
        if(readyto == 1){
            openConsole();
            readyto = 0;
        }
    }else{
        readyto = 1;
    }

    if(buttonStates[6] == 1){
        if(readyto2 == 1){
            add_window(5, 100, 100, 340, 160, "Piano");
            readyto2 = 0;
        }
    }else{
        readyto2 = 1;
    }
    
    if(buttonStates[5] == 1){
        if(readyto1 == 1){
            add_window(1, 10, 10, 300, 200, title);
            readyto1 = 0;
        }
    }else{
        readyto1 = 1;
    }
    
    if (buttonStates[2] == 1) {
        if (runned == 0) {
            runned = 1; 
            
            if (startOpened) {
                startOpened = 0;
            } else {
                startOpened = 1;
            }
        }
    } else {
        runned = 0;
    }

    if(startOpened){
        draw_Rect(768 - 200 - 25, 0, 150, 200, 0x52AA);
    }
    draw_Rect(768 - 26, 0, 1024, 1, 0xC618);

    for (int i = 0; i < 9; i++) {
        uint16_t grid_row = i / 3;
        uint16_t grid_col = i % 3;
        uint16_t square_l = 4 + 2 + (grid_col * 5); 
        uint16_t square_t = 768 - 22 + 2 + (grid_row * 5);
        draw_Rect(square_t, square_l, 4, 4, 0xFFFF);
    }

    if (last_scancode == 0x3B) {
        last_scancode = 0;
        add_window(3, winX, winY, 70, 70, title2);        
    }

    if (last_scancode == 0x3C) {
        last_scancode = 0;
        openConsole();
    }

    if (last_scancode == 0x3E) {
        last_scancode = 0;
        closeTopWindow();
    }
    
    drawAllWindows(); 
    handleWindowDragging();                
    drawMouse(mouse_x, mouse_y);
    swapBuffers();
}
