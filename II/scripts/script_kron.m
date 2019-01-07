%% Kronecker Vector Product or Block Algorithms Can Make a Difference
% This script compares two different approaches for computing a structured
% matrix-vector product.
%
% Author: H. Martin Buecker, buecker@acm.org, Copyright 2015,
% Date:   04/16/2015

%% Problem Definition
% Let $A$ and $B$ denote two $k \times k$ matrices and let $x$ be a vector
% of length $k^2$. Now, consider the matrix-vector product
%
% $$y = (A \otimes B) x$$
%
% in which the matrix consists of the Kronecker product of $A$ and $B$.
% Two different approaches for the computation of this matrix-vector
% product are compared:
%
% *  *Straightforward approach (SF):* The product is computed by first
%     setting up the matrix $(A \otimes B)$ and then multiplying it by $x$.
% *  *Matrix-matrix-matrix product approach (MMM):* The product is computed
%     by reformulating it in the form of a matrix-matrix-matrix product.
%

%% Numerical Experiments
% The following code loops over the problem size and computes the
% matrix-vector product using the two approaches.

clear all
close all
imax = 3;

% Choose the range of the problem size.
k_min = 50;
k_max = 120;
k_inc = 10;
k_vec = k_min:k_inc:k_max;

k_cnt = 0;
for k = k_vec
    k_cnt = k_cnt+1;
    
    % Generate two matrices A and B and some vector x
    m = k;
    n = k;
    p = k;
    q = k;
    A = randi(imax,m,n);
    B = randi(imax,p,q);
    x = ones(n*q,1);
    
    % Straightforward approach
    tic
    y_sf = kron(A,B)*x;
    t_sf = toc;
    
    % Matrix-matrix-matrix approach
    tic
    y_mmm = KronVecProd(A,B,x);
    t_mmm = toc;
    
    % Store timing results for plotting
    time(1,k_cnt) = t_sf;
    time(2,k_cnt) = t_mmm;
    
    % Check the results numerically
    % Choose tolerance to test equality of numerical values
    tol = 1.e-8;
    r = norm(y_sf - y_mmm)/norm(y_sf);
    if  r ~= 0 && r > tol
        error('The two approaches differ numerically!');
    end
    
end

%% Plot the Timing Results
% The following statements plot a graph comparing the time needed to
% the Kronecker vector product by the two approaches when increasing
% the problem size |k|.

% Choose colors
if exist('linspecer.m')==2
    N = 9;
    lineStyles = linspecer(N);% N colors for you to use: lineStyles(i,:)
    colormap(linspecer);      % set your colormap
    
    col1 = lineStyles(1,:);
    col2 = lineStyles(2,:);
    col3 = lineStyles(3,:);
else
    col1 = 'r';
    col2 = 'b';
    col3 = 'g';
end

msize = 7;
lwidth = 1.0;
shg,plot(k_vec, time(1,:),...
    'Color',col1,'MarkerFaceColor',col1,'MarkerEdgeColor',col1,...
    'Marker','s','MarkerSize',msize,'LineStyle','-','LineWidth',lwidth)
hold on
plot(k_vec, time(2,:), ...
    'Color',col2,'MarkerFaceColor',col2,'MarkerEdgeColor',col2,...
    'Marker','o','MarkerSize',msize,'LineStyle','-','LineWidth',lwidth)
xlabel('k');
ylabel('Time')
legend('Straightforward','Matrix-matrix-matrix','Location','NorthWest')
%%
% The following statements plot a graph showing the ratio of the times
% given in the previous figure. More precisely, it gives the time of the
% straightforward approach divided by the time of the matrix-matrix-matrix
% approach.

figure
plot(k_vec, time(1,:)./time(2,:), ...
    'Color',col3,'MarkerFaceColor',col3,'MarkerEdgeColor',col3,...
    'Marker','d','MarkerSize',msize,'LineStyle','-','LineWidth',lwidth)
xlabel('k');
ylabel('Time(SF)/Time(MMM)')

