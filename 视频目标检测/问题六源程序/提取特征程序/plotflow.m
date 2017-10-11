mat = zeros(25,4);
for i = 10:23
 i1 = imread(strcat('C:\ruanjian\matlab\videopro\去除背景后3\',num2str(i),'.jpg'));
 i2 = imread(strcat('C:\ruanjian\matlab\videopro\去除背景后3\',num2str(i+1),'.jpg'));
 othresh = 0.001;
 opticFlow = opticalFlowLK('NoiseThreshold',othresh);
 flow = estimateFlow(opticFlow,i1);  
 flow = estimateFlow(opticFlow,i2);  
 %plot(flow,'DecimationFactor',[5 5],'ScaleFactor',8);
 vx = flow.Vx;
 vy = flow.Vy;
 vb = (vx.^2+vy.^2).^(1/2);  %scale
 vd = flow.Orientation;      %direction
 miu1 = mean(vb(:));
 delta1 = std(vb(:));
  miu2 = mean(vd(:));
 delta2 = std(vd(:))
 mat(i,1) = miu1;
 mat(i,2) = miu2;
 mat(i,3) = delta1;
  mat(i,4) = delta2;
end
 