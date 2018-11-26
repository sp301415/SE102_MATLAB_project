A = imread('test.png');

A_BW = A
%change to b&w image
for i=1:size(A)
    for j=1:size(A)
        if (A(i, j) ~= 255)
            A_BW(i, j, :) = 0;
        end 
    end
end

A_BW = A_BW(:,:,1);

%finding borders
x = 1:size(A_BW);
for i=1:length(x)
    temp = A_BW(:,i);
    a= find(temp==0);
    if length(a) ~= 0 
        y(i) = mean(a);
    end
end
p = polyfit(x,y,10);
x1 = linspace(0,200);
y1 = polyval(p,x1);
figure
plot(x, y,'r')
hold on
plot(x1,y1)
hold off
axis equal