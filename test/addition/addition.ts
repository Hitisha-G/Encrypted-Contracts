// import {expect} from "chai";
// import {ethers,network} from "hardhat";
// import { getSigners, initSigners } from "../signers";
// import { createInstances } from "../instance";
// import { awaitAllDecryptionResults } from "../asyncDecrypt";

// describe("Addition Tests",function(){
//     before(async function(){
//         await initSigners();
//         this.signers = await getSigners();
//         this.relayerAddress = "0x97F272ccfef4026A1F3f0e0E879d514627B84E69";
        
//     });

//     beforeEach(async function() {
//         const contractFactory = await ethers.getContractFactory("Addition");
//         this.contract = await contractFactory.connect(this.signers.alice).deploy(2);
//         await this.contract.waitForDeployment();
//         this.contractAddress = await this.contract.getAddress();
//         this.instances = await createInstances(this.signers);

//     });

//     it('should decrypt initial value',async function(){

//         const tx2 = await this.contract.decrypt();
//         await tx2.wait();
//         await awaitAllDecryptionResults();
//         const y = await this.contract._a();
//         expect(y).to.equal(2);

//     } );
    
//         it('should set the value of a',async function(){
//             const tx = await this.contract.setA(2);
//             await tx.wait();
    
//             const tx2 = await this.contract.decrypt();
//             await tx2.wait();
//             await awaitAllDecryptionResults();
//             const y = await this.contract._a();
//             expect(y).to.equal(2);
    
//         });

//     it('should add normal number to encrypted one',async function(){
//         const tx = await this.contract.setA(2);
//         await tx.wait();

//         const tx1= await this.contract.addEN(2);
//         await tx1.wait();

//         const tx2 = await this.contract.decrypt();
//         await tx2.wait();
//         await awaitAllDecryptionResults();
//         const y = await this.contract._a();
//         expect(y).to.equal(4);

//     } );

//     it('should add two encrypted numbers',async function(){
//         // const tx = await this.contract.setA(2);
//         // await tx.wait();

//         const tx1= await this.contract.addEE(2);
//         await tx1.wait();

//         const tx2 = await this.contract.decrypt();
//         await tx2.wait();
//         await awaitAllDecryptionResults();
//         const y = await this.contract._a();
//         expect(y).to.equal(4);

//     } );

//     it('should add encrypted input to number',async function(){
//         const tx = await this.contract.setA(2);
//         await tx.wait();

//         const input = this.instances.alice.createEncryptedInput(this.contractAddress, this.signers.alice.address);
//         input.add64(3);
//         const eInput = input.encrypt();

//         const tx1= await this.contract["addEInput(bytes32,bytes)"](
//             eInput.handles[0],
//             eInput.inputProof,
//         );
//         await tx1.wait();

//         const tx2 = await this.contract.decrypt();
//         await tx2.wait();
//         await awaitAllDecryptionResults();
//         const y = await this.contract._a();
//         expect(y).to.equal(5);

//     } );
    
// });