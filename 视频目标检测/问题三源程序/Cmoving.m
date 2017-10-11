clear
A = load('car6.mat');
car = A.obj.XX;
len = size(car,2);
ishape = A.obj.siz;
row = ishape(1);
col = ishape(2);
vthresh = 0.001;
othresh = 0.001;
cthresh = 0.02;
alph = 0.8;
opticFlow = opticalFlowLK('NoiseThreshold',othresh);
backimg = reshape(car(:,1), ishape);

miu = backimg;
co = zeros(ishape);
% co = double(backimg')*double(backimg);
for i = 2:len
    img = reshape(car(:,i), ishape);
    %imshow(img)
    %pre_corners = Cornerdetect(back,cthresh);
    basecor = Cornerdetect(miu,cthresh);
    flow = estimateFlow(opticFlow,basecor);  %光流法追踪
    corners = Cornerdetect(img,cthresh);
    flow = estimateFlow(opticFlow,corners); 
    vx = flow.Vx;
    vy = flow.Vy;
    ca = vx.^2+vy.^2;
    p_features = basecor;
    [p_r,p_c,p_v] = find(p_features ~= 0);  %去除变化太快的特征点
    [c_r,c_c,c_v] = find(corners~=0);
    p_features = [p_r p_c];
    c_features = [c_r c_c];
    p_features = p_features((1:50),:);
    c_features = c_features((1:50),:);
    H = Homography(p_features',c_features');   %计算单应矩阵
    
    %标准化
    himg = ones(3,row*col);
    for p = 1:row
        for q = 1:col
            himg(:,(p-1)*col+q) = [p;q;1];
        end
    end
    wraped = inv(H) * himg;
    bimg = img; % 不重叠部分用新图
    for num = 1 : row*col       %tp为totalpixel
        wrapedrow=int16(wraped(1,num));
        wrapedcol=int16(wraped(1,num));
        if wrapedrow<row && wrapedcol<col && wrapedrow>0 && wrapedcol>0
            bimg(wrapedrow,wrapedcol) = img(himg(1,num),himg(1,num));
        end
    end
    %imshow(bimg);
    %pause;
    
    %得到背景图后检测
%     coback = co;  %求xb的协方差
%     Dc = zeros(ishape);  %二值矩阵
%     for num = 1 : row*col       %tp为totalpixel
%         wrapedrow=int16(wraped(1,num));
%         wrapedcol=int16(wraped(1,num));
%         if wrapedrow<row && wrapedcol<col && wrapedrow>0 && wrapedcol>0
%             miub = miu(wrapedrow,wrapedcol);
%             cob = co(wrapedrow,wrapedcol);
%         else
%             miub = miu(himg(1,num),himg(1,num));
%             cob = co(himg(1,num),himg(1,num));
%         end
%         Ic = img(himg(1,num),himg(1,num));
%         Dc(himg(1,num),himg(1,num)) = (Ic-miub)^2/(cob^2);  %c和b的比较
%         coback(himg(1,num),himg(1,num)) = cob;
%     end
%     res = Dc>0;
    
    check = abs(double(bimg)-double(miu))-10000*double(co);
    res = check>0;
    %背景更新
%      miu = (1-alph)*bimg + alph*img;
%      co = (1-alph)*(im2double(coback)'*im2double(coback)) + alph*im2double((img - bimg))'*im2double((img-bimg));
    miu = (1-alph)*bimg + alph*img;
    co = ((1-alph)*(co.^2)+alph*((double(img)-double(bimg)).^2)).^(1/2);
    imshow(res);
    pause;
    
end
 
   
 

