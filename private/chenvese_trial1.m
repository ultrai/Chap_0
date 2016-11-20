function seg = chenvese_trial1(I,mask,num_iter,mu,method)

            P = double(I);
        mask = mask(:,:,1);
        phi0 = bwdist(mask)-bwdist(1-mask)+im2double(mask)-.5; 
      
        force = eps; 
      
          for n=1:num_iter
              inidx = find(phi0>=0); % frontground index
              outidx = find(phi0<0); % background index
              force_image = 0; % initial image force for each layer 
              for i=1
                  L = im2double(P(:,:,i)); % get one image component
                  c1 = sum(sum(L.*Heaviside(phi0)))/(length(inidx)+eps); % average inside of Phi0
                  c2 = sum(sum(L.*(1-Heaviside(phi0))))/(length(outidx)+eps); % verage outside of Phi0
                  force_image=-(L-c1).^2+(L-c2).^2+force_image; 
              end

              force = mu*kappa1(phi0)./max(max(abs(kappa1(phi0))))+1/1.*force_image;

              force = force./(max(max(abs(force))));

              dt=2.5;
              
              old = phi0;
              phi0 = phi0+dt.*force;
              new = phi0;
              indicator = checkstop1(old,new,dt);

              if indicator % decide to stop or continue 

                  seg = phi0<=0; %-- Get mask from levelset


                  return;
              end
          end;

          seg = phi0<=0;

   
end

function H=Heaviside(z)
Epsilon=10^(-5);
H=zeros(size(z,1),size(z,2));
idx1=find(z>Epsilon);
idx2=find(z<Epsilon & z>-Epsilon);
H(idx1)=1;
for i=1:length(idx2)
    H(idx2(i))=1/2*(1+z(idx2(i))/Epsilon+1/pi*sin(pi*z(idx2(i))/Epsilon));
end
end

function KG = kappa1(I)

I = double(I);
[m,n] = size(I);
P = padarray(I,[1,1],1,'pre');
P = padarray(P,[1,1],1,'post');

fy = P(3:end,2:n+1)-P(1:m,2:n+1);
fx = P(2:m+1,3:end)-P(2:m+1,1:n);
fyy = P(3:end,2:n+1)+P(1:m,2:n+1)-2*I;
fxx = P(2:m+1,3:end)+P(2:m+1,1:n)-2*I;
fxy = 0.25.*(P(3:end,3:end)-P(1:m,3:end)+P(3:end,1:n)-P(1:m,1:n));
G = (fx.^2+fy.^2).^(0.5);
K = (fxx.*fy.^2-2*fxy.*fx.*fy+fyy.*fx.^2)./((fx.^2+fy.^2+eps).^(1.5));
KG =K.*G;
KG(1,:) = eps;
KG(end,:) = eps;
KG(:,1) = eps;
KG(:,end) = eps;
%[u v]=gradient(P);
%temp=sqrt(u.*u+v.*v);
%KG=temp(2:m+1,2:n+1);
KG = KG./max(max(abs(KG)));
end
function indicator = checkstop1(old,new,dt)
layer = size(new,3);

for i = 1:layer
    old_{i} = old(:,:,i);
    new_{i} = new(:,:,i);
end

if layer
    ind = find(abs(new)<=.5);
    M = length(ind);
    Q = sum(abs(new(ind)-old(ind)))./M;
    if Q<=dt*0.001
        indicator = 1;
    else
        indicator = 0;
    end
else
    ind1 = find(abs(old_{1})<1);
    ind2 = find(abs(old_{2})<1);
    M1 = length(ind1);
    M2 = length(ind2);
    Q1 = sum(abs(new_{1}(ind1)-old_{1}(ind1)))./M1;
    Q2 = sum(abs(new_{2}(ind2)-old_{2}(ind2)))./M2;
    if Q1<=dt*.18^2 && Q2<=dt*.18^2
        indicator = 1;
    else
        indicator = 0;
    end
end
return
end


