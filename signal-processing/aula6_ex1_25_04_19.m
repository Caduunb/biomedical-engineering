%% 
t = linspace(0,2*pi);
plot (t, sin(t));
hold on;
%%
plot (t, cos(t));
%%
plot (t, sin(2*pi*10*t));

%%
hold off;
%%
plot (t, cos(2*pi*3*t));
