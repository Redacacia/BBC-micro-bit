//Adapted for microbit by Tayeb Habib tayeb.habib@gmail.com https://www.redacacia.me 
//A special thank you to Paraschos Paraschos https://goo.gl/5x2vkj
 
f=figure('figure_position',[400,87],'figure_size',[640,462],'auto_resize','on','background',[12], ... // Gui window
'figure_name','micro:bit and Scilab. Measuring the temperature of the processor'); // Gui window

delmenu(f.figure_id,gettext('File'))
delmenu(f.figure_id,gettext('?'))
delmenu(f.figure_id,gettext('Tools'))
toolbar(f.figure_id,'off')

handles.dummy = 0;

// Start measuring button Settings

handles.pb_Start=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle', ... // Start measuring button Settings
'normal','FontName','Cantarell','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1], ...
'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.09375,0.8354167,0.2890625,0.06875],'Relief','default', ...
'SliderStep',[0.01,0.1],'String','Start measuring...','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag', ...
'pb_Start','Callback','pb_Start_callback(handles)')

handles.pb_Stop=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle', ... // Stop measuring button Settings.
'normal','FontName','Cantarell','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1], ...
'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.09375,0.6604167,0.2890625,0.06875],'Relief','default', ...
'SliderStep',[0.01,0.1],'String','Stop measuring...','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag', ...
'pb_Stop','Callback','pb_Stop_callback(handles)')

handles.Out_text=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName', ... // Measuring output box Settings.
'Cantarell','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1], ...
'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.01625,0.5288889,0.3703125,0.0755556],'Relief','default', ...
'SliderStep',[0.01,0.1],'String','','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','Out_text','Callback','Out_text_callback')

Measurment_points =3000; // Measurment tha are plotted.
Ymin = 15; // Y axes minimun.
Ymax =25; // Y axes maximun.

function Real_time_axes()

// Create real time plot axes.

plot2d(Measurment_points:-1:0, zeros(1,Measurment_points+1), color("red")); // Prepare the graph window.

a = gca(); // Get Current Axes.

a.data_bounds = [0, Ymin; Measurment_points, Ymax]; // Setting the size of the axes.

a.axes_bounds = [0.5,0.025,0.50,0.95]; // Setting the position of the graph window.

a.title.text="Temperature history" // Setting the graph name.

a.children.children.tag = "real-time plot"; // Set a tag for the plot.

Box_text ="Waitting for start"; // Measurment display box before start button is pressed or stop button pressed.
set(handles.Out_text,'String',Box_text); // Measurment display box before start button is pressed or stop button pressed.


endfunction

// Create real time plot axes.

Real_time_axes();

function pb_Start_callback(handles)

global Button_state;
serial_port = 4; //microbit's port to PC
Button_state = %t;

Serial_communication = openserial(serial_port,"9600,n,8,1") // Open usb serial communication using default values.

if Serial_communication == -1 then
  disp("Usb communication error");

  else
  disp("Usb communication OK");
end

while Serial_communication ~= -1 & Button_state == %t

Serial_data = readserial(Serial_communication,1); // Read a character from the usb buffer.

   if ascii(Serial_data)== 13 then

    Serial_data_2 = readserial(Serial_communication,3); // Read the string from the Arduino usb send.

    Measurment = strtod(Serial_data_2); // Convert string to double.

    //disp(Measurment); // Output to scilab console.

    Box_text = 'Current temperature : '+string(Measurment)+" °C"; // Measurment display box show Current Temperature.
    set(handles.Out_text,'String',Box_text); // // Measurment display box show Current Temperature.

    e = findobj("tag", "real-time plot"); // Prepare axes for the real time plot.

    // Passing the measurmet temperature to the real time plot.

    Last_data = e.data(:, 2);
    e.data(:, 2) = [Last_data(2:$) ; Measurment];

    sleep(100);

    end // if ascii(Serial_data)== 13 then
    
end // while Serial_communication ~= -1 & Button_state == %t

closeserial(Serial_communication); // Close usb communication.

endfunction

function pb_Stop_callback(handles)

global Button_state;
Button_state = %f;

Box_text ="Waitting for start"; // Measurment display box before start button is pressed or stop button pressed.
set(handles.Out_text,'String',Box_text); // Measurment display box before start button is pressed or stop button pressed.

disp("Stop button is pressed"); // console output.

// Delete real time plot axes.

b = findobj("tag", "real-time plot");
b = gca();
b.children;

// Recreate real time plot axes.

Real_time_axes()

Box_text ="Waitting for start"; // Measurment display box before start button is pressed or stop button pressed.
set(handles.Out_text,'String',Box_text); // Measurment display box before start button is pressed or stop button pressed.

endfunction

function Out_text_callback

endfunction
