A = readmatrix('iris.txt');
A = A(:, 1:4) * 10;

test = [50,35,13,3];
trainingdata = A(1:40, :);
dists = zeros(1, 40);
for i = 1:40
    dists(i) = round(norm(test - trainingdata(i, :)));
end

dists = sort(dists);
mins = dists(1:5);
fprintf('The minimum distances for the first point are: \n%2.2f \n%2.2f \n%2.2f \n%2.2f \n%2.2f \n', mins)

test = [72, 30, 58, 16];
dists = zeros(1, 40);

for i = 1:40
    dists(i) = round(norm(test - trainingdata(i, :)));
end

dists = sort(dists);
mins = dists(1:5);
fprintf('The minimum distances for the second point are: \n%2.2f \n%2.2f \n%2.2f \n%2.2f \n%2.2f \n', mins)
