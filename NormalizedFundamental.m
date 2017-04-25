function [ x, y, T ] = NormalizedFundamental( x, y )
    
m_x = sum(x)/length(x);
m_y = sum(y)/length(y);
d = sum(sqrt((x-m_x).^2 + (y-m_y).^2))/length(x);
T = [sqrt(2)/d, 0, -m_x*sqrt(2)/d; 0, sqrt(2)/d, -m_y*sqrt(2)/d; 0, 0, 1 ];
p = T*[x;y;ones(1,length(x))];
p = p(1:2, :);

x = p(1,:);
y = p(2,:);

end

