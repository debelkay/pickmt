function [outstruct]=saveguiout(instruct,newdata,num)


outstruct = instruct;

if length(newdata)~=0
    ff = fieldnames(newdata);
    for ii=1:length(ff)
        estr = ['outstruct(',num2str(num),').',char(ff(ii)),' = newdata.',char(ff(ii)),';'];
        eval(estr)
    end
end

