
function [tcba_redundant,TCBAtime]=TCBA(Reader,Tag,r) 
% Reader: num_reader ; Tag: num_tag ; 
% r: radius of reader; n:iteration_num
%Reader=50;Tag=50; r=5;
        x1=Reader*rand(1,Reader); % The number of readers
        y1=Reader*rand(1,Reader);
        x2=Tag*rand(1,Tag); % The number of tags
        y2=Tag*rand(1,Tag);
        sz=50000;  %radius=5
        %scatter(x1,y1,sz,'k');
        %hold on
        %scatter(x2,y2,500,'.'); 
        %hold off
        %legend('Reader','Tag')

%TCBA Algorithm ：
tic;
%%%%%%%%%%%%%【Calculate the value of tagcc】%%%%%%%%%%%%%%%%
tagcc=zeros(1,Tag);
for j=1:Reader
    for i=1:Tag
        if showdistance(x1(j),y1(j),x2(i),y2(i))<=r 
            tagcc(i)=tagcc(i)+1;
        end
    end
end
% disp(strcat('tagcc: ',num2str(tagcc)));


%%%%%%%%%%%%%%%%%%%%%【找出cc=1的tag对应的reader（判断reader是否冗余），对于非冗余的reader所覆盖的tag进行锁定】%%%%%%%%%%%%%%%%%%%%%%
%Find the reader corresponding to the tag with cc=1 (determine whether the reader is redundant), 
% and lock the tag covered by the non-redundant reader.
tagholder=zeros(1,Tag);
readerclosed=zeros(1,Reader);
readerredundant=ones(1,Reader);
for j=1:Reader
    for i=1:Tag
        if showdistance(x1(j),y1(j),x2(i),y2(i))<=r && tagcc(i)==1 && tagholder(i)==0
            tagholder(i)=j;
            for k=1:Tag
                if showdistance(x1(j),y1(j),x2(k),y2(k))<=r && tagholder(k)==0
                    tagholder(k)=j;
                end
            end
            readerclosed(j)=1;
            readerredundant(j)=0;
        end 
    end
end
% disp(strcat('tagholder: ',num2str(tagholder)));
% disp(strcat('readerclosed： ',num2str(readerclosed)));
% disp(strcat('readerredundant： ',num2str(readerredundant)));

%%%%%%%%%%%%%【NC】%%%%%%%%%%%%%%%%
for a=1:Reader
    reader.nc(a)=0;
    reader.ncc(a)=0;
    for b=1:Reader
        if showdistance(x1(a),y1(a),x1(b),y1(b))<=2*r && showdistance(x1(a),y1(a),x1(b),y1(b))>0 &&readerclosed(a)==0 && readerredundant(a)==1
            reader.nc(a)=reader.nc(a)+1;
            %%%%%%%%%%%%%【NCC】%%%%%%%%%%%%%%%%
            for i=1:Tag
                if showdistance(x1(b),y1(b),x2(i),y2(i))<=r
                    reader.ncc(a)=reader.ncc(a)+1;
                end
            end
        end
    end
end


%%%%%%%%%%%%%【对于冗余的reader进行操作】%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%【根据reader的nc和ncc值由高到低进行筛选】%%%%%%%%%%%%%%%%
%Operation for redundant readers (CC≠1)
%Filter from high to low according to the nc and ncc values ??of the reader

while (length(find(reader.nc==0))~=Reader)
    reader.ncmax=find(reader.nc==max(reader.nc));
    reader.ncc2=reader.ncc(reader.ncmax);
    reader.nccmax=reader.ncmax(find(reader.ncc2==max(reader.ncc2)));
    ncc=reader.nccmax(1);

    for k=1:Tag
        if showdistance(x1(ncc),y1(ncc),x2(k),y2(k))<=r
           tagcc(k)=tagcc(k)-1;
        end
    end
    reader.nc(ncc)=0;
    readerclosed(ncc)=1;
    
    %对剩下的reader重复最开始的操作进行判断是否为冗余reader
    %Determine whether the remaining reader repeats the initial operation and whether it is a redundant reader.
    
    for j=1:Reader
        if readerclosed(j)==0 && readerredundant(j)==1
            for i=1:Tag
                if showdistance(x1(j),y1(j),x2(i),y2(i))<=r && tagcc(i)==1 && tagholder(i)==0
                    tagholder(i)=j;
                    for h=1:Tag
                        if showdistance(x1(j),y1(j),x2(h),y2(h))<=r && tagholder(h)==0
                            tagholder(h)=j;
                        end
                    end
                    readerclosed(j)=1;
                    readerredundant(j)=0;
                end
            end
        end
    end
end
 disp(strcat('~readerredundant： ',num2str(readerredundant)));
 
%%%%%%%%%%%%%%%%%%%%%【去除没有hold任何标签的reader】%%%%%%%%%%%%%%%%%%%%%%
%Remove the reader without any tags
a=unique(tagholder);
holderid=a(find(a~=0));
disp(strcat('覆盖有标签的reader的rid为：',num2str(holderid)));% The ID of reader with tags
%cla(gca);
for k=holderid
        sita=0:pi/20:2*pi;%角度[0,2*pi]
        xr=x1(k)+r*cos(sita);
        yr=y1(k)+r*sin(sita);
        %readers=plot(xr,yr,'-r');
        %hold on;
end

%%%%%%%%%%%%%【计算冗余的reader数量】%%%%%%%%%%%%%%%%
%Calculate the number of redundant readers
tcba_redundant=Reader-length(holderid);
fprintf('The number of redundant reader calculated by TCBA：%d\n',tcba_redundant);

fprintf('------------------------------------------------\n');
end