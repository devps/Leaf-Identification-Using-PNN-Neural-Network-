function classification_result=pcapnn(data)

global five net 
input=zeros(1,5);
mean=[0.9827030665 0.5703967383 0.6805194702 4.020509548 4.085711876 0.2513362684 0.3499916393 0.4151340380 0.4476704972 1.824143621 2.554899959 1.766719245];
coefficient=[ 0.082108      0.441906      -.219493      -.053109      -.195732      
              0.211737      0.265051      -.383848      -.148749      0.459678      
              0.013618      0.373464      0.270513      -.133321      0.707713    
              -.238958      0.153505      0.515836      0.054339      0.002863     
              -.238954      0.150258      0.516676      0.053792      0.007878     
              0.401933      -.107222      0.218534      -.374213      -.060498     
              0.452342      -.060969      0.230609      -.033004      -.054501      
              0.468901      -.078246      0.167208      0.094383      0.001448    
              0.458396      -.070761      0.189875      0.189905      0.002741     
              0.110354      0.063461      -.068483      0.872970      0.166255    
              -.062833      -.499374      -.130447      -.055009      0.400722    
              -.147499      -.518755      0.107749      0.015269      0.233663]; 

    
    
d=0;
for b=1:5
     for c=1:12    
         s=(data(c)-mean(c))*coefficient(c,b);
         d=d+s;
     end
    input(b)=d;
    d=0; 
end
load net2 net2; % contain variable for NN
load five five; %5*1800
save input input;
five=five';
disp(five)
sprintf('input vector for the pnn');
for m=1:5
input(m)=(input(m)-min(five(m,:)))/(max(five(m,:))-min(five(m,:)));
disp(input(m));
end
input=input';
y=sim(net2,input);
classification_result=vec2ind(y);
