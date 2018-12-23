if exist('tr_data','var') && size(tr_data,1) == 50000
  disp('Seems that data exists, clean tr_data to re-read!');
  return;
end;

conf.cifar10_dir = 'P:\ML\cifar-10-batches-mat\cifar-10-batches-mat';
conf.train_files = {'data_batch_1.mat',...
                    'data_batch_2.mat',...
                    'data_batch_3.mat',...
                    'data_batch_4.mat',...
                    'data_batch_5.mat'};
conf.test_file = 'test_batch.mat';
conf.meta_file = 'batches.meta.mat';

load(fullfile(conf.cifar10_dir,conf.meta_file));

% Read training data and form the feature matrix and target output
tr_data = [];
tr_labels = [];
fprintf('Reading training data...\n');
for train_file_ind = 1:length(conf.train_files)
  fprintf('\r  Reading %s', conf.train_files{train_file_ind});
  load(fullfile(conf.cifar10_dir,conf.train_files{train_file_ind}));
  tr_data = [tr_data; data];
  tr_labels = [tr_labels; labels];
end;
fprintf('Done!\n');

% Plot random figures 32x32=1024 pixels r,g,b channels
fprintf('Showing training data...\n');
for data_ind = 1:size(tr_data,1)
  if rand() < 0.0005
    data_sample = tr_data(data_ind,:);
    img_r = data_sample(1:1024);
    img_g = data_sample(1025:2048);
    img_b = data_sample(2049:3072);
    data_img = zeros(32,32,3);
    data_img(:,:,1) = reshape(img_r, [32 32])';
    data_img(:,:,2) = reshape(img_g, [32 32])';
    data_img(:,:,3) = reshape(img_b, [32 32])';
    imshow(data_img./256);
    title(label_names(tr_labels(data_ind)+1));
    drawnow;
    pause(1);
    %input('  Training example <PRESS RETURN>')
  end;
end;
fprintf('Done!\n');

% Read test data and form the feature matrix and target output
fprintf('Reading and showing test data...\n');
load(fullfile(conf.cifar10_dir,conf.test_file));
te_data = data;
te_labels = labels;

for data_ind = 1:size(te_data,1)
  if rand() < 0.0005
    data_sample = te_data(data_ind,:);
    img_r = data_sample(1:1024);
    img_g = data_sample(1025:2048);
    img_b = data_sample(2049:3072);
    data_img = zeros(32,32,3);
    data_img(:,:,1) = reshape(img_r, [32 32])';
    data_img(:,:,2) = reshape(img_g, [32 32])';
    data_img(:,:,3) = reshape(img_b, [32 32])';
    imshow(data_img./256);
    title(label_names(te_labels(data_ind)+1));
    drawnow;
    pause(1);
    %input('  Testing example <PRESS RETURN>')
  end;
end;
fprintf('Done!\n');
%%
accuracy1=cifar_10_evaluate(te_labels,tr_labels(1:length(te_labels)))
randlabel=cifar_10_rand(te_data);
trlabelst=cifar_10_1NN(te_data,tr_data(1:20,:),tr_labels(1:20));
accuracy2=cifar_10_evaluate(trlabelst,te_labels)

N=2
[m,n]=size(tr_data);
for i=1:m
%    tr(i,:)=cifar_10_features(tr_data(i,:));
    Tr(i,:)=cifar_10_featuresext(tr_data(i,:),2^(N+1));
end

%[mu,sigma,covariance,p,~,~]=cifar_10_bayes_learn(tr,tr_labels); 
[Mu,Sigma,Covariance,P,~,~]=cifar_10_bayes_learnext(Tr,tr_labels,2^(N+1)); 

[mte,~]=size(te_data);
for i=1:mte
%   te(i,:)=cifar_10_features(te_data(i,:));
    Te(i,:)=cifar_10_featuresext(te_data(i,:),2^(N+1));
end
%[c1,c2]=cifar_10_bayes_classify(te,mu,sigma,covariance,p);
C2=cifar_10_bayes_classifyext(Te,Mu,Sigma,Covariance,P,2^(N+1));

%accuracy_bayes=cifar_10_evaluate(c1,te_labels);
%accuracy_bayes2=cifar_10_evaluate(c2,te_labels);
accuracy_bayes3(N)=cifar_10_evaluate(C2,te_labels);


accuracy_bayes3(1)=0.2368;
accuracy_bayes3(2)=0.4020;
accuracy_bayes3(3)=0.3093;
accuracy_bayes3(4)=0.2458;

figure
plot(accuracy_bayes3);

for k=1:10
    for j=1:10
        Confusion(k,j)=sum(((c(:)==(k-1)).*(te_labels(:)==(j-1))));
    end
end

sum_=0;
[mu2,sigma2,p2,index2,N2]=cifar_10_bayes_learn(te,c);
for i=1:10
norm{i,:}=normpdf(te(index2{i},1),mu2(i,1),sigma2(i,1)).*normpdf(te(index2{i},2),mu2(i,2),sigma2(i,2)).*normpdf(te(index2{i},3),mu2(i,3),sigma2(i,3)).*p2(i);
correct(i)=Confusion(i,i)/sum(Confusion(i,:));
end


%4 6 2 5
for i=[4 6 2 5]
    figure;
    plot(norm{i,:})
end

%tr=mean(tr,2);
%te=mean(te,2);
net=cifar_10_MLP_train(Tr,tr_labels);
estlabel=cifar_10_MLP_test(Te,net);
accuracy_NN=cifar_10_evaluate(estlabel,te_labels);
  
        

        
    
    
