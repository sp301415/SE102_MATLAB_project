A = imread('test.jpg');

A_BW = A;

% Change original image to Black and White image
for i=1:size(A)
    for j=1:size(A)
        if (A(i, j, :) < 200)
            A_BW(i, j, :) = 0;
        end
    end
end

%Now we are dealing with only 1 value of RGB, since every value is either 0 or 255
A_BW = A_BW(:,:,1);

%Finding borders in Row direction
%Intialize
x = 1:size(A_BW, 1);
row_border = 0;
for i=1:length(x) 
    row_border_search = find(A_BW(:,i)==0); %Find the black lines
    borders = 0; %borders represent how much distinct lines exist
    temp = 1; %temp marks the start of new border
    for j=1:length(row_border_search)-1
        if (row_border_search(j+1) - row_border_search(j) > 1)
            borders = borders+1; %count borders since we found disctinct line
            
            row_border(i, borders) = mean(row_border_search(temp:j)); %calculate 
            %the mean value of the line 
            temp = j+1; %set new temp
        end
    end
    if (isempty(row_border_search)==0) %By above logic, 
        %we cannot calculate the "last" border; so we do it manually.
        row_border(i, borders+1) = mean(row_border_search(temp:j));
    end
end

%Finding borders(again with columns, same logic)
x = 1:size(A_BW, 1);
column_border = 0;
for i=1:length(x)
    column_border_search = find(A_BW(i,:)==0);
    borders = 0;
    temp = 1;
    for j=1:length(column_border_search)-1
        if (column_border_search(j+1) - column_border_search(j) > 1)
            borders = borders+1;
            column_border(i, borders) = mean(column_border_search(temp:j));
            temp = j+1;
        end
    end
    if (isempty(column_border_search)==0)
        column_border(i, borders+1) = mean(column_border_search(temp:j));
    end
end

%Transpose the matrix, because we can :)
row_border = row_border'; 
column_border = column_border';

%Since we marked the borders with relative order, problem occurs when new
%border is calculated, since the computer cannot distinguish between
%existing nth border and new nth border. So we manually distinguish them by
%calculating the difference; if there are countable difference, then they
%must be different borders.
for i=1:size(row_border, 1)
    temp = size(row_border, 2); %Now we count backwards, since it's a lot easier
    for j=size(row_border, 2):-1:2
        if (abs(row_border(i, j)-row_border(i, j-1))>2)
            row_border = [row_border ; zeros(1, size(row_border, 2))]; %We make
            %new row and save it there
            row_border(end, j:temp) = row_border(i, j:temp);
            row_border(i, j:temp) = zeros(1, temp-j+1);
            temp = j-1;
        end
    end
end

%Same logic, now for columns
for i=1:size(column_border, 1)
    temp = size(column_border, 2);
    for j=size(column_border, 2):-1:2
        if (abs(column_border(i, j)-column_border(i, j-1))>2)
            column_border = [column_border ; zeros(1, size(column_border, 2))];
            column_border(end, j:temp) = column_border(i, j:temp);
            column_border(i, j:temp) = zeros(1, temp-j+1);
            temp = j-1;
        end
    end
end

%show original image
image(A)
hold on;

%Now we plot the graph
for i=1:size(row_border, 1)
    %We make sure x and y values coincide
    x = 1:size(A_BW, 1);
    row_border_new = row_border(i, :);
    x(length(row_border_new)+1:end) = [];
    zero_in_row = find(row_border_new == 0);
    row_border_new(zero_in_row) = [];
    x(zero_in_row) = [];
    
    %We ignore matrixes that has only one value; we can't plot it & it 
    %doesn't matter anyway.
    if(length(row_border_new) > 2)
        xq = x(1):0.25:x(end);
    y = spline(x, row_border_new, xq); %we use spline to interpolate between
    %points, pchip can be alternatively used (Google it)
    plot(xq, y, 'Linewidth', 5)
    end
end

for i=1:size(column_border, 1) 
    x = 1:size(A_BW, 1);
    column_border_new = column_border(i, :);
    x(length(column_border_new)+1:end) = [];
    zero_in_column = find(column_border_new == 0);
    column_border_new(zero_in_column) = [];
    x(zero_in_column) = [];
    
    if(length(column_border_new) < 2)
        continue;
    end
    
    xq = x(1):0.25:x(end);
    y = spline(x, column_border_new, xq);
    plot(y, xq, 'Linewidth', 5)
    axis([0 size(A, 1) 0 size(A, 2)])
end 
hold off;

%Now what? we have to:
%1. Find a way to "smartly" distinguish between row and column border
%search
%2. Find a way to use this result.