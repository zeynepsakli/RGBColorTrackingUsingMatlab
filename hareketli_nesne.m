clc;
close all;
clear all;

imaqreset;

x=0;
y=0;
x1=0;
y1=0;
x2=0;
y2=0;

obj= videoinput('winvideo',1);
src = getselectedsource(obj); 
obj.ReturnedColorspace = 'rgb';
obj.FrameGrabInterval = 5;
        set(obj,'FramesPerTrigger',Inf);
        obj.FramesPerTrigger=Inf;
        
        start(obj);






framesAcquired =5;

    
while (framesAcquired<=1000) 
    
    
      data = getdata(obj,1); 

      
       framesAcquired = framesAcquired + 1; 
       
       data=double(data); 
      data=uint8(data);   
   
     
          
      diff_red = imsubtract(data(:,:,1), rgb2gray(data)); 
      diff_red = medfilt2(diff_red, [3 3]);             
      diff_red = im2bw(diff_red,0.18);                   
     
      
      diff_green = imsubtract(data(:,:,2), rgb2gray(data)); 
      diff_green = medfilt2(diff_green, [3 3]);             
      diff_green = im2bw(diff_green,0.134); 
      
      diff_blue = imsubtract(data(:,:,3), rgb2gray(data)); 
      diff_blue = medfilt2(diff_blue, [3 3]);             
      diff_blue = im2bw(diff_blue,0.15); 
      
  
      % Remove all those pixels less than 300px
      diff_red = bwareaopen(diff_red,1200);
      diff_green = bwareaopen(diff_green,1200);
      diff_blue = bwareaopen(diff_blue,1200);
    
    % Label all the connected components in the image.
     bw1 = bwlabel(diff_red, 8);
     bw2 = bwlabel(diff_green, 8);
     bw3 = bwlabel(diff_blue, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats1 = regionprops(bw1, 'BoundingBox', 'Centroid');
    stats2 = regionprops(bw2, 'BoundingBox', 'Centroid');
    stats3 = regionprops(bw3, 'BoundingBox', 'Centroid');
    
    % Display the image 
   
    imshow(data)
%     figure
%     imshow(data3)
    
    hold on
  
    %This is a loop to bound the red objects in a rectangular box.
    
    for object = 1:length(stats1)
        bb = stats1(object).BoundingBox;
        bc = stats1(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2))), '    Color: Red'));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'red');
            x=bc(1);
               y=bc(2);
         topsecretinfo=[x ; y];
       xlswrite('konum.xlsx',topsecretinfo,'A1:A2'); 
    end
              

   
      for object = 1:length(stats2)
        bb1 = stats2(object).BoundingBox;
        bc1 = stats2(object).Centroid;
        rectangle('Position',bb1,'EdgeColor','g','LineWidth',2)
        plot(bc1(1),bc1(2), '-m+')
        a1=text(bc1(1)+15,bc1(2), strcat('X: ', num2str(round(bc1(1))), '    Y: ', num2str(round(bc1(2))), '    Color: Red'));
        set(a1, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'green');
          x1=bc1(1);
               y1=bc1(2);
          topsecretinfo=[x1 ; y1];
       xlswrite('konum.xlsx',topsecretinfo,'B1:B2');
      end
               
      
                   
      for object = 1:length(stats3)
        bb2 = stats3(object).BoundingBox;
        bc2 = stats3(object).Centroid;
        rectangle('Position',bb2,'EdgeColor','b','LineWidth',2)
        plot(bc2(1),bc2(2), '-m+')
        a2=text(bc2(1)+15,bc2(2), strcat('X: ', num2str(round(bc2(1))), '    Y: ', num2str(round(bc2(2))), '    Color: Red'));
        set(a2, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'blue');
              
        x2=bc2(1);
              y2=bc2(2);
          topsecretinfo=[x2 ; y2];
       xlswrite('konum.xlsx',topsecretinfo,'C1:C2');
         
      end
            
       
   

       
       
    hold off

    
end
clear all
