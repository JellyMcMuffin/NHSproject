clear; whos
fileSenses = containers.Map
sensetivities = [0.4966112418545621212]
for i=1:length(filenames)
    fileSenses(filenames(i)) = sensetivities(i)
end


fileSenses('foo')