% function label_all_lines(name)
% load_system(name);
ports = find_system(bdroot,'FindAll','on','type','port');
disp('Labeling: ')
for i = 1:length(ports)
    params = get_param(ports(i),'ObjectParameters');
    port = ports(i);
    line = get_param(port,'Line');
    if isfield(params,'ShowPropagatedSignals') == 1
        sps = get_param(port,'ShowPropagatedSignals');
        if strcmp(sps,'off') == 1
            try
                set_param(port,ShowPropagatedSignals='on');
            catch ME
                if strcmp(ME.identifier,'Simulink:Signals:NoPropSigLabThroughBlock')==1
                    try
                        srcBlock = get_param(line,'SrcBlockHandle');
                        srcBlockName = get_param(srcBlock,'Name');
                        srcBlockType = get_param(srcBlock,'BlockType');
                        if strcmp('DataStoreRead',srcBlockType)==1
                            dstBlock = get_param(line,'DstBlockHandle');
                            dstBlockName = get_param(dstBlock,'Name');
                            dstBlockType = get_param(dstBlock,'BlockType');
                            if strcmp(dstBlockType,'Outport')
                                set_param(line,'Name',string(dstBlockName));
                            end
                        else
                            if strcmp(srcBlockType,'SubSystem') || strcmp(srcBlockType,'Inport')
                                set_param(line,'Name',string(srcBlockName));
                            end
                        end
                    catch ME
                    end
                end
            end
        else
            try
                set_param(line,'Name','');
            catch ME
            end
        end
    else
        try
            port = ports(i);
            line = get_param(port,'Line');
            srcBlock = get_param(line,'SrcBlockHandle');
            srcBlockName = get_param(srcBlock,'Name');
            srcBlockType = get_param(srcBlock,'BlockType');
            if strcmp(srcBlockType,'SubSystem') || strcmp(srcBlockType,'Inport')
                set_param(line,'Name',string(srcBlockName));
            end
        catch ME
            disp(strcat(srcBlockName,' : ',ME.identifier));
        end
    end
end
save_system(bdroot);
disp('Done.')
% end

