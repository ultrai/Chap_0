function attnCoeff=atten(img)
dblImg = double(img);
sz = size(dblImg);

colIntegralImg = cumsum(dblImg,1);
attnCoeff = 1-(colIntegralImg./repmat(colIntegralImg(end,:),[sz(1),1]));
end
