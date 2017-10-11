function check(dir,name)
    video = load(strcat(dir,name,'.mat'));
    vmat = video.Ori_H;
    vlen = size(vmat,3);  %输入为三维的矩阵
    Thresh = 1/2;
    fdetector = vision.ForegroundDetector('NumTrainingFrames', 5,'InitialVariance', 30*30,'AdaptLearningRate',false);
    a = 1;
    row = size(vmat,1);
    col = size(vmat,2);
    totalp = row*col;
    for i = 1 : vlen
        frame = vmat(:,:,i);
        learningrate = 1/(a^2);
        fg = step(fdetector, frame, learningrate);
        bw = bwmorph(fg,'open',100); %开操作,先腐蚀后膨胀
        bw = bwmorph(bw,'majority',100); %联通
        SE=strel('rectangle',[10 10]); 
        bw=imdilate(bw,SE);
    %    stats = regionprops(bw, 'ConvexImage'); %划分区域,对找特征有用
        img = bw;
        a = a + 1;
        
        fore = sum(sum(img));  %判断是否有大面积变化
        if fore/totalp > Thresh
            a = 1;
        end
        
        
    %     if size(stats,1) ~=0
    %         img = stats.ConvexImage;
    %     end
        imgname = strcat('G:\matvideo\out\',name,'\fg\', num2str(i), '.jpg');
        imwrite(img,imgname)
    end
    imshow(img)
    img2avi(strcat('G:\matvideo\out\',name,'\fg\'),strcat('G:\matvideo\out\',name,'\'));
end