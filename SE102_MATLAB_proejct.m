A = imread('test.jpg');

A_BW = A;

%Changing to b&w image
for i=1:size(A)
    for j=1:size(A)
        if (A(i, j, :) ~= 255)
            A_BW(i, j, :) = 0;
        end
    end
end

%Now we are dealing with only 1 value of RGB, since every value is either 0
%or 255
A_BW = A_BW(:,:,1);

%Finding borders
x = 1:size(A_BW, 1);
row_border = 0;
for i=1:length(x)
    row_border_search = find(A_BW(:,i)==0); %Find the black lines
    borders = 0;
    temp = 1;
    for j=1:length(row_border_search)-1
        if (row_border_search(j+1) - row_border_search(j) > 1)
            borders = borders+1;
            row_border(i, borders) = mean(row_border_search(temp:j));
            temp = j+1;
        end
    end
    if (isempty(row_border_search)==0)
        row_border(i, borders+1) = mean(row_border_search(temp:j));
    end
end

%Finding borders(again with columns)
x = 1:size(A_BW, 1);
column_border = 0;
for i=1:length(x)
    column_border_search = find(A_BW(i,:)==0); %Find the black lines
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

row_border = row_border';
column_border = column_border';

image(A)
hold on;
for i=1:size(row_border, 1)
    x = 1:size(A_BW, 1);
    row_border_new = row_border(i, :);
    x(length(row_border_new)+1:end) = [];
    zero_in_row = find(row_border_new == 0);
    row_border_new(zero_in_row) = [];
    x(zero_in_row) = [];
    
    xq = x(1):0.25:x(end);
    y = spline(x, row_border_new, xq);
    plot(x, row_border_new, 'o')
   
    x = 1:size(A_BW, 1);
    column_border_new = column_border(i, :);
    x(length(column_border_new)+1:end) = [];
    zero_in_column = find(column_border_new == 0);
    column_border_new(zero_in_column) = [];
    x(zero_in_column) = [];
    
    xq = x(1):0.25:x(end);
    y = spline(x, column_border_new, xq);
    plot(column_border_new, x, 'o')
    axis([0 size(A, 1) 0 size(A, 2)])
    axis equal
end 
hold off;
