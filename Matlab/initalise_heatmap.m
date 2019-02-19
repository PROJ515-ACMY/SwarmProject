
% varables
Range_min = 0;
Range_max = 10;
SD_min = 1;
SD_max = 3;


% range
x = [Range_min:.01:Range_max];             % [low lim : resalution : up lim]

% random number
R1 = randi([Range_min Range_max],1);
R2 = randi([SD_min SD_max],1);

% distrobution
norm = normpdf(x,R1,R2);      % (x, center point , (skinny /fat))

% display
figure;
plot(x,norm)

