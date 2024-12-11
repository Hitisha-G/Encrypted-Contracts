// import {expect} from "chai";
// import {ethers,network} from "hardhat";
// import { getSigners, initSigners } from "../signers";
// import { createInstances } from "../instance";
// import { awaitAllDecryptionResults } from "../asyncDecrypt";

// describe("EncryptedERC1155 Tests",function(){
//     before(async function(){
//         await initSigners();
//         this.signers = await getSigners();
//         this.relayerAddress = "0x97F272ccfef4026A1F3f0e0E879d514627B84E69";
        
//     });

//     beforeEach(async function() {
//         const contractFactory = await ethers.getContractFactory("EncryptedERC1155");
//         this.contract = await contractFactory.connect(this.signers.alice).deploy("Maydayy", "MYD");
//         await this.contract.waitForDeployment();
//         this.contractAddress = await this.contract.getAddress();
//         this.instances = await createInstances(this.signers);

//     });

//     // it('should mint to owner',async function(){
//     //     const tx = await this.contract.mint(1,1000);
//     //     await tx.wait();

//     //     const tx2 = await this.contract.balanceOf(this.signers.alice.address, 1);
//     //     // await tx2.wait;

//     //     const tx1 = await this.contract._balances(1,this.signers.alice);
//     //     // expect(y).to.equal("500");
//     //     console.log(tx1);

//     //     const tx3 = await this.contract.decryptBalance(this.signers.alice.address,1);
//     //     await tx3.wait();
//     //     await awaitAllDecryptionResults();

//     //     const y = await this.contract._decryptedBalances(1,this.signers.alice.address);
//     //     expect(y).to.equal("1000");

//     // });

//     it('should transfer tokens and show respective correct balances', async function(){

//         const tx0 = await this.contract._balances(1,this.signers.alice);
//         // expect(y).to.equal("500");
//         console.log(tx0);

//         const tx = await this.contract.mint(1,1000);
//         await tx.wait();
        
//         const tx1 = await this.contract._balances(1,this.signers.alice);
//         // expect(y).to.equal("500");
//         console.log(tx1);

//         const tx3 = await this.contract.connect(this.signers.alice).decryptBalance(this.signers.alice.address,1,{ gasLimit: 5_000_000 });
//         await tx3.wait();
//         await awaitAllDecryptionResults();
//         const x = await this.contract.bal();
//         console.log(x);
        

//         const y = await this.contract._decryptedBalances(1,this.signers.alice);
//         console.log(y);
//         expect(y).to.equal("1000");

//         const input = this.instances.alice.createEncryptedInput(this.contractAddress, this.signers.alice.address);
//         input.add64(500);
//         const einput = await input.encrypt();
//         const tx2 = await this.contract["transfer(address, uint256,bytes32, bytes)"](
//             this.signers.bob.address,
//             1,
//             einput.handles[0],
//             einput.inputProof,
//         );
//         await tx2.wait();

//         const tx5 = await this.contract._balances(1,this.signers.alice.address);
//         // expect(y).to.equal("500");
//         console.log(tx5);

//         const tx4 = await this.contract.decryptBalance(this.signers.bob.address,1);
//         await tx4.wait();
//         await awaitAllDecryptionResults();
//         console.log(tx4);
//         const x1 = await this.contract.bal();
//         console.log(x1);

//         const tx6 = await this.contract._balances(1,this.signers.bob);
//         // expect(y).to.equal("500");
        
//         // console.log("alice",tx6);

//         console.log("Bob",tx6);

//         // const y = await this.contract._decryptedBalances(1,this.signers.alice);
//         // expect(y).to.equal("500");


//     });





// });