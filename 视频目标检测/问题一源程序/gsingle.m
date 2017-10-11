function gsingle(dir,name)
    video = load(strcat(dir,name,'.mat'));
    vmat = video.obj.XX;
    vlen = size(vmat,2);
    ishape = video.obj.siz;
  miu = mean(vmat, 2);
  sigma = std(double(vmat), 0, 2);
   for i = 1 : vlen
        bw = (double(vmat(:,i)) - double(miu)) > 2*sigma;
        img = reshape(bw,ishape);
        imgname = strcat('G:\matvideo\out\',name,'\fg\', num2str(i), '.jpg');
        imwrite(img,imgname)
    end
    imshow(img)
    img2avi(strcat('G:\matvideo\out\',name,'\fg\'),strcat('G:\matvideo\out\',name,'\'));
end