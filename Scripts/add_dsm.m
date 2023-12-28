clear;
chart_name = find_system(gcs,'SearchDepth','inf','MaskType','Stateflow');
if length(chart_name) > 1
    chart_name = chart_name{menu('select chart', chart_name)};
end
subsys_path = find_system(gcs,'SearchDepth','1','BlockType','SubSystem');
if length(subsys_path) > 1
    subsys_path = subsys_path{menu('select chart', subsys_path)} ;
else
    subsys_path = subsys_path{1};
end
chart = find(sfroot,'-isa','Stateflow.Chart',Path=string(chart_name));
data = find(chart,'-isa','Stateflow.Data');
dsms = find(data,'Scope','Data Store Memory');
for i = 1:length(dsms)
    dsm = dsms(i);
    dsm_name = dsm.('Name');
    dsm_path = [gcs '/' dsm_name];
    dsw_path = [dsm_path '_write'];
    dsr_path = [dsm_path '_read'];
    add_block('simulink/Signal Routing/Data Store Memory',dsm_path);
    set_param(dsm_path,'SignalType','real');
    set_param(dsm_path,'DataStoreName',dsm_name);
%     set_param(dsm_path,'InitialValue',[upper(dsm_name),'_INIT']);
    add_block('simulink/Signal Routing/Data Store Write',dsw_path);
    set_param(dsw_path,'DataStoreName',dsm_name);
    add_block('simulink/Signal Routing/Data Store Read',[dsm_path '_read']);
    set_param(dsr_path,'DataStoreName',dsm_name);
    %         set position for DSM
    posDst = get_param(subsys_path,'Position');
    % subsys coordinates
    dx1 = posDst(1,1);
    dx2 = posDst(1,3);
    dy2 = posDst(1,4);
    % DSM coordinates
    x1 = (dx1 + round((dx2-dx1)/2)) - 100;
    y1 = dy2 + 100;
    if i-1 > 0
        prev_dsm = dsms(i-1);
        prev_dsm_name = prev_dsm.('Name');
        prevpos = get_param([gcs '/' prev_dsm_name],'Position');
        py2 = prevpos(1,4);
        y1 = py2+20;
    end
    x2 = x1+200;
    y2 = y1+40;
    set_param(dsm_path,'Position',[x1 y1 x2 y2]);
    %DSW coordinates
    wx1 = x1-230;
    wx2 = x1-30;
    set_param([dsm_path '_write'],'Position',[wx1 y1 wx2 y2]);
    %DSR coordinates
    rx1 = x2+30;
    rx2 = x2+230;
    set_param([dsm_path '_read'],'Position',[rx1 y1 rx2 y2]);
    %add inport
    ip_path = [dsm_path '_in'];
    add_block('simulink/Quick Insert/Ports & Subsystems/Inport',ip_path);
    blk_oph = get_param(ip_path,'PortHandles');
    ix1 = wx1-170;
    ix2 = wx1-150;
    iph = get_param(dsw_path,'PortHandles');
    ip_pos = get_param(iph.Inport(1),'Position');
    iy1 = ip_pos(1,2)-5;
    iy2 = iy1+14;
    set_param(ip_path,'Position',[ix1 iy1 ix2 iy2]);
    add_line(gcs,blk_oph.Outport(1),iph.Inport(1),'autorouting','smart');
    % add outport
    op_path = [dsm_path '_out'];
    add_block('simulink/Quick Insert/Ports & Subsystems/Outport',op_path);
    blk_iph = get_param(op_path,'PortHandles');
    ox1 = rx2+150;
    ox2 = rx2+170;
    oph = get_param(dsr_path,'PortHandles');
    op_pos = get_param(oph.Outport(1),'Position');
    oy1 = op_pos(1,2)-5;
    oy2 = oy1+14;
    set_param(op_path,'Position',[ox1 oy1 ox2 oy2]);
    add_line(gcs,oph.Outport(1),blk_iph.Inport(1),'autorouting','smart');
    disp(['Added: ' dsm_name]);
end
save_system(bdroot);
% export_dsms;
disp('Done.');
% end %fun

