m=[0 0 0 1 1 1 1 1 1; 1 0 1 0 0 0 0 0 0; 0 0 0 0 0 1 1 1 1];
plot1=scatter(m(1,1),m(1,1),'filled');

for t=1:length(m(1,:))
    plot1.XData = 1:t;
    plot1.YData = (m(1:3,1:t));
%     hold on
%     plot1.XData = 1:t;
%     plot1.YData = (m(2,1:t));
%     hold on
%     plot1.XData = 1:t;
%     plot1.YData = (m(3,1:t));
%     hold on
    pause(0.5);
end


