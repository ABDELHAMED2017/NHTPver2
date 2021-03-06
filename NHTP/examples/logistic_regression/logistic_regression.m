function [out1,out2] = logistic_regression(x,fgh,T1,T2,data)

    Tx    = find(x); 
    Ax    = data.A(:,Tx)*x(Tx); 
    m     = length(data.b);
    eAx   = exp(Ax);
     
    mu    = 1e-6/m; 
    switch fgh
    case 'ObjGrad'        
        if sum(eAx)==Inf 
        Tpos = find(Ax>300); 
        Tneg = setdiff(1:m,Tpos);
        obj  = sum(log(1+eAx(Tneg)))+sum(Ax(Tpos))-sum(data.b.*Ax);                
        else
        obj  = sum(log(1+eAx)-data.b.*Ax); 
        end
        out1 = obj/m;                                     %objective function 
        
        if nargout>1 
        eXx  = 1./(1+eAx);
        out2 = data.At*((1-data.b-eXx)/m) + mu*x;         %gradien
        end
        
    case 'Hess'
        eXx  = 1./(1+eAx);
        d    = eXx.*(1-eXx)/m; 
        XT   = data.A(:,T1);
        s    = length(T1);
        XDt  = (XT.*repmat(d,1,s))';
        out1 = XDt*XT + mu*speye(s);                      %submatrix  containing T rows and T columns of Hessian
        if nargout>1 
        out2 = XDt*data.A(:,T2);                          %submatrix  containing T rows and T0 columns of Hessian
        end
    end
     
end



