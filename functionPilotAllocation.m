function [ Pset] = functionPilotAllocation( R_AP,HMean_Withoutphase,A_singleLayer,M,K,N,tau_p,p)

%Pilot allocation function
%The pilots of first tau_p UEs are allocated randomly. The rest of UEs sequentially pick
%their pilots that give least interference to UEs in the current pilot set.

% M = CellFreeParameter.M;
% K = CellFreeParameter.K;
% N = CellFreeParameter.N;
% tau_p = CellFreeParameter.tau_p;

%Pilot set initialize
Pset=1:tau_p;


for z=1:(K/tau_p)-1
    Pset=[Pset;((tau_p*z)+1)*ones(1,tau_p)];
    ind=[];
    for s=1:tau_p
        %Check fot the coherent interference levels
        [coherentx,~] = functionMMSE_interferenceLevels( R_AP,HMean_Withoutphase,A_singleLayer,M,tau_p,N,tau_p,p,Pset);
        %Select the UE index that creates least interference
        if s ~=1
            coherentx(ind)=nan;
        end
        [~,ind(s)]=min(coherentx);
        x=1:tau_p;
        x(ind)=[];
        Pset(z+1,x)=(z*tau_p)+s+1;
        
    end
    
end
%Order the pilot allocation set
for i=1:K
    [~,c]=find(Pset==i);
    temp=Pset(:,c);
    temp(temp==i)=[];
    PsetOrdered(:,i)=[i;temp];
end

%The output file
Pset=PsetOrdered;

end

