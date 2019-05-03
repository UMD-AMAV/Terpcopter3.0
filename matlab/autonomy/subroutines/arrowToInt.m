function [val] = arrowToInt(src,event)
   disp(event.Key);
   global key_roll  key_pitch;
   switch event.Key
       case 'leftarrow'
           key_roll = key_roll - 1;
       case 'uparrow'
           key_pitch = key_pitch + 1;
       case 'rightarrow'
           key_roll = key_roll + 1;
       case 'downarrow'
           key_pitch = key_pitch + 1;
   end
end