clc
clear all
pulse_len=10000;
X=randi([0 1],1,pulse_len); % A sequence of random bits
d=2*X-1;
x=zeros(1,5*pulse_len);% Coded sequence initilazation
fs=20; % Number of samples per period
Y=zeros(1,fs*5*pulse_len);
T=0.05; 
for q=0:pulse_len-1
t=q*T:((((q+1)*T))-(q*T))/19:((q+1)*T);
yb=round(d(q+1)*(heaviside(t-q*T)-heaviside(t-((q+1)*T))));
Yb(fs*q+1:fs*q+fs)=yb; % Sampled siganl to be transmitted
end
for i=0:pulse_len-1
 x(5*(i+1)-2:5*(i+1))= X(i+1);
end
x= 2*x-1; % A function that maps 0 and 1 to -1 V and +1 Vrespectively
for k=0:5*pulse_len-1
t=k*T:((((k+1)*T))-(k*T))/19:((k+1)*T);
y=round(x(k+1)*(heaviside(t-k*T)-heaviside(t-((k+1)*T))));
Y(fs*k+1:fs*k+fs)=y; % Sampled siganl to be transmitted
end
EbN0dB=0:10; %The bit energy to the noise power density ratio indB
EbN0=10.^(EbN0dB./10);
L=length(Y); % The length of the sampled signal
Lb=length(Yb);
Ebb=fs*sum(d.^2)/(pulse_len); % The bit energy
 Eb=fs*sum(x.^2)/((pulse_len));
N0b=Ebb./EbN0; % Noise power density
N0=Eb./EbN0; % Noise power density
noise=zeros(length(EbN0dB),L); %Noise initializatio
noiseb=zeros(length(EbN0dB),Lb);
z=zeros(length(EbN0dB),L); %Received signal initialization(signal + AWGN)
 zb=zeros(length(EbN0dB),Lb); %Received signal initialization(signal + AWGN)
% % Matched Filter
m=zeros(length(EbN0),5*pulse_len); %Output of matched filter
mb=zeros(length(EbN0),pulse_len);
meb=zeros(1,length(EbN0)); %Number of errored bits using matchedfilter
mrb=zeros(1,length(EbN0));

me=zeros(1,length(EbN0)); %Number of errored bits using matchedfilter
me1=zeros(1,length(EbN0)); %Number of errored bits using matchedfilter
mr1=zeros(1,length(EbN0)); %Number of errored bits using matchedfilter
mr=zeros(1,length(EbN0));
for k=1:length(EbN0dB) %For each instance of Eb/N0
noise(k,:)=sqrt(N0(k)/2).*randn(1,L); %Gaussian noise
noiseb(k,:)=sqrt(N0b(k)/2).*randn(1,Lb);
z(k,:)= Y+noise(k,:); %Signal + Noise
zb(k,:)=Yb+noiseb(k,:);
h=ones(1,fs); % Impulse response of matched filter
 for j=1:5*pulse_len
 match_filter=conv(h,z(k,((j-1)*fs+1):(fs*j))); %using matchedfilter
 m(j)=match_filter(fs);
 end
 for f=1:pulse_len
 match_filterb=conv(h,zb(k,((f-1)*fs+1):(fs*f))); %usingmatched filter
 mb(f)=match_filterb(fs);
 end
% %%%%%%%%%%%%%%%%%%Detected the filteredsignal%%%%%%%%%%%%%%%%%%%%%%%%%
m1=zeros(length(EbN0),5*pulse_len); %Signals detected from matchedfilter
u=zeros(length(EbN0),5*pulse_len); %Signals detected from matched filter
m11=zeros(length(EbN0),pulse_len); %Signals detected from matchedfilter
m1b=zeros(length(EbN0),pulse_len);
for l=0:5*pulse_len-1
if m(l+1)>0
m1(k,l+1)=1;
else
m1(k,l+1)=-1;
end
end
u=(m1+1)/2;
 for r=0:pulse_len-1
 if sum(m1(k,5*(r+1)-2:5*(r+1)))>0
 m11(k,r+1)=1;
 else
 m11(k,r+1)=-1;
 end
 end
for p=0:pulse_len-1
if mb(p+1)>0
m1b(k,p+1)=1;
else
m1b(k,p+1)=-1;
end
end
[meb(k),mrb(k)]=symerr(d, m1b(k,:));
[me1(k),mr1(k)]=symerr(d, m11(k,:));
[me(k),mr(k)]=symerr(x, m1(k,:));
end
figure
semilogy(EbN0dB,mr1,'-ro',EbN0dB,mrb,'-g*')
xlabel('Eb/No (dB)')
ylabel('Pe')
title('Pe vs Eb/No for Coded and Uncoded tranmission')
legend('coded','Uncoded', 'location', 'northeast')
grid
xlim([0 10])
hold off;