function [ Redundant_Reader ] = TSA(Reader,Tag,r,n,t)
% Reader: num_reader ; Tag: num_tag ; 
% r: radius of reader; n:iteration_num
% t: linear_multiplier (the maximum numbers of tag covered by readers -1 )
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Tagholder=zeros(1,Tag);
        tagredundant=ones(1,Reader);
        ST=[];
        for k=0:1:n-1
        ST(1,k+1)=t*abs(Tag./Reader)*(n-k)/n  % Threshold sequence
   
        end
for h=1:1:n
    tag_num=zeros(1,Reader); % num_of_tags per reader
     for j=1:Reader
     for i=1:Tag
              if Distance(x1(j),y1(j),x2(i),y2(i))<=r 
               tag_num(j)=tag_num(j)+1;
                if tag_num(j)>ST(h) && Tagholder(i)==0
                 Tagholder(i)=j 
                 end
              end
     end
    end
    
   end
not_redundant_reader=zeros(1,Reader);
    for J=1:Reader
        for I=1:Tag
           if Tagholder(I)==J 
            not_redundant_reader(J)=1;
           end
        end
    end
disp(strcat('Coverage(Ri): ',num2str(tag_num))); %Coverage(Ri)=number of covered tags without holder
disp(strcat('Tagholder(Ti): ',num2str(Tagholder))); % Mark reader number on the tags without holders 
disp(strcat('not_redundant_reader: ',num2str(not_redundant_reader)));
Redundant_Reader=0;
for z=1:Reader
    if not_redundant_reader(z)==0
        Redundant_Reader=Redundant_Reader+1;
    end
end


end

