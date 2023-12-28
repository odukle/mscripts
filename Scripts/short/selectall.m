function selectall(BlockType)
op = find_system(gcs,'SearchDepth',1,'LookUnderMasks','all','BlockType',BlockType);
for i=1:length(op)
    set_param(op{i},'Selected','on');
end
end