function [B]=ordfilt3d(Op)

r1=25;
c1=25;

r=r1;
c=c1;




[r_img,c_img,dim]=size(Op);


for i=1:r:r_img
    if (r_img-i>r)
        r=r1;
        for j=1:c:c_img
            if (c_img-j>c)
                
                c=c1;
                a=Op(i:i+r-1,j:j+c-1,:);
                Op(i:i+r-1,j:j+c-1,:)=0;
                [Adhere,index]=max(a,[],3);
                Adhere1=max(max(Adhere));
                [row,col]=find(Adhere==max(max(Adhere)));
                row=max(row);
                col=max(col);
                Op(i+row-1,j+col-1,index)=Adhere1;
                clear a;
                clear Adhere;
            end
            if (c_img-j<c)
                
                c=c_img-j;
                a=Op(i:i+r-1,j:j+c-1,:);
                Op(i:i+r-1,j:j+c-1,:)=0;
                [Adhere,index]=max(a,[],3);
                Adhere1=max(max(Adhere));
                [row,col]=find(Adhere==max(max(Adhere)));
                row=max(row);
                col=max(col);
                Op(i+row-1,j+col-1,index)=Adhere1;
            end
        end
    end
    
    if (r_img-i<r)
        
        r=r_img-i;
        c=c1;
        for j=1:c:c_img
            if c_img-j>c
                
                c=c1;
                a=Op(i:i+r-1,j:j+c-1,:);
                Op(i:i+r-1,j:j+c-1,:)=0;
                [Adhere,index]=max(a,[],3);
                Adhere1=max(max(Adhere));
                [row,col]=find(Adhere==max(max(Adhere)));
                row=max(row);
                col=max(col);
                Op(i+row-1,j+col-1,index)=Adhere1;
            end
            if c_img-j<c
                
                c=c_img-j;
                a=Op(i:i+r-1,j:j+c-1,:);
                Op(i:i+r-1,j:j+c-1,:)=0;
                [Adhere,index]=max(a,[],3);
                Adhere1=max(max(Adhere));
                [row,col]=find(Adhere==max(max(Adhere)));
                row=max(row);
                col=max(col);
                Op(i+row-1,j+col-1,index)=Adhere1;
            end
        end
        
    end
        
end
        
        
B=Op;



end
