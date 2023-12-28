function set_blk_param(param_name,value)
% try
%     load_system(gcs);
% catch ME
%     disp(ME.mesaage);
%     disp('Please open the model first.');
% end
sel_blks = find_system(gcs,'FindAll','on','LookUnderMasks','on','Selected','on');
if numel(sel_blks) == 0
    disp('please select the blocks that you want to change parameter for and run the function again');
else
    bt1 = get_param(sel_blks(1),'BlockType');
    bt2 = get_param(sel_blks(2),'BlockType');
    if strcmp(bt1,bt2)==1
        ns=1;
    else
        ns=2;
    end
    for i = ns:numel(sel_blks)
        set_param(sel_blks(i),param_name,value);
    end
end
end

