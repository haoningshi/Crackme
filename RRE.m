
function [ RRE_Redundant] = RRE( Reader,Tag,r)
% Reader: num_reader ; Tag: num_tag ; 
% r: radius of reader; 
%Reader=100;Tag=100; r=10;
        x1=Reader*rand(1,Reader); % The number of readers
        y1=Reader*rand(1,Reader);
        x2=Tag*rand(1,Tag); % The number of tags
        y2=Tag*rand(1,Tag);
        sz=50000;  %radius=5
        scatter(x1,y1,sz,'k');
        hold on
        scatter(x2,y2,500,'.'); 
        hold off
        legend('Reader','Tag')
% RRE Algorithm
%%%%%%%%%%%%%%%%%%(Find readers with tags)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tag_num=zeros(1,Reader);
for j=1:Reader
    for i=1:Tag
        if Distance(x1(j),y1(j),x2(i),y2(i))<=r
          tag_num(j)=tag_num(j)+1;
        end
        
    end

end
%disp(strcat('The number of tags covered by each reader(i):  ',num2str(tag_num))); 
%[max_tagnum,index]=max(tag_num);

tag_num1=tag_num;   % the number tags covered by readers 
non_redundant_reader=0;
for k=1:Reader      % Find the reader with the maxmium tags and deactive it
    [max_tagnum,index]=max(tag_num1); % Find the reader with maxlmum tags
for i=1:Tag
     if Distance(x1(index),y1(index),x2(i),y2(i))<=r && isnan(x2(i)|y2(i))==0;  
          x2(i)=nan;   %% Remove the tag
          y2(i)=nan;
          tag_num1(index)=tag_num1(index)-1; %%the number of tag -1 coverd by the reader
          if tag_num1(index)~=tag_num(index)
            tag_num1(index)=nan;
             non_redundant_reader=non_redundant_reader+1;
             %tag_num1=tag_num1(~isnan(tag_num1));
          end    
     end       
end
end

RRE_Redundant=Reader-non_redundant_reader;
end
