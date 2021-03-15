fs=5000; %�����źŵĲ�����
%s0=[0;0;0;0]; %������ݱ�����ʼ��
s0 = [];
%s0 = 0;
D=4; %��������ʱ��ϵ��
a=4; %�����������ͣ�����˥����ϵ��
Z=2^(1/12); %���׵İ���Ƶ��ϵ��
tone=220*Z^10; do=tone; re=tone*Z^2; mi=tone*Z^4; fa=tone*Z^5;
so=tone*Z^7; la=tone*Z^9; xi=tone*Z^11;lowre=220;lowmi=220*Z^2;
lowfa=220*Z^3; lowso=220*Z^5;lowla=220*Z^7;lowxi=220*Z^9;none=100000;
shenfa=220*Z^4;shenso=220*Z^6;
% ʾ���ĳ���������
M=[lowla lowxi do lowxi do mi lowxi none lowmi lowla lowso lowla do lowso ....
    none lowmi lowmi lowfa lowmi lowfa do lowmi none do do lowxi shenfa lowfa ...
    lowxi lowxi none lowla lowxi do lowxi do mi lowxi none lowmi lowla lowso...
    lowla do lowso none lowre lowmi lowfa do lowxi do re re mi do do lowxi...
    lowla lowla lowxi shenso lowla none do re mi re mi so re none do do lowxi...
    do mi mi none lowla lowxi do lowxi do re do lowso lowso fa mi re do mi ...
    mi mi la la so so mi re do do re do re so mi mi la la so so mi re do do ...
    re do re lowxi lowla lowla];
L=[1 1 3 1 2 2 4 2 2 3 1 2 2 4 2 1 1 3 1 2 2 4 2 1 1 3 1 2 2 4 2 1 1 3 1 2 ...
    2 4 2 2 3 1 2 2 4 2 1 1 2 1 2 2 1 3 1 4 1 1 1 1 2 2 4 2 1 1 3 1 2 2 6 2 ...
    2 1 1 2 2 6 2 1 1 2 1 1 2 3 1 4 2 2 2 1 1 6 2 3 1 3 1 1 1 4 2 3 1 2 2 6 ... 
    2 3 1 3 1 1 1 4 2 3 1 2 1.5 0.5 4 ]/D;

for i=1:4
    s0i = 0;
    if(i==2 || i==4)
        A =[1 0.2 0.3 0.25 0.25 0.2]; % ����г���ķ���ǿ�ȷֲ�
    else
        A=[1 0 0 0 0 0]; % ��г��
    end
    t=0:1/fs:2; 
    if(i==1 || i==2)
        B=exp(0*t); % �ް���
    else
        B=exp(-a*t); % ָ��������ʽ����
        % һ�κ�����ʽ���磺B=a*(t-2*pi);
    end
    C=[0.2 0.6 1.5 2.2 0.9 1.3]; % ����г���ĳ�ʼ��λ
    for k=1:length(M) % ������������������ֵ�����
        s=0;
        t=0: 1/fs: L(k); % ÿ������ʱ�䳤������
        for j=1:length(A) % ���г�������������ֵ�����
            s=s+A(j)*cos(2*pi*M(k)*j*t+C(j)); % ���г�������źźϳ�
        end
        %s = cos(2*pi*M(k)*t);
        s=s .* B(1:length(s)); % ���������������ʽ�����磩����
        %s(i,:)=zeros(1,length(s));
        s0i=[s0i,s(2:end)]; % ������������ݳ�������
    end
    s0 = [s0; s0i];
end


% ��������
% --------------------------------------------------------------------------
s04=s0(4,:);
format = abs(s04(1:floor(fs*1/D))); % ȡ����ֵ, �ḻ������İ���
Bm = zeros(1, length(format)); % ��ʼ����Ű��������
% w = floor(1 / 3 * length(format) * M(1)/fs); %�����1/3û���ر�ĺ��壬ֻ�ǲ��������ȽϺÿ�
% Լ���� 27 
w = 30;
b0 = 1;
while b0+w < length(format) %ƽ�ƴ��ڻ�ü���ֵ��λ��
    [bm,bx]=max(format(b0:b0+w));
    Bm(b0+bx-1)=bm;
    b0=b0+floor(w/2);
end
% Bm=Bm/max(Bm); %���ֵ��һ��
Bm(Bm==0)=[]; %ȥ��϶��ȡ����
t=0 :length(Bm)/fs*D: length(Bm); %�����ֵΪ1������
Binter=interp1(Bm,t,'spline');

% ȡ������ע�ͼ��ɻ�ͼ
% figure(4);scatter((1: length(Bm)), Bm); title('��ֵ��');
% --------------------------------------------------------------------------
% ���г��
s0fft = abs(fft(s0(4,:)));
xf = s0fft(2:length(s0fft)); % ѡ���������, ȥ��ֱ������
Am = linspace(0, 0, length(xf)); % Ƶ�ʵķ���
fk = linspace(0, 0, length(xf)); % Ƶ�ʵ�λ��
[Am(1),f0]=max(xf); %ȷ����Ƶf0���Ⱥ�λ��
fk(1)=f0;
k=2;
w=5;
while f0*k+w < length(xf) %����ȷ��гƵ���Ⱥ�λ��
    [Am(k),maxf]=max(xf(f0*k-w:f0*k+w));
    fk(k)=f0*k-w+maxf-1;
    k=k+1; % ����ÿ����Ƶ�ı���������ֵ
end
Am=Am/Am(1); %��һ������
figure;
    subplot(2, 2, 1); % 2x2 ͼ���еĵ�һ��ͼ
        plot(format, 'green'); title('��һ�����ڵ�ʱ��ͼ');
    subplot(2, 2, 3); % 2x2 ͼ���еĵ�����ͼ
        plot(format, 'green'); hold on;
        plot(Binter, 'red'); hold off;
        title('������');
    subplot(2, 2, 2); % 2x2 ͼ���еĵڶ���ͼ         
        plot(s0fft);
        title('Ƶ��ͼ');
    subplot(2, 2, 4);% 2x2 ͼ���еĵ��ĸ�ͼ   
        stem(fk, Am);
        title('г��ͼ');

Y = s0(4,:);
sound(Y,fs)   %��������
figure(2)
plot(Y)          %����ͼ
title('ԭʼ�����ź�')
% grid on;

title0=['��г���ް�������ͼ'; '��г���ް�������ͼ' ;'��г���а�������ͼ'; '��г���а�������ͼ'];
figure(3);
for i=1:4
    subplot(2,2,i);
    Y=s0(i,:);
    spectrogram(Y,256,128,256,41000,'yaxis');
    xlabel('ʱ��(s)')
    ylabel('Ƶ��(Hz)')
    title(title0(i,:))
end
audiowrite('try0.wav',s0(4,:),fs);