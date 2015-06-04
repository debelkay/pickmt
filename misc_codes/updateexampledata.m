load ../../old_pickgui/exampledata/examplewfdata.mat

% rename as needed
for i=1:length(exampledata)
    exampledata(i).dE = exampledata(i).vdataE;
    exampledata(i).dN = exampledata(i).vdataN;
    exampledata(i).dZ = exampledata(i).vdataZ;
    
    exampledata(i).distXYZ = (exampledata(i).stXYZ - exampledata(i).evXYZ)/1e3;
    exampledata(i).eveid = '1001'
end

exampledata = rmfield(exampledata,{'vdataE','vdataN','vdataZ','evloc',...
    'evXYZ','stloc','stXYZ','hypodist','AZ'});
