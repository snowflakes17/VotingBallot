// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

//making a voting contract
//1. v want the ability to accept proposals and store them
//proposal: their name,number

//2. voters & voting ability
//keep track of voting
//check voters r authenticated to vote..

//3. chairman
//authenticate and deploy contract

contract voting{
    // all code goes here...

     //voters: voted=bool, access to vote= uint, vote index=uint

     struct voter{
         uint vote;
         bool voted;
         uint weight;
     }
  struct proposal{
    // bytes are a basic unit measurement of information in computer processing
    //we use bytes instead of strings bcz they cost less gas transactions...

    bytes32 name; // the name of each proposal
    uint voteCount; // no. of accummulated votes
  }

   proposal[] public proposals;

   mapping(address=>voter) public voters; //each voter will have an address
   //voters get address as a key and voter for value 

   address public chairperson;

   constructor(bytes32[] memory proposalNames) {
       
        //memory defines a temporary data location in solidity during runtie only of methods... 
        // v guarentee space for it... 

        // msg.sender=is a global variable that states the person who is currently connecting to the contract
        chairperson=msg.sender;  

        //add 1 to chairperson weight
        voters[chairperson].weight=1;

       //will add proposal names to the smart contract upon deployment
        for(uint i=0;i<proposalNames.length;i++){
              proposals.push(proposal({
                  name: proposalNames[i],
                  voteCount: 0
              }));
      }
   }
   //function authencitace voter
   
   function giveRightToVote(address voter) public{
       require(chairperson==msg.sender,
       'Only the authority can give access to vote');

       //require that the voter hasn't voted yet
       require(!voters[voter].voted, 
        'Voter has not voted yet!');

        //givig the right to vote..
        require(voters[voter].weight==0);
             voters[voter].weight==1;   
   }
   //function for voting

   function vote(uint proposal) public{
       voter storage sender=voters[msg.sender];
       require(sender.weight!=0,'Has no right to vote!!');
       require(!sender.voted,'Already voted');
       sender.voted=true;
       sender.vote=proposal; 

       proposals[proposal].voteCount+=sender.weight;
   } 

   //functions for showing the results..

   //1. function that shows the winning proposal by integer

   function winningProposal() public view returns (uint winningProposal_)   {

       uint winningVoteCount=0;
       for(uint i=0;i<proposals.length;i++){
           if(proposals[i].voteCount>winningVoteCount){
               winningVoteCount=proposals[i].voteCount;
               winningProposal_=i;
           }
       }
   }

   //2. function that shows the winner by name

   function winningName() public view return (bytes32 winningNamr_){
       winningName_=proposals[winningProposal()].name;
   }
}


