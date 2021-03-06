csvread('Train1.txt')
X = csvread('Train1.txt');
Train1 = csvread('train1.data');
Train2 = csvread('train2.data');
Train3 = csvread('train3.data');

Test1 = csvread('test1.data');
Test2 = csvread('test2.data');
Test3 = csvread('test3.data');





DataSortedClass = sortrows(X, 5);

D1 = zeros(37,5);
D2 = zeros(37,5);
D3 = zeros(37,5);

for i=1:37
    D1(i,:) = DataSortedClass(i, :);
    D2(i,:)  = DataSortedClass(i+37, :);
    D3(i,:) = DataSortedClass(i+76, :);
    
end 

D1(:, 5) = [];
D2(:, 5) = [];
D3(:, 5) = [];
% Graphing some of the data 
%{
    Classes 2 and 3 are separable-ish in:
        Sepal Width 
        Petal Length 
        Petal Width 
    shown in Graph 2,3 

******some error in class 3 of the 2nd/3rd graph. Getting a point at the
origin 
%}

% Attributes 1,2,3
figure 
hold on
scatter3(D1(:,1), D1(:,2), D1(:,3));
scatter3(D2(:,1), D2(:,2), D2(:,3));
scatter3(D3(:,1), D3(:,2), D3(:,3));
title('Graph of Classes Relative to 3 Attributes');
legend('Class 1', 'Class 2', 'Class 3');
xlabel('Sepal Length');
ylabel('Sepal Width');
zlabel('Petal Length');
hold off


figure 
hold on
scatter(D2(:,2), D2(:,3));
scatter(D3(:,2), D3(:,3));
title('Separation of Classes 2,3 wrt Sepal Width and Petal Length');
xlabel('Sepal Width');
ylabel('Petal Length');
legend('Class 2', 'Class 3');
hold off

figure 
hold on
scatter(D2(:,3), D2(:,4));
scatter(D3(:,3), D3(:,4));
title('Separation of Class 2,3, wrt Petal Width and Length');
ylabel('Petal Width');
xlabel('Petal Length');
legend('Class 2', 'Class 3');
hold off



%{
    Separating the Data 
        -Decision Trees require discrete values for each attribute 
        -Graphing Each attribute, seeing what discretizations we can make

    %Conclusions: 
        1. Petal Width
            class 1 vs 2/3 separable ~.75 
            2/3 ~1.5
        2. Petal Length
            Class 1 vs 2/3 separable ~2
            -2,3 separable ~4.8
        3. Sepal Length 
            class 1 vs 2/3 not separable (~5.5 but not good separation)
            -2/3 not separable 
        4. Sepal width
            -class 1 vs 2 not separable (~3.25 but not good separation)
            -2/3 not separable 
%}

Axis = linspace(0,8,37);
%Attribute 1
figure 
hold on
scatter(Axis,D1(:,1));
scatter(Axis, D2(:,1));
scatter(Axis, D3(:,1));
legend('Class 1', 'Class 2', 'Class 3');
title('Graph of Sepal Length')
xlabel('x');
ylabel('Length cm');

%Decision b/w Class1 and !class 1 ~5.5cm

figure 
hold on
scatter(Axis,D1(:,2));
scatter(Axis, D2(:,2));
scatter(Axis, D3(:,2));
legend('Class 1', 'Class 2', 'Class 3');
title('Graph of Sepal Width')
xlabel('x');
ylabel('Length cm');

figure 
hold on
scatter(Axis,D1(:,3));
scatter(Axis, D2(:,3));
scatter(Axis, D3(:,3));
legend('Class 1', 'Class 2', 'Class 3');
title('Graph of Petal Length')
xlabel('x');
ylabel('Length cm');

figure 
hold on
scatter(Axis,D1(:,4));
scatter(Axis, D2(:,4));
scatter(Axis, D3(:,4));
legend('Class 1', 'Class 2', 'Class 3');
title('Graph of Petal Width')
xlabel('x');
ylabel('Length cm');



