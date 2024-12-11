import {expect } from "chai";
import {ethers,network} from "hardhat";
import { createInstances } from "../instance";
import { initSigners, getSigners } from "../signers";
import { awaitAllDecryptionResults } from "../asyncDecrypt";

describe ("CrypticClue Tests", function (){
    before (async function(){
        await initSigners();
        this.signers = await getSigners();
        this.relayerAddress = "0x97F272ccfef4026A1F3f0e0E879d514627B84E69";
    });

    beforeEach(async function(){
        const contractFactory = await ethers.getContractFactory("CrypticClue");
        this.contract = await contractFactory.connect(this.signers.alice).deploy();
        await this.contract.waitForDeployment();
        this.contractAddress = await this.contract.getAddress();
        this.instances = await createInstances(this.signers);

    });

    // it('should be able to get the address of player', async function(){

    //     const input = this.instances.alice.createEncryptedInput(this.contractAddress, this.signers.alice.address);
    //     input.addAddress("0xa5e1defb98EFe38EBb2D958CEe052410247F4c80");
    //     const encrypted = input.encrypt();
    //     const tx = await this.contract["inputAddress(bytes32,bytes)"](
    //         encrypted.handles[0],
    //         encrypted.inputProof,
    //     );

    //     await tx.wait();
    //     // expect(tx).to.equal(true);
        
    //     const tx1 = await this.contract.connect(this.signers.alice).decryptPlayer(1,{ gasLimit: 5_000_000 });
    //     await tx1.wait();
    //     await awaitAllDecryptionResults();
    //     const y = await this.contract._player1();
    //     expect(y).to.equal("0xa5e1defb98EFe38EBb2D958CEe052410247F4c80");


    // });

    it('should start the game',async function(){
        const tx = await this.contract.connect(this.signers.alice).createRoom();
        await tx.wait();

        const tx1 = await this.contract.rooms(1);
        // console.log(tx1);

        const tx2 = await this.contract.connect(this.signers.carol).joinRoom(1);
        await tx2.wait();

        const tx3 = await this.contract.rooms(1);
        console.log(tx3);

        // const tx4 = await this.contract.decryptPlayer(1,{ gasLimit: 5_000_000 });
        // await tx4.wait();
        // await awaitAllDecryptionResults();
        // // console.log(tx3);

        // const x1 = await this.contract.add1();  
        // console.log(x1);
        // const x2 = await this.contract.add2();
        // console.log(x2);
        // const y1 = await this.contract.addressMapping(1,1);
        // console.log(y1);
        // const y = await this.contract.addressMapping(1,1);
        // console.log(y)
        // console.log("y is",y[0]);
        // console.log("y is",y[1]);

        // expect(y[1]).to.equal(this.signers.alice.address);
        // expect(y[1]).to.equal(this.signers.carol.address);

        const setNum = await this.contract.connect(this.signers.carol).setSecretNumber(1, 11);
        await setNum.wait();

        const tx30 = await this.contract.rooms(1);
        console.log(tx30);

        const submit = await this.contract.connect(this.signers.alice).submitKeyGuess(1,11);
        await submit.wait();

        const tx31 = await this.contract.rooms(1);
        console.log(tx31);

        const tx00 = await this.contract.decryptSecretNum(1);
        await tx00.wait();
        await awaitAllDecryptionResults();
        const y = await this.contract._guess();
        expect(y).to.equal(11); // 10 

        const tx32 = await this.contract.requestResult(1);
        await tx32.wait();
        await awaitAllDecryptionResults();
        const y1 = await this.contract._result();
        expect(y1).to.equal(false); // 10 
    })

});