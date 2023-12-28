% function remove_line_labels(name)
load_system(bdroot);
lines = find_system(bdroot,'FindAll','on','type','line');
for i = 1:length(lines)
    set_param(lines(i),'Name','');
    port = get_param(lines(i),'SrcPortHandle');
    params = get_param(port,'ObjectParameters');
    if isfield(params,'ShowPropagatedSignals') == 1
        try
            set_param(port,ShowPropagatedSignals='off');
        catch ME
        end
    end
end
% end

