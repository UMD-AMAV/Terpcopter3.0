function num_worker(num)

myCluster = parcluster('local');
myCluster.NumWorkers = num;  % 'Modified' property now TRUE
saveProfile(myCluster);    % 'local' profile now updated,
                           % 'Modified' property now FALSE  