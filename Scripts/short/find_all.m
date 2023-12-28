function output =  findall(type)
if strcmp(type,'Line') ~= 1
    output = find_system(gcs,'SearchDepth',1,'BlockType',type);
else
    output = find_system(gcs,'SearchDepth',1,'type',type);
end
end