%{
   Testing Gain on Simple Set 

  

Testing points 1,2,5 of X relative to Attribute 3 and being Class 3
    -test successful
%}

Test = zeros(3,1);
for i=1:2
    Test(i,:) = X(i,3);
end 
Test(3,:) = X(5,3);
Labels = [1;1;0];
weights = [1/3;1/3;1/3];

%{
    Testing Gain on Complex Set 

    Testing first 10 points of X relative to Attribute 2 and being class 2

%}
attributes = [1;2;3;4];

Test=X(1:10,2);
Labels = [0;0;1;0;0;0;1;1;0;0];
weights= [1/10;1/10;1/10;1/10;1/10;1/10;1/10;1/10;1/10;1/10];

C1 = X(X(1:10,5) == 1, 2);
C2 = X(X(1:10,5) == 2, 2);
C3 = X(X(1:10,5) == 3, 2);

[szC1,~] = size(C1);
[szC2,~] = size(C2);
[szC3, ~] = size(C3);
x1 = linspace(1,szC1,szC1);
x2 = linspace(1,szC2,szC2);
x3=linspace(1,szC3,szC3);
figure 
hold on 
scatter(x1,C1);
scatter(x2, C2);
scatter(x3,C3);
title('Attribute 2 for 1st 10 Data Points');
xlabel('x');
ylabel('Length cm');
legend('Class 1', 'Class 2', 'Class 3');


%{
    Testing ID3 algorithm 

    -success: creates a tree off these 10 data sets
    
%}
Test=X(1:10,:);
Labels = [0;0;1;0;0;0;1;1;0;0];
weights= [1/10;1/10;1/10;1/10;1/10;1/10;1/10;1/10;1/10;1/10];
attributes = [1;2;3;4];

root = ID3(Test, weights, Labels, attributes);

%{
    Testing root_classify 
        -creating tree off first 100 points 
        -testing next 10: 101-120
        C2 vs ! C2
    Results: correctly classified 14/20 test points 
%}

Labels2 = Data2(:,5) ==2;
Data2(:,5) = [];

Weights(1:120,1) = 1/120;
attributes = [1;2;3;4];

rootID3 = ID3(Data2, Weights, Labels2, attributes);
Test2temp = Test1(:,1:4);

Predicted2 = root_classify(Test2temp, rootID3);





%{
    Following Test: 2 misclassifications

%}
attributes = [1;2;3;4];
Test = Data3;
Test(:,5) = [];
Labels = Data3(:,5)==3;
weights(1:120,1) = 1/120;
rootID3 = ID3(Test, weights, Labels, attributes);

testing1 = Test1(:,1:4);
labels1 = Test1(:,5)==3;

Predicted = root_classify(testing1, rootID3);

%{

    ab= Adaboost(@Decision_Tree)

    ab.train(data,labels, num-of-classifiers)

    error = ab.test(test_data, test_labels)
%} 



Test = Data3;
Test(:,5) = [];
Labels = Data3(:,5);


ab = Adaboost(@Decision_Tree);
ab.train(Test, Labels, 6);

testing1 = Test1(:,1:4);
labels1 = Test1(:,5);
error1 = ab.test(testing1, labels1);
Predicted1 = ab.classify(testing1);


%{
    Second Data Set Test
        -Note: tested on 1st 3 data sets, data set 2 gave least error so
        using that 
%}

training2 = Train2(:,1:4);
labels2 = Train2(:,5);
testing2 = Test2(:,1:4);
testlabels2 = Test2(:,5);

ab = Adaboost(@Decision_Tree);
ab.train(training2, labels2, 2);
error1 = ab.test(testing2, testlabels2);
Predicted1 = ab.classify(testing2);

error = zeros(10,1);
for i=1:10
    ab= Adaboost(@Decision_Tree);
    ab.train(training2, labels2, i);
    error(i) = ab.test(testing2, testlabels2);   
    i
end 

figure 
hold on
scatter(linspace(1,10,10), error);
title('Graph of Error as function of Number of Weak Learners');
xlabel('Num. Weak Learners');
ylabel('%Error');